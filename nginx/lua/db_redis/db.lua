module(..., package.seeall)


function check_data_sersor(rd_data,post_data)
	-- body
	local db_sensor = rd_data["Sensor"]
	if db_sensor == nil then
		return false
	end
	local equal_flag = false
	-- 有一个sensor不存在即返回false,这里可以优化
	for k, _ in pairs(post_data) do
		equal_flag = false
		for i, _ in pairs(db_sensor) do
			if post_data[k]["sensor"] == db_sensor[i]["name"] then
				equal_flag = true
			   	break
			end
		end
		if equal_flag == false then
			return false
		end
	end

	return true
end


function select_data(start,end,res_data)
	local response = []

	for i, data in ipairs(res_data) do
		if is_time_greater_than(data["timestamp"],start) and is_time_less_than(data["timestamp"],end) then
			table.insert(response,data)
		end
	end
end