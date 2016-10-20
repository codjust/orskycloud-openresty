module(..., package.seeall)

-- 校验post data 传感器数据是否已添加
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


function is_compare(src_time,next_time)

-- 这里默认时间格式都为  "2016-10-20 14:51:09"的形式，前面加格式检查
	if string.sub(src_time,1,4) > string.sub(next_time,1,4) then
		return true
	elseif  string.sub(src_time,6,7) > string.sub(next_time,6,7) then
		return true
	elseif  string.sub(src_time,9,10) > string.sub(next_time,9,10) then
		return true
	elseif  string.sub(src_time,12,13) > string.sub(next_time,12,13) then
		return true
	elseif  string.sub(src_time,15,16) > string.sub(next_time,15,16) then
		return true
	elseif  string.sub(src_time,18,19) > string.sub(next_time,18,19) then
		return true
	else
		return false
end

end


function select_data(starttime,endtime,res_data)
	local response = {}
	for _, data in ipairs(res_data) do
		if is_compare(data["timestamp"],starttime) and is_compare(endtime,data["timestamp"]) then
			table.insert(response,data)
		end
	end
	return response
end