-- CoronaSDK 2017.3184
--[[ 
 目前存在的问题：
 如果使用 Lua{}表 作为对象池,使用函数setmetatable()设置元表 __index 会出现问题。
 猜测原因:可能是由于 DisplayObject 基于 CoronaPrototype 的对象，因此不能直接通过 __index 覆盖元方法。
 由于这里只需要存放 DisplayObject 对象，所以直接使用 GroupObject 来充当容器代替 Lua{}表 。
 如果需要存放多种类型的对象可以参考CoronaSDK手册:Documentation▸API Reference▸type▸CoronaPrototype▸setExtension说明。有兴趣的可以自己去尝试修改
--]]

-- 对象池函数
local M = {};

-- 初始化对象池
-- 此对象池包含两个子池：objectPool-存放对象的对象池   method-存放实例化单个新对象的方法池
---@return table 返回对象池函数
function M.initPool()
    local objectPool = {};    -- 该池为对象池  负责存储/回收对象
    local method = {};        -- 该池为方法池  负责存储新建对象的方法
    return setmetatable( { objectPool = objectPool, method = method },  { __index = M } );    -- 返回一个对象池对象[]
end

-- 在对象池中创建对象
---@param newObject function 创建单个实例对象的函数名[该函数必须返回一个对象,同时该对象必须包含 name 属性作为标识符]
---@param poolSize number 需要在池中创建的对象数。[未设置默认值为 4]
---@param name string 子对象池的标识符[如果未设置会默认使用对象的name属性]
---@return GroupObject 对象池对象
function M:addSonPool( newObject, poolSize, name )
    name = name or newObject().name;                            -- 按：参数，name属性的顺序进行取值
    self.objectPool[ name ] = display.newGroup();               -- 根据对象的不同name属性在对象池中归类为不同的子池
    self.method[ name ] = newObject;                            -- 在方法池中存入对应的新建对象的方法
    poolSize = poolSize or 4;
    for _ = 1, poolSize do
        self.objectPool[ name ]:insert( newObject() );
    end
end

-- 从对象池中获取指定对象
---@param objectName string 需要获得的对象的name
---@return DisplayObject  从池中返回未使用对象的单个实例，如果不存在未使用对象，则新建对象并且返回该对象。
function M:getObject( objectName )
    local object;
    local number = self.objectPool[ objectName ].numChildren;      -- 取得池中的个数，同时也是该池的最后一个对象的索引
    if number == 0 then
        object = self.method[ objectName ]();                      -- 池中无对象则新建对象
    else
        object = self.objectPool[ objectName ]:remove( number );   -- 有对象则从池中取出该对象
    end
    object.alpha = 1;                    --- 显示图像
    return  object;
end

-- 把对象放回对象池中
---@param object DisplayObject 需要存入对象池的对象
---@param name string 需要存放到对象池中对应分类的标识，如果没有 object 没有包含name属性，则需要传入参数，否则会报错。
function M:putObject( object, name )
    local name = name or object.name;
    object.alpha = 0;                         --- 消除图像
    timer.performWithDelay(1 ,function ()     --- 延迟回收图像[在Corona中，发生碰撞事件时无法对对象进行操作]
        self.objectPool[ name ]:insert( object:removeSelf() );
    end );
end

-- 清空对象池
function M:clearPool()
    -- 清空对象池
    for k in pairs( self.objectPool ) do
        for i = #self.objectPool[ k ], 1, -1 do
            local temp =  self.objectPool[ k ]:remove( i );
            display.remove( temp );
            temp = nil;
        end
    end
    -- 清空方法池
    for k in pairs( self.method )  do
        self.freeObjects[ k ] = nil
    end
end

return M;
