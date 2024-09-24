-- 协程
-- Lua 支持协程，也叫 协同式多线程。 一个协程在 Lua 中代表了一段独立的执行线程。 然而，与多线程系统中的线程的区别在于， 协程仅在显式调用一个让出（yield）函数时才挂起当前的执行。

-- 调用函数 coroutine.create 可创建一个协程。 其唯一的参数是该协程的主函数。 create 函数只负责新建一个协程并返回其句柄 （一个 thread 类型的对象）； 而不会启动该协程。

-- 调用 coroutine.resume 函数执行一个协程。 第一次调用 coroutine.resume 时，第一个参数应传入 coroutine.create 返回的线程对象，然后协程从其主函数的第一行开始执行。 传递给 coroutine.resume 的其他参数将作为协程主函数的参数传入。 协程启动之后，将一直运行到它终止或 让出。

-- 协程的运行可能被两种方式终止： 正常途径是主函数返回 （显式返回或运行完最后一条指令）； 非正常途径是发生了一个未被捕获的错误。 对于正常结束， coroutine.resume 将返回 true， 并接上协程主函数的返回值。 当错误发生时， coroutine.resume 将返回 false 与错误消息。

-- 通过调用 coroutine.yield 使协程暂停执行，让出执行权。 协程让出时，对应的最近 coroutine.resume 函数会立刻返回，即使该让出操作发生在内嵌函数调用中 （即不在主函数，但在主函数直接或间接调用的函数内部）。 在协程让出的情况下， coroutine.resume 也会返回 true， 并加上传给 coroutine.yield 的参数。 当下次重启同一个协程时， 协程会接着从让出点继续执行。 此时，此前让出点处对 coroutine.yield 的调用 会返回，返回值为传给 coroutine.resume 的第一个参数之外的其他参数。

-- 与 coroutine.create 类似， coroutine.wrap 函数也会创建一个协程。 不同之处在于，它不返回协程本身，而是返回一个函数。 调用这个函数将启动该协程。 传递给该函数的任何参数均当作 coroutine.resume 的额外参数。 coroutine.wrap 返回 coroutine.resume 的所有返回值，除了第一个返回值（布尔型的错误码）。 和 coroutine.resume 不同， coroutine.wrap 不会捕获错误； 而是将任何错误都传播给调用者。


-- lua里的协程是单线程，也就是它每一个协程都是在一个线程里运行的，所以它的协程是不会并发的，只是在一个线程里的多个协程之间切换
-- 所以它不是真正意义上的多线程

-- coroutine.create(f): 创建一个新的协程，参数f是一个函数，当协程第一次启动时，会调用这个函数
-- coroutine.status(co): 返回一个字符串，表示协程的状态，有三种状态：running, suspended, dead
local co = coroutine.create(function ()
    print("hi")
end)

print(type(co)) -- thread   协程的类型是thread
print(co) -- thread: 0x7f8b3b502b20 直接打印协程的地址


-- coroutine.resume(co): 启动或再次启动一个协程，当第一次启动时，会从协程的主函数的第一行开始执行，当再次启动时，会从上次让出的地方继续执行
coroutine.resume(co) -- hi

-- coroutine.yield(...): 让出当前协程的执行权，传入的参数会作为coroutine.resume的返回值
local co1 = coroutine.create(function (a, b)
    print("co1 executed", a, b)
    coroutine.yield(a + b, a - b)   -- 让出执行权，传入的参数会作为coroutine.resume的返回值,直到下一次resume
    print("co1 executed again")

    local argc1, argc2 = coroutine.yield() -- 传入的参数会作为coroutine.resume的返回值
    print("co1 executed", argc1, argc2)
end)

print(coroutine.status(co1)) -- suspended   协程的状态是suspended未启动

local a, b, c = coroutine.resume(co1, 1, 2) -- co1 executed 1 2
print(a, b, c) -- true 3 -1
print(coroutine.status(co1)) -- suspended   协程的状态是suspended挂起


coroutine.resume(co1) -- co1 executed again
print(coroutine.status(co1)) -- suspended   协程的状态是suspended挂起

local rt, rt2, rt3 = coroutine.resume(co1, 4, 5) -- co1 executed 4 5
print(rt, rt2, rt3) -- true nil nil
print(coroutine.status(co1)) -- dead   协程的状态是dead，协程运行到end或者出错时，状态会变成dead


-- coroutine.wrap(f): 创建一个新的协程，参数f是一个函数，返回一个函数，调用这个函数会启动这个协程

local co2 = coroutine.wrap(function (a, b)
    print("co2 executed", a, b)
    coroutine.yield(a + b, a - b)   -- 让出执行权，传入的参数会作为coroutine.resume的返回值,直到下一次resume
    print("co2 executed again")

    local argc1, argc2 = coroutine.yield() -- 传入的参数会作为coroutine.resume的返回值
    print("co2 executed", argc1, argc2)
end)

local a1, b1, c1 = co2(1, 2) -- co2 executed 1 2        wrap返回的函数调用时，会启动协程(也就是调用resume)
print(a1, b1, c1) -- 3 -1 nil

co2() -- co2 executed again

co2(4, 5) -- co2 executed 4 5