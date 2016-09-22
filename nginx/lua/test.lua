local myself_module = require "lua.myself_module"

local args = ngx.req.get_uri_args()

local sum = myself_module.sum(args.a,args.b)

ngx.say(sum)
