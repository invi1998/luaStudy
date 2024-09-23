_G.Count = 1

local r = require("Hello")        -- 使用require函数加载Hello.lua文件，多文件调用，不需要后缀

print(r)  -- 输出100

print(_G.Count)  -- 输出2，因为Hello.lua文件中对_G.Count进行了+1操作

-- require只会加载一次，如果多次调用同一个文件，只会加载一次，
-- 后续每次调用都会返回第一次加载的结果，所以下面的Count还是2，而且Hello.lua文件中的print("Hello World!")也不会再次执行
-- 而是直接拿第一次加载的结果直接输出
require("Hello")

print(_G.Count)  -- 输出2，因为require只会加载一次

require("path.hello2")  -- 使用require函数加载hello2.lua文件，多文件调用，文件层级用.分割

-- require会从package.path中查找文件，如果找不到，会报错
print(package.path)  -- 输出当前package.path的值

-- 从package.path中我们可以看到，为什么require文件的时候，不需要在文件后面加上.lua后缀
-- 因为package.path中已经包含了.lua后缀的文件路径 （.\?.lua，其中?表示文件名）

-- 同样，如果我们把文件层级加入到package.path中，就可以直接使用require函数加载文件，而不需要用.分割
package.path = package.path .. ";./path/?.lua"

require("hello2")  -- 使用require函数加载hello2.lua文件，多文件调用，文件层级用.分割

-- 一般来说，require这个函数是用来引用外部库的，不需要多次调用，只需要调用一次，然后就可以在全局使用这个库的函数了
-- 但是如果你需要多次调用，也是可以的，需要使用功能loadfile，这个函数会重新加载文件，然后返回一个函数，你可以调用这个函数来执行文件中的代码
-- 也可以使用loadstring函数，这个函数会返回一个函数，你可以调用这个函数来执行字符串中的代码

local mylib = require("mylib")  -- 使用require函数加载mylib.lua文件，多文件调用，文件层级用.分割

print(mylib.add(1, 2))  -- 输出3，调用mylib.lua文件中的add函数

mylib.say()  -- 输出Hello World!，调用mylib.lua文件中的say函数


-- 迭代器
local t = {"a", "b", "c", "d", "e"}

-- 普通方式遍历，从下标1开始，直到下标大小遍历到数组的大小，每次+1 （#t表示数组的大小）
for i = 1, #t do
    print(t[i])
end

-- 迭代器方式遍历，pairs函数返回一个迭代器，这个迭代器会返回数组的下标和值
for k, v in pairs(t) do
    print(k, v)
end

-- ipairs函数返回一个迭代器，这个迭代器会返回数组的下标和值
for index, value in ipairs(t) do
    print(index, value)
end

-- pairs和ipairs的区别
-- pairs是遍历所有的key，包括数字和字符串
-- ipairs是遍历所有的数字key，从1开始，直到数组的大小，每次+1

print("-----------------")
local tt = {a = 1, b = 2, c = 3}

-- 这个迭代并不会执行，因为ipairs只会迭代数值key
for key, value in ipairs(tt) do
    print(key, value)
end

print("-----------------")
-- 使用pairs迭代table是无序的，因为table是无序的
for key, value in pairs(tt) do
    print(key, value)
end

local ttt = {
    [1] = "a",
    [2] = "b",
    [3] = "c",
    -- [4] = "d",  -- 这里把4注释掉，那么如果使用ipairs迭代，只会迭代到3，因为ipairs迭代步长是+1，如果中间有断层，那么后面的就不会迭代了
    [5] = "e"
}

print("-----------------")
for key, value in ipairs(ttt) do
    print(key, value)
end

-- 如果是pairs迭代，那么就会把所有的key都迭代出来
print("-----------------")
for key, value in pairs(ttt) do
    print(key, value)
end

-- 迭代器的实现
-- pairs它内部实现是调用next函数，next函数返回一个key和value，然后pairs函数返回这个key和value
print("-----------------")
print(next(ttt))  -- 输出5	e
print(next(ttt, 1))  -- 输出 2 b, next函数第二个参数表示从哪个key开始迭代，如果不传，那么就从第一个key开始迭代
print(next(ttt, 2))  -- 输出 3 c
print(next(ttt, 3))  -- 输出 nil，表示迭代结束
print(next(ttt, 5))  -- 输出 1 a 表明在lua这里，它认为5才是第一个key

print("-----------------string-----------------")

-- 在lua中，字符串的存储是以字节数组的形式存储的，所以字符串的长度是字节数组的长度
-- 它与c语言不同，c语言中字符串的长度是以'\0'结尾的字符数组的长度，所以c语言中字符串的长度是字符数组的长度-1
-- 在lua中，字符串的长度是字节数组的长度，所以字符串的长度是字符数组的长度，它可以存储任何Byte的数据，包括'\0'，0x00到0xff的任何数据

-- lua里字符串的序号是从1开始的，它有正序和倒序两种方式，正序是从1开始，倒序是从-1开始
-- A B C D E F G H I
-- 1 2 3 4 5 6 7 8 9
-- -9 -8 -7 -6 -5 -4 -3 -2 -1

local s = "ABCDEFGHI"
-- string.byte(s [, i [, j]]) 返回字符串s中从i到j的字节的ASCII码值
print(string.byte(s, 1, 1))  -- 输出65，A的ASCII码值
print(string.byte(s, 1, 2))  -- 输出65 66，A B的ASCII码值

-- 字符串有个语法糖，如果我们字符串调用的函数他的第一个参数是字符串，那么我们可以省略掉string.，把调用的字符串变量放在前面直接调用函数
print(s.byte(s, 1, 1))  -- 输出65，A的ASCII码值
-- 当然，也可以使用:byte()这种方式调用，这种方式调用，会把调用的字符串变量放在前面，然后把调用的函数放在后面
print(s:byte(1, 1))  -- 输出65，A的ASCII码值
print(s:byte(1, -1))  -- 输出65 66 67 68 69 70 71 72 73，A B C D E F G H I的ASCII码值

-- string.char(...) 返回ASCII码值对应的字符
print(string.char(65))  -- 输出A
print(string.char(65, 66))  -- 输出AB
print(string.char(0x41, 0x42))  -- 输出AB

-- string.format(formatstring, ...) 返回一个格式化的字符串，很像c语言的printf函数
print(string.format("Hello %s", "World"))  -- 输出Hello World

-- string.len(s) 返回字符串s的长度
print(string.len(s))  -- 输出9
print(#s)  -- 输出9
print(s.len(s))  -- 输出9
print(s:len())  -- 输出9

-- string.lower(s) 返回字符串s的小写形式，原字符串不会改变
print(string.lower(s))  -- 输出abcdefghi
print(s) -- 输出ABCDEFGHI，原字符串不会改变

-- string.upper(s) 返回字符串s的大写形式，原字符串不会改变

-- string.pack(fmt, v1, v2, ...) 返回一个二进制字符串，fmt表示格式，v1, v2, ...表示要打包的数据
-- fmt的格式有：
-- c 一个字节的字符
-- h 一个短整数
-- i 一个整数
-- l 一个长整数
-- s 一个字符串
-- f 一个浮点数
-- d 一个双精度浮点数
-- > 大端序
-- < 小端序
-- = 本地序
-- ! 大端序
-- | 小端序
-- 例如：


print(string.pack("c4", "abcd"))  -- 输出abcde，因为c4表示一个字节的字符，4表示4个字节，所以abcd就是一个字节的字符，e是多余的

local pa1 = string.pack("<i", 10)  -- 打包一个小端序的整数10
print(pa1:byte(1, -1))  -- 输出10 0 0 0，因为10的二进制是00001010，小端序是倒序的，所以就是00000010 00000000 00000000 00000000 (10 0 0 0)

local pa2 = string.pack(">i", 10)
print(pa2:byte(1, -1))  -- 输出0 0 0 10，因为10的二进制是00001010，大端序是正序的，所以就是00000000 00000000 00000000 00001010 (0 0 0 10)

local pa3 = string.pack("<ii", 10, 20)  -- 打包两个小端序的整数10和20
print(pa3:byte(1, -1))  -- 输出10 0 0 0 20 0 0 0，因为10的二进制是00001010，20的二进制是00010100，小端序是倒序的，所以就是00000010 00000000 00000000 00000000 00010100 00000000 00000000 00000000 (10 0 0 0 20 0 0 0)

-- string.unpack(fmt, s [, pos]) 返回一个解包的数据，fmt表示格式，s表示要解包的字符串，pos表示从哪个位置开始解包
-- fmt的格式有：
-- c 一个字节的字符
-- h 一个短整数
-- i 一个整数
-- l 一个长整数
-- s 一个字符串
-- f 一个浮点数
-- d 一个双精度浮点数
-- > 大端序
-- < 小端序
-- = 本地序
-- ! 大端序
-- | 小端序
-- 例如：
local unpa1 = string.unpack("<i", pa1)  -- 解包一个小端序的整数
print(unpa1)  -- 输出10 

local unpa2 = string.unpack(">i", pa2)  -- 解包一个大端序的整数
print(unpa2)  -- 输出10

local unpa3, unpa4 = string.unpack("<ii", pa3)  -- 解包两个小端序的整数
print(unpa3, unpa4)  -- 输出10 20

-- string.rep(s, n) 返回字符串s重复n次的字符串，它还有一个参数，可以指定两个字符串之间的分隔符，默认是空字符串
print(string.rep("abc", 3))  -- 输出abcabcabc
print(string.rep("abc", 3, "-"))  -- 输出abc-abc-abc

-- string.reverse(s) 返回字符串s的倒序字符串，原字符串不会改变
print(string.reverse(s))  -- 输出IHGFEDCBA

-- string.sub(s, i [, j]) 返回字符串s从i到j的子串，如果j不传，那么就是从i到字符串的末尾
-- lua的字符串切割是左闭右闭的，也就是包含i和j，而C语言是左闭右开的，包含i不包含j
print(string.sub(s, 1, 3))  -- 输出ABC
