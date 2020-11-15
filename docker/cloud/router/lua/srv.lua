local resolver = require "resty.dns.resolver"

local r, err = resolver:new{
    nameservers = {"8.8.8.8", {"8.8.4.4", 53} },
    retrans = 5,  -- 5 retransmissions on receive timeout
    timeout = 2000,  -- 2 sec
}

function log(msg)
    ngx.log(ngx.ERR, msg, "\n")
end



if not r then
    log("failed to instantiate the resolver: ", err)
    return
end

-- Query SRV
local answers, err, tries = r:query("3679-g.appup.ch", { qtype = r.TYPE_SRV })
if not answers then
    log("failed to query the DNS server: ", err)
    log("retry historie:\n  ", table.concat(tries, "\n  "))
    return
end

if answers.errcode then
    log("server returned error code: ", answers.errcode,
            ": ", answers.errstr)
end

local cjson = require "cjson"
ngx.log(ngx.INFO, "records: ", cjson.encode(answers))

-- Get Port and target IP
if answers[1].port then
    -- resolve the target to an IP
    --local target_ip = r:query(answers[1].target)[1].address
    local target_ip = answers[1].target
    -- pass the target ip to avoid resolver errors
    ngx.var.target = target_ip .. ":" .. answers[1].port

    ngx.log(ngx.INFO, "Target: ", ngx.var.target)
else
        log("DNS answer didn't include a port")
        return abort("Unknown destination port", 500)
end