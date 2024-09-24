-- lua二进制数据打包与解析

-- c代码
-- unsigned char data[] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06};
-- printf("%d\n", data[3]);             // 4
-- printf("%d\n", sizeof(data));        // 6
-- typedef struct {
--     unsigned char c1;
--     unsigned char c2;
--     unsigned short s1;
--     unsigned char c3;
--     unsigned char c4;
--     unsigned short s2;
-- } TestDataType;      // 8字节

-- TestDataType test_data;
-- memcpy(&test_data, data, sizeof(data));

-- uint8_t *ptr = (uint8_t*)(&test_data);
    
-- printf("0x%x\n", ptr[0]);       // 0x01
-- printf("0x%x\n", ptr[1]);       // 0x02
-- printf("0x%x\n", ptr[2]);       // 0x03
-- printf("0x%x\n", ptr[3]);       // 0x04
-- printf("0x%x\n", ptr[4]);       // 0x05
-- printf("0x%x\n", ptr[5]);       // 0x06
-- printf("0x%x\n", ptr[6]);       // 0x0



-- lua代码
local data = string.char(0x01, 0x02, 0x03, 0x04, 0x05, 0x06)        -- 6个无符号4字节整数
print(data:byte(4))                     -- 4
print(#data)                            -- 6

-- 小端序
local packDataL = string.pack("<L", 1)  -- 4字节无符号整数
print("len", #packDataL)                -- 4
print("0x" .. string.format("%x", packDataL:byte(1))) -- 0x1
print("0x" .. string.format("%x", packDataL:byte(2))) -- 0x0
print("0x" .. string.format("%x", packDataL:byte(3))) -- 0x0
print("0x" .. string.format("%x", packDataL:byte(4))) -- 0x0


-- 大端序 (网络序)
local packDataB = string.pack(">L", 1)  -- 4字节无符号整数
print("len", #packDataB)                -- 4
print("0x" .. string.format("%x", packDataB:byte(1))) -- 0x0
print("0x" .. string.format("%x", packDataB:byte(2))) -- 0x0
print("0x" .. string.format("%x", packDataB:byte(3))) -- 0x0
print("0x" .. string.format("%x", packDataB:byte(4))) -- 0x1


-- 解析 4字节无符号整数
local unpackDataL = string.unpack("<L", packDataL)
print(unpackDataL)                      -- 1





