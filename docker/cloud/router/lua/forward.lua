function log(msg)
    ngx.log(ngx.ERR, msg, "\n")
end

-- Command
log("Cloud id: " .. ngx.var.cloudid)
log("App id  " .. ngx.var.appid)

local cmd = '/usr/local/openresty/nginx/lua/forward.sh -c ' .. ngx.var.cloudid ..' -a ' .. ngx.var.appid

-- Execute
local fh = assert(io.popen(cmd))
local data = fh:read('*a')
fh:close()

-- Output
if string.find(data, "ERROR") then
    ngx.header.content_type = 'text/plain'
    ngx.say(data)
    ngx.exit(ngx.HTTP_OK)
else
    ngx.var.target = "" .. data
end

