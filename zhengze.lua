-- lua正则

-- 1. string.find(str, pattern, init, plain)    在一个字符串中查找一个模式，返回其起始和结束索引,如果没有找到返回nil
-- str: 要查找的字符串
-- pattern: 要查找的模式
-- init: 可选参数，起始索引,默认为1
-- plain: 可选参数，是否关闭模式匹配，默认为false(模式匹配,即正则表达式)，true表示关闭模式匹配，不启用正则表达式

local s = "hello world from Lua"

print(string.find(s, "world"))  -- 7 11

-- 2. string.match(str, pattern, init, plain)    在一个字符串中查找一个模式，返回匹配到的字符串，如果没有找到返回nil
-- str: 要查找的字符串
-- pattern: 要查找的模式
-- init: 可选参数，起始索引,默认为1
-- plain: 可选参数，是否关闭模式匹配，默认为false(模式匹配,即正则表达式)，true表示关闭模式匹配，不启用正则表达式

print(string.match(s, "world"))  -- world

-- 3. 匹配模式
-- 字符类 用于表示一个字符集合。 下列组合可用于字符类：

-- x: （这里 x 不能是 魔法字符 ^$()%.[]*+-? 中的一员） 表示字符 x 自身。

-- .: （一个点）可表示任何字符。

-- %a: 表示任何字母。

-- %c: 表示任何控制字符。

-- %d: 表示任何数字。

-- %g: 表示任何除空白符外的可打印字符。

-- %l: 表示所有小写字母。

-- %p: 表示所有标点符号。

-- %s: 表示所有空白字符。

-- %u: 表示所有大写字母。

-- %w: 表示所有字母及数字。

-- %x: 表示所有 16 进制数字符号。

-- %_x_: （这里的 x 是任意非字母或数字的字符） 表示字符 x。 这是对魔法字符转义的标准方法。 所有非字母或数字的字符 （包括所有标点，也包括非魔法字符） 都可以用前置一个 ‘%’ 放在模式串中表示自身。

-- [_set_]: 表示 set　中所有字符的联合。 可以以 ‘-’ 连接，升序书写范围两端的字符来表示一个范围的字符集。 上面提到的 %x 形式也可以在 set 中使用 表示其中的一个元素。 其它出现在 set 中的字符则代表它们自己。 例如，[%w_] （或 [_%w]） 表示所有的字母数字加下划线）， [0-7] 表示 8 进制数字， [0-7%l%-]　表示 8 进制数字加小写字母与 ‘-’ 字符。

-- 交叉使用类和范围的行为未定义。 因此，像 [%a-z] 或 [a-%%] 这样的模式串没有意义。

-- [^_set_]: 表示 set 的补集， 其中 set 如上面的解释。

-- 所有单个字母表示的类别（%a，%c，等）， 若将其字母改为大写，均表示对应的补集。 例如，%S 表示所有非空格的字符。

-- 如何定义字母、空格、或是其他字符组取决于当前的区域设置。 特别注意：[a-z]　未必等价于 %l 。

-- 模式条目：
-- 模式条目 可以是

-- 单个字符类匹配该类别中任意单个字符；

-- 单个字符类跟一个 ‘*’， 将匹配零或多个该类的字符。 这个条目总是匹配尽可能长的串；

-- 单个字符类跟一个 ‘+’， 将匹配一或更多个该类的字符。 这个条目总是匹配尽可能长的串；

-- 单个字符类跟一个 ‘-’， 将匹配零或更多个该类的字符。 和 ‘*’ 不同， 这个条目总是匹配尽可能短的串；

-- 单个字符类跟一个 ‘?’， 将匹配零或一个该类的字符。 只要有可能，它会匹配一个；

-- %_n_， 这里的 n 可以从 1 到 9； 这个条目匹配一个等于 n 号捕获物（后面有描述）的子串。

-- %b_xy_， 这里的 x 和 y 是两个明确的字符； 这个条目匹配以 x 开始 y 结束， 且其中 x 和 y 保持 平衡 的字符串。 意思是，如果从左到右读这个字符串，对每次读到一个 x 就 +1 ，读到一个 y 就 -1， 最终结束处的那个 y 是第一个记数到 0 的 y。 举个例子，条目 %b() 可以匹配到括号平衡的表达式。

-- %f[_set_]， 指 边境模式； 这个条目会匹配到一个位于 set 内某个字符之前的一个空串， 且这个位置的前一个字符不属于 set 。 集合 set 的含义如前面所述。 匹配出的那个空串之开始和结束点的计算就看成该处有个字符 ‘\0’ 一样。

-- 模式：
-- 模式 指一个模式条目的序列。 在模式最前面加上符号 ‘^’ 将锚定从字符串的开始处做匹配。 在模式最后面加上符号 ‘$’ 将使匹配过程锚定到字符串的结尾。 如果 ‘^’ 和 ‘$’ 出现在其它位置，它们均没有特殊含义，只表示自身。

-- 捕获：
-- 模式可以在内部用小括号括起一个子模式； 这些子模式被称为 捕获物。 当匹配成功时，由 捕获物 匹配到的字符串中的子串被保存起来用于未来的用途。 捕获物以它们左括号的次序来编号。 例如，对于模式 "(a*(.)%w(%s*))" ， 字符串中匹配到 "a*(.)%w(%s*)" 的部分保存在第一个捕获物中 （因此是编号 1 ）； 由 “.” 匹配到的字符是 2 号捕获物， 匹配到 “%s*” 的那部分是 3 号。

-- 作为一个特例，空的捕获 () 将捕获到当前字符串的位置（它是一个数字）。 例如，如果将模式 "()aa()" 作用到字符串 "flaaap" 上，将产生两个捕获物： 3 和 5 。

local ss = "hello world from Lua 1245asdDFSGsdf"
local s1, e1 = string.find(ss, "%d+")   -- 匹配数字
print(s1, e1)  -- 22 25

local s2, e2 = string.find(ss, "%a+")   -- 匹配字母
print(s2, e2)  -- 1 5

local s3, e3 = string.find(ss, "lua.%a+")   -- 匹配lua后面的字母
print(s3, e3)  -- nil nil

-- 4. string.gmatch(str, pattern)    返回一个迭代器函数，每次调用返回下一个匹配的字符串，如果没有匹配返回nil
local iter = string.gmatch(ss, "%a+")  -- 匹配字母
for word in iter do
    print(word)
end

local st = "a1b2c3d4e5"
local iter = string.gmatch(st, "%d%a")  -- 匹配数字字母
for word in iter do
    print(word) -- 1b 2c 3d 4e
end

-- 5. string.gsub(str, pattern, repl, n)    在一个字符串中查找一个模式，返回替换后的字符串，如果没有找到返回原字符串
print(string.gsub(ss, "%d", "x"))  -- hello world from Lua xxxxxasdDFSGsdf 4  4代表替换了4次
