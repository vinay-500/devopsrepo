function log(msg)
    ngx.log(ngx.ERR, msg, "\n")
    ngx.say(msg)
end

-- Get variables
local cloudid = ngx.req.get_uri_args()["cloudid"]
local appid = ngx.req.get_uri_args()["appid"]
local command = ngx.req.get_uri_args()["command"]

-- Send Secret it
local command = ngx.req.get_uri_args()["secret"]

-- Compare the secret to ensure that Appup router it actually sent this

ngx.header.content_type = 'text/plain'

if not cloudid then
    log("Cloud id not there: ", err)
    return
end

if not appid then
    log("App id not there: ", err)
    return
end

if not command then
    log("command is not there: ", err)
    return
end

-- Command
local cmd = ""

if command == "start" then
    cmd = 'sudo /usr/local/openresty/nginx/lua/start.sh -c ' .. cloudid ..' -a ' .. appid
end

if command == "stop" then
    cmd = 'sudo /usr/local/openresty/nginx/lua/stop.sh -c ' .. cloudid ..' -a ' .. appid
end

if command == "logs" then
    cmd = 'sudo /usr/local/openresty/nginx/lua/logs.sh -c ' .. cloudid ..' -a ' .. appid
end

if command == "status" then
    cmd = 'sudo /usr/local/openresty/nginx/lua/status.sh -c ' .. cloudid ..' -a ' .. appid
end

-- Execute
local fh = assert(io.popen(cmd))
local data = fh:read('*a')
fh:close()


-- Output
ngx.say(data)
ngx.exit(ngx.HTTP_OK)