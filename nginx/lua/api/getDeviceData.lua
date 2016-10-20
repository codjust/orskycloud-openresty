
--版本1
-- curl -i  '127.0.0.1/api/getDeviceData.json?uid=001&did=001'
--待续的参数    默认值
-- StartTime 否	2015-09-01	 datetime	 小于当前时间	 起始时间
-- EndTime	 否	当前时间	 datetime		 截止时间
-- Interval	 否	1	 int	 大于1	 间隔多少秒取一次数据
-- Start	 否	0	 int		 从第{start}条开始取数据
-- Limit	 否	1000	 int	 1-1000	 一次取多少条数据
-- Order	 否	1	 int	 0或1	 0表示倒叙1表示正序
local redis  = require("lua.db_redis.db_base")
local common = require("lua.comm.common")
local red    = redis:new()
local db_handle = require("lua.db_redis.db")

local args = ngx.req.get_uri_args()
if not args.uid or not args.did then
	ngx.log(ngx.WARN,"post args error")
	ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local response = {}
response.Successful = true
response.Message    = "success"

local StartTime = args.StartTime or "2015-09-01 00:00:00"
local EndTime   = args.EndTime   or ngx.localtime()

if (StartTime and #StartTime ~= 19) or (EndTime and #EndTime ~= 19) then
	response.Successful = false
	response.Message    = "Error time format"
	ngx.say(common.json_encode(response))
	return
end

local res,err = red:hget("uid:"..args.uid,"did:"..args.did)
if err then
	ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE)
end
local res_data = (common.json_decode(res))["data"]

res_data = db_handle.select_data(StartTime,EndTime,res_data)

table.insert(response,res_data)
ngx.say(common.json_encode(response))