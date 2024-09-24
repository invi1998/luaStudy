-- 元表以及元方法 (Metatables and Metamethods) 类似C++里的操作符重载

-- 元表用于定义原始值的操作行为

-- 接下来是元表可以控制的事件的详细列表。 每个操作都用对应的事件名来区分。 每个事件的键名用加有 ‘__’ 前缀的字符串来表示； 例如 “add” 操作的键名为字符串 “__add”。

-- __add: + 操作。 如果任何不是数字的值（包括不能转换为数字的字符串）做加法， Lua 就会尝试调用元方法。 首先、Lua 检查第一个操作数（即使它是合法的）， 如果这个操作数没有为 “__add” 事件定义元方法， Lua 就会接着检查第二个操作数。 一旦 Lua 找到了元方法， 它将把两个操作数作为参数传入元方法， 元方法的结果（调整为单个值）作为这个操作的结果。 如果找不到元方法，将抛出一个错误。

-- __sub: - 操作。 行为和 “add” 操作类似。

-- __mul: * 操作。 行为和 “add” 操作类似。

-- __div: / 操作。 行为和 “add” 操作类似。

-- __mod: % 操作。 行为和 “add” 操作类似。

-- __pow: ^ （次方）操作。 行为和 “add” 操作类似。

-- __unm: - （取负）操作。 行为和 “add” 操作类似。

-- __idiv: // （向下取整除法）操作。 行为和 “add” 操作类似。

-- __band: & （按位与）操作。 行为和 “add” 操作类似， 不同的是 Lua 会在任何一个操作数无法转换为整数时 （参见 §3.4.3）尝试取元方法。

-- __bor: | （按位或）操作。 行为和 “band” 操作类似。

-- __bxor: ~ （按位异或）操作。 行为和 “band” 操作类似。

-- __bnot: ~ （按位非）操作。 行为和 “band” 操作类似。

-- __shl: << （左移）操作。 行为和 “band” 操作类似。

-- __shr: >> （右移）操作。 行为和 “band” 操作类似。

-- __concat: .. （连接）操作。 行为和 “add” 操作类似， 不同的是 Lua 在任何操作数即不是一个字符串 也不是数字（数字总能转换为对应的字符串）的情况下尝试元方法。

-- __len: # （取长度）操作。 如果对象不是字符串，Lua 会尝试它的元方法。 如果有元方法，则调用它并将对象以参数形式传入， 而返回值（被调整为单个）则作为结果。 如果对象是一张表且没有元方法， Lua 使用表的取长度操作（参见 §3.4.7）。 其它情况，均抛出错误。

-- __eq: == （等于）操作。 和 “add” 操作行为类似， 不同的是 Lua 仅在两个值都是表或都是完全用户数据 且它们不是同一个对象时才尝试元方法。 调用的结果总会被转换为布尔量。

-- __lt: < （小于）操作。 和 “add” 操作行为类似， 不同的是 Lua 仅在两个值不全为整数也不全为字符串时才尝试元方法。 调用的结果总会被转换为布尔量。

-- __le: <= （小于等于）操作。 和其它操作不同， 小于等于操作可能用到两个不同的事件。 首先，像 “lt” 操作的行为那样，Lua 在两个操作数中查找 “__le” 元方法。 如果一个元方法都找不到，就会再次查找 “__lt” 事件， 它会假设 a <= b 等价于 not (b < a)。 而其它比较操作符类似，其结果会被转换为布尔量。

-- __index: 索引 table[key]。 当 table 不是表或是表 table 中不存在 key 这个键时，这个事件被触发。 此时，会读出 table 相应的元方法。

-- 尽管名字取成这样， 这个事件的元方法其实可以是一个函数也可以是一张表。 如果它是一个函数，则以 table 和 key 作为参数调用它。 如果它是一张表，最终的结果就是以 key 取索引这张表的结果。 （这个索引过程是走常规的流程，而不是直接索引， 所以这次索引有可能引发另一次元方法。）

-- __newindex: 索引赋值 table[key] = value 。 和索引事件类似，它发生在 table 不是表或是表 table 中不存在 key 这个键的时候。 此时，会读出 table 相应的元方法。

-- 同索引过程那样， 这个事件的元方法即可以是函数，也可以是一张表。 如果是一个函数， 则以 table、 key、以及 value 为参数传入。 如果是一张表， Lua 对这张表做索引赋值操作。 （这个索引过程是走常规的流程，而不是直接索引赋值， 所以这次索引赋值有可能引发另一次元方法。）

-- 一旦有了 “newindex” 元方法， Lua 就不再做最初的赋值操作。 （如果有必要，在元方法内部可以调用 rawset 来做赋值。）

-- __call: 函数调用操作 func(args)。 当 Lua 尝试调用一个非函数的值的时候会触发这个事件 （即 func 不是一个函数）。 查找 func 的元方法， 如果找得到，就调用这个元方法， func 作为第一个参数传入，原来调用的参数（args）后依次排在后面。


local t = {a = 1, b = 2}

-- 定义__add元方法
local mt = {
    __add = function (table1, table2)
        return table1.a + table2.a, table1.b + table2.b
    end


}

setmetatable(t, mt)

print(t + t) -- 2 4       只有设置了元表才能使用元方法

-- __index元方法
local t1 = {a = 1, b = 2}
local mt1 = {
    __index = function (table, key)
        -- return table[key]
        return "no such key"
    end
}

setmetatable(t1, mt1)

print(t1["bbc"]) -- no such key，正常来说，t1["bbc"]应该返回nil，但是设置了元表后，返回了no such key

-- index不一定是函数，也可以是一个表
local t2 = {a = 1, b = 2}
local mt2 = {
    __index = {c = 3, d = 4}
}

setmetatable(t2, mt2)
print(t2["c"]) -- 3     当lua发现没有c这个key时，会去找有没有__index元方法，如果有元方法，就会返回元方法的值，如果没有元方法，就会返回nil


-- __newindex元方法
-- __newindex元方法用于更新表中的值，如果表中没有这个key，就会调用__newindex元方法，赋值时触发
local t3 = {a = 1, b = 2}
local mt3 = {
    __newindex = function (table, key, value)
        print("newindex", key, value)
        rawset(table, key, value)

        -- table[key] = value  -- 这样会陷入死循环，因为table[key]会再次触发__newindex元方法，导致死循环，堆栈溢出
    end
}

setmetatable(t3, mt3)
t3["c"] = 3

-- rawset(table, key, value) 用于更新表中的值，不会触发__newindex元方法
rawset(t3, "d", 4)      -- 这样不会触发__newindex元方法
print(t3["d"]) -- 4

print("--------------------class----------------------")
-- 面向对象

local bag = {}
local bagmt = {
    put = function (t, item)
        table.insert(t.items, item)
    end,

    take = function (t)
        return table.remove(t.items)
    end,

    list = function (t)
        return table.concat(t.items, ", ")
    end,

    clear = function (t)
        t.items = {}
    end,
}

bagmt["__index"] = bagmt        -- bagmt是bag的元表，bagmt的__index元方法是bagmt，这样当bag中没有key时，会去bagmt中查找

function bag.new()
    local t = {
        items = {},
    }
    setmetatable(t, bagmt)
    return t
end

local mybag = bag.new()
mybag:put("apple")
print(mybag:take()) -- apple

mybag:put("banana")
mybag:put("orange")
mybag:put("grape")

mybag:list()

mybag:clear()
mybag:list()

local mybag1 = bag.new()
local mybag2 = bag.new()
local mybag3 = bag.new()

mybag:put("apple")
mybag:put("banana")
mybag:put("orange")

mybag1:put("grape")
mybag1:put("watermelon")

mybag2:put("pear")
mybag2:put("peach")

print(mybag:list())     -- apple, banana, orange
print(mybag1:list())    -- grape, watermelon
print(mybag2:list())    -- pear, peach
print(mybag3:list())    -- 什么都没有









