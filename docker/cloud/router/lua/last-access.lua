-- Command
local cmd = '/usr/local/openresty/nginx/lua/last-access.sh -c ' .. ngx.var.cloudid ..' -a ' .. ngx.var.appid

-- Execute
local fh = assert(io.popen(cmd))
local data = fh:read('*a')
fh:close()
ngx.header.content_type = 'text/plain'

-- Output
ngx.say(data)
ngx.exit(ngx.HTTP_OK)