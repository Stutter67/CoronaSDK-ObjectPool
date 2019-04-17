# pool.lua
CoronaSDK的显示对象池
========
基于@treamology/pool.lua修改的CoronaSDK(version 2017.3184)显示对象池。<br/>


例子
=======
```
local pool = require "pool"  -- 获取pool.lua模块
   -- 新建对象的方法
local function new()
        local Gold = display.newImageRect( "image/prop/gold.png", 20, 20 );
        Gold.reset = function()
            print("回收执行的函数");
        end
        return Gold;
    end

-- 创建池
local objectPool = pool.createPool(new, 32);
-- 取得对象
local object = objectPool:getObject()
-- 回收对象
objectPool:putObject(object);
-- 清空池
objectPool:clearObjectPool();
```
说明
===========
 用于创建回收游戏中重复出现的显示对象进行循环使用，减少反复创建->销毁->再次创建显示文件的性能损耗。<br/>例如：你设计一个跑酷游戏，需要跟随场景的推进反复的出现一些道具（如金币，平台等），这时候就可以使用池。<br/>其他关于池模式的介绍[here](https://baike.baidu.com/item/%E5%AF%B9%E8%B1%A1%E6%B1%A0%E6%A8%A1%E5%BC%8F).

创建池
---------------

`pool.createPool(newObjectFunc, numObjects)`:创建池函数
* `newObjectFunc` 返回值为显示对象（DisplayObject，如果不是此对象类型，需要修改文件中的回收函数）的函数
* `numObjects` 池中预存的对象。（未设置默认为4）

从池中存取对象
-----------------------------
现在已经创建了一个池，我们可以从池中取出对象并将其放回池中。

`pool:getObject()`: 从池中取得显示对象。

`pool:putObject(object)`: 将对象放回池中供以后使用。
* `object` 需要被释放的对象
* 如果被释放的对象包含一个名为的函数reset，则在将其添加回池中时将调用它。使用此选项可重置对象之间不希望在使用之间粘贴的任何值。

清空池
---------------------------
`pool:clearObjectPool()`: 清空池对象,并释放所有的显示对象。

用法
=====
将pool.lua复制/粘贴到源文件夹中。

    local pool = require "pool"  -- 获取池函数
    local objectPool = pool.createPool( function , number ); --创建池对象
    

