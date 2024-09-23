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
