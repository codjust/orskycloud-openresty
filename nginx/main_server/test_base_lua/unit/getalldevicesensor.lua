local tb  = (require "test_base_lua.test_base").new({unit_name="getalldevicesensor"})
local common  = require("lua.comm.common")
local ljson   = require("lua.comm.ljson")
local redis   = require("db_redis.db_base")
local red = redis:new()
local redis_c = require("resty.redis")

-- curl '127.0.0.1/api/getalldevicesensor.json?uid=001'
function tb:init()
	self.uid   = string.rep('0', 32)
	self.did1  = string.rep('0', 32)
	self.did2  = string.rep('1', 32)
	self.uri   = '/api/getalldevicesensor.json?uid='
	self.data1 = { deviceName = "Test1", description = "description1", createTime = "2016-12-19 23:07:12", Sensor = {{unit = "kg", name = "weight", createTime = "2016-9-12 00:00:00", designation =  "体重"}}, data={{}}}
	self.data2 = { deviceName = "Test2", description = "description2", createTime = "2015-12-19 23:07:12", Sensor = {{unit = "kg", name = "high", createTime = "2016-9-12 00:00:00", designation =  "身高"}}, data={}}

	self.device = self.did1 .. "#" .. self.did2
	-- init redis data
	red:hset("uid:" .. self.uid, "device", self.device)
	red:hset("uid:" .. self.uid, "did:" .. self.did1, common.json_encode(self.data1))
	red:hset("uid:" .. self.uid, "did:" .. self.did2, common.json_encode(self.data2))
end


function tb:destroy()
	red:hdel("uid:" .. self.uid, "device")
	red:hdel("uid:" .. self.uid, "did:" .. self.did1)
	red:hdel("uid:" .. self.uid, "did:" .. self.did2)
end


function tb:test_001_normal_get_all_info()
	local res, err = ngx.location.capture(self.uri .. self.uid,
		{method = ngx.HTTP_POST})
	assert(res.status == 200)
	local data = common.json_decode(res.body)
	local ret_data = data["1"]
	self.data1["data"] = nil
	self.data2["data"] = nil
	if common.is_table_equal(ret_data[1], self.data1) == false and common.is_table_equal(ret_data[2], self.data2) == false then
		tb:log("ret_data1:", ljson.encode(common.json_encode(ret_data[1])))
		tb:log("exp_data1:", ljson.encode(common.json_encode(self.data1)))
		tb:log("ret_data2:", ljson.encode(common.json_encode(ret_data[2])))
		tb:log("exp_data2:", ljson.encode(common.json_encode(self.data2)))
		error("return data not equal exp data.")
	end
end

tb:run()