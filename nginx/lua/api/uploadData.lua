--上传数据
-- 解析POST请求，根据请求数据对redis进行操作
--请求样例：curl -i '127.0.0.1/api/uploadData.json?uid=1&did=3'
local args = ngx.req.get_uri_args()

-- if  args.uid == nil or args.did == nil then 
-- 	ngx.log(ngx.WARN,"request args uid is nil or did is nil")
-- 	ngx.exit(ngx.HTTP_BAD_REQUEST)
-- end

local uid = args.uid 
local did = args.did

if not uid then
	ngx.log(ngx.WARN,"bad request args uid P:",uid)
	ngx.exit(ngx.HTTP_BAD_REQUEST)
end

ngx.log(ngx.WARN,"right request args uid :",uid)
ngx.say("success")