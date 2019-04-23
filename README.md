# pool.lua
CoronaSDK的对象池函数
========
基于@treamology/pool.lua修改的CoronaSDK(version 2017.3184)对象池函数。<br/>
通过该模块可以管理所有的显示对象的创建/使用/回收/销毁。

例子
=======
```
local pool = require( "pool" );  -- 获取pool.lua模块

-- 取出对象前执行的函数
local function getObjectMethod()
     print( "这是取出对象时执行的函数" );
end

-- 回收对象后执行的函数
local function getObjectMethod()
     print( "这是回收对象时执行的函数" );
end

   -- 新建对象的方法
local function new()
        local Gold = display.newImageRect( "image/prop/gold.png", 20, 20 );
        Gold.name = "Gold";
        Gold.getObjectMethod = getObjectMethod;
        Gold.putObjectMethod = putObjectMethod;
        return Gold;
    end

-- 初始化总对象池
local objectPool =  pool.initPool();

-- 添加子对象池
objectPool:addSonPool( new, 8, "Gold" );
-- 取得对象
local gold = objectPool:getObject( "Gold" );   -- 控制台信息：这是取出对象时执行的函数
-- 回收对象
objectPool:putObject( gold );                  -- 控制台信息：这是回收对象时执行的函数
-- 清空池
objectPool:clearPool();
```
说明
===========
 用于创建回收游戏中重复出现的显示对象进行循环使用，减少反复创建->销毁->再次创建显示文件的性能损耗。<br/>例如：你设计一个跑酷游戏，需要跟随场景的推进反复的出现一些道具（如金币，平台等），这时候就可以使用池。<br/>其他关于池模式的介绍[here](https://baike.baidu.com/item/%E5%AF%B9%E8%B1%A1%E6%B1%A0%E6%A8%A1%E5%BC%8F).


创建总池
---------------
`pool.initPool()`:创建总池的函数，此池包含两个子池：
* `objectPool`  存放对象的对象池   
* ` method`  存放实例化单个新对象的方法池

创建子池
---------------
`pool.addSonPool( newObject, poolSize, name )`:创建池函数
* `newObject` function 创建单个实例对象的函数名[该函数必须返回一个DisplayObject对象,同时该对象必须包含 name 属性作为标识符]
* `poolSize` number 需要在池中创建的对象数。[未设置默认值为 4]
* `name` string 子对象池的标识符[如果未设置会默认使用对象的name属性]

从池中存取对象
-----------------------------
现在已经创建了一个池，我们可以从池中取出对象并将其放回池中。

`pool:getObject( objectName )`: 从池中取得显示对象。

`pool:putObject( object, name )`: 将对象放回池中供以后使用。
* `object` DisplayObject 需要存入对象池的对象
* `object` string 需要存放到对象池中对应分类的标识，如果没有 object 没有包含name属性，则需要传入参数，否则会报错。
* 如果被取出/被释放的对象包含一个名为getObjectMethod/putObjectMethod的函数，则在将其取出/回收池中时将调用它。可通过这两个属性让代码具有更多的扩展性。


清空池
---------------------------
`pool:clearPool()`: 清空池对象,并释放所有的显示对象以及方法。

用法
=====
将pool.lua复制/粘贴到源文件夹中。

    local pool = require ( "pool" );  -- 获取池函数
    local objectPool = pool.initPool(); --创建池对象
    

