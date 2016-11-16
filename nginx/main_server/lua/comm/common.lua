module("lua.comm.common", package.seeall)
--基础函数
local json = require(require("ffi").os=="Windows" and "resty.dkjson" or "cjson")


--解析json，封装cjson，加入pcall异常处理
function json_decode(str)
	local json_value = nil
	pcall(function (str) json_value = json.decode(str) end,str)
	return json_value
end


function json_encode( data, empty_table_as_object )
  --lua的数据类型里面，array和dict是同一个东西。对应到json encode的时候，就会有不同的判断
  --对于linux，我们用的是cjson库：A Lua table with only positive integer keys of type number will be encoded as a JSON array. All other tables will be encoded as a JSON object.
  --cjson对于空的table，就会被处理为object，也就是{}
  --dkjson默认对空table会处理为array，也就是[]
  --处理方法：对于cjson，使用encode_empty_table_as_object这个方法。文档里面没有，看源码
  --对于dkjson，需要设置meta信息。local a= {}；a.s = {};a.b='中文';setmetatable(a.s,  { __jsontype = 'object' });ngx.say(comm.json_encode(a))
    local json_value = nil
    if json.encode_empty_table_as_object then
        json.encode_empty_table_as_object(empty_table_as_object or false) -- 空的table默认为array
    end
    if require("ffi").os ~= "Windows" then
        json.encode_sparse_array(true)
    end
    --json_value = json.encode(data)
    pcall(function (data) json_value = json.encode(data) end, data)
    return json_value
end

function check_args(args, require_key)
    if not args or "table" ~= type(args) then
      return false
    end
    local key, value
    for k,_ in ipairs(require_key) do
        key = require_key[k]
        value = args[key]

        if nil == value then
            return false
        elseif "string" == type(value) and #value == 0 then
            return false
        end
    end

    return true
end


function split(str, pat)
   local t = {}
   if str == '' or str == nil then
       return t
   end

   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         --print(cap)
         table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

function trim(str)
  return str:match "^%s*(.-)%s*$"
end