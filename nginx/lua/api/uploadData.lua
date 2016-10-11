
local comm  = require("lua.comm.common") 
local redis = require("lua.db_redis.db_base")
local red   = redis:new()
--�ϴ�����
-- ����POST���󣬸����������ݶ�redis���в���
--����������curl -i '127.0.0.1/api/uploadData.json?uid=1&did=3'

-- �û��ϴ����ݸ�ʽ��
-- URL��  127.0.0.1/api/uploadData.json?uid=""&&did=
-- ���ݣ�
--   [
--         {
--             "sensor": "weight",
--             "value": 78    
--         },
--         {
--             "sensor": "heart",
--             "value": 78
--         }
--     ]
-- }

-- ������Ϣ��
-- {
--    "Successful": false,
--    "Message": "Invalid device ID"
-- }


-- curl -i '127.0.0.1/api/uploadData.json?uid=001&did=001' -d '[{"sensor": "weight","value": 78},{"sensor": "heart","value": 78}]'

local args = ngx.req.get_uri_args()

local uid = args.uid 
local did = args.did

--uid �����ĺϷ���У����access�׶δ����ӿڲ�������
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

local response = {}

local res,err = red:hget("uid:"..uid,"did:"..did)
if err then
	ngx.log(ngx.WARN,"redis hget uid:"..uid.."error")
	ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE)
end

if res == nil then
   response.Successful = false
   response.Message = "device id not exist or user not exist"
   ngx.say(comm.json_encode(response))
end

--��������
for k, _ in pairs(post_args) do
    post_args[k]["timestamp"] = ngx.localtime()
end

ngx.say(comm.json_encode(post_args))

ngx.log(ngx.WARN,"right request args uid :",uid)
--ngx.say(body)

-- for k, v in pairs(post_args) do
-- 	ngx.say(comm.json_encode(post_args[k]))
-- end