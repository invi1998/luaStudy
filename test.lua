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
