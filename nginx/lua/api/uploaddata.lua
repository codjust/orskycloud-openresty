
local comm=require("lua.comm.common") 

--上传数据
-- 解析POST请求，根据请求数据对redis进行操作
--请求样例：curl -i '127.0.0.1/api/uploadData.json?uid=1&did=3'
local args = ngx.req.get_uri_args()

local uid = args.uid 
local did = args.did

if not uid or not did then
	ngx.log(ngx.WARN,"bad request args uid,did:",uid,did)
	ngx.exit(ngx.HTTP_BAD_REQUEST)
end

ngx.req.read_body()
local body = ngx.req.get_body_data()
if body == nil then
	ngx.log(ngx.WARN,"request body is nil")
	ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local post_args = comm.json_decode(body)
if  comm.check_args(post_args,{}) == false then
	ngx.log(ngx.WARN,"error request body,probably is not a table")
	ngx.exit(ngx.HTTP_BAD_REQUEST)
end

ngx.log(ngx.WARN,"right request args uid :",uid)
ngx.say(body)