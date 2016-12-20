local tb  = (require "test_base_lua.test_base").new({unit_name="getDeviceData"})
local common  = require("lua.comm.common")
local redis   = require("db_redis.db_base")
local red = redis:new()
local redis_c = require("resty.redis")

-- curl -i  '127.0.0.1/api/getDeviceData.json?uid=001&did=001'
function tb:init()
	--预置数据
	self.uid = string.rep('0', 32)
	self.did = string.rep('1', 32)
	self.uri = '/api/getDeviceData.json?uid='
	self.data = {data = {{sensor = "template", value = 30, timestamp = "2015-10-20 14:50:30"}, {sensor = "weight", value = 56, timestamp = "2016-10-20 14:50:30"}, {sensor = "high", value = 170, timestamp = "2016-11-22 14:50:30"}}}
	red:hset("uid:" .. self.uid, "did:" .. self.did, common.json_encode(self.data))
end


function tb:destroy()
	red:hdel("uid:" .. self.uid, "did:" .. self.did)
end


function tb:test_001_normal_return_data_not_select_time()
	local res, err = ngx.location.capture(self.uri .. self.uid .. "&did=" .. self.did,
		{method = ngx.HTTP_POST})

	assert(res.status == 200)

	local data = common.json_decode(res.body)
	local ret_data = data["1"]
	if common.is_table_equal(ret_data, self.data.data) == false then
		tb:log("ret_data:", common.json_encode(ret_data))
		tb:log("self_data:", common.json_encode(self.data))
		error("return data not equal self.data.")
	end

	local ret_msg     = data["Message"]
	local ret_success = data["Successful"]
	if ret_msg ~= "success" or ret_success ~= true then
		tb:log("ret_msg:", ret_msg)
		tb:log("ret_success:", ret_success)
		error("ret_msg or ret_success failed.")
	end

end


function tb:test_002_normal_return_data_select_time_01()
	local res, err = ngx.location.capture(self.uri .. self.uid .. "&did=" .. self.did .. "&StartTime=2015-10-20 14:50:30",
		{method = ngx.HTTP_POST})

	assert(res.status == 200)

	local data = common.json_decode(res.body)
	local ret_data = data["1"]
	local exp_data = {{sensor = "weight", value = 56, timestamp = "2016-10-20 14:50:30"}, {sensor = "high", value = 170, timestamp = "2016-11-22 14:50:30"}}

	if common.is_table_equal(ret_data, exp_data) == false then
		tb:log("ret_data:", common.json_encode(ret_data))
		tb:log("exp_data:", common.json_encode(exp_data))
		error("return data not equal self.data.")
	end

	local ret_msg     = data["Message"]
	local ret_success = data["Successful"]
	if ret_msg ~= "success" or ret_success ~= true then
		tb:log("ret_msg:", ret_msg)
		tb:log("ret_success:", ret_success)
		error("ret_msg or ret_success failed.")
	end
end


function tb:test_003_normal_return_data_select_time_02()
	local res, err = ngx.location.capture(self.uri .. self.uid .. "&did=" .. self.did .. "&StartTime=2015-10-20 14:50:30&EndTime=2016-11-22 14:50:29",
		{method = ngx.HTTP_POST})

	assert(res.status == 200)

	local data = common.json_decode(res.body)
	local ret_data = data["1"]
	local exp_data = {{sensor = "weight", value = 56, timestamp = "2016-10-20 14:50:30"}}

	if common.is_table_equal(ret_data, exp_data) == false then
		tb:log("ret_data:", common.json_encode(ret_data))
		tb:log("exp_data:", common.json_encode(exp_data))
		error("return data not equal self.data.")
	end

	local ret_msg     = data["Message"]
	local ret_success = data["Successful"]
	if ret_msg ~= "success" or ret_success ~= true then
		tb:log("ret_msg:", ret_msg)
		tb:log("ret_success:", ret_success)
		error("ret_msg or ret_success failed.")
	end
end

tb:run()