-- 对象池工具函数
local M = {};
local index = { __index = M };

-- 创建一个对象池
---@param newObject function 一个返回需要插入的的对象的函数
---@param poolSize number 需要添加到对象池中的对象数目,未指定大小则默认初始16
---@return GroupObject 对象池对象
function M.createPool( newObject, poolSize )
    poolSize = poolSize or 4;
    local objectPool = display.newGroup();
    for _ = 1, poolSize do
        objectPool:insert( newObject() );
    end
    return setmetatable( {
        objectPool = objectPool,
        newObject = newObject
                         },
    index
    )
end

-- 从对象池中获取对象(这里的对象已经是创建好存放在内存区域中了)
---@return DisplayObject
function M:getObject()
    return self.objectPool.numChildren == 0 and self.newObject() or self.objectPool:remove( self.objectPool.numChildren );
end

-- 将使用完对象放回池中并从显示画面中移除,以供后使用。而不是删除它
---@param object DisplayObject 需要存入容器的而对象
---@return nil
function M:putObject( object )
    print(object.name)
    transition.fadeOut( object, { time = 0 , onComplete = function()
        self.objectPool:insert( object:removeSelf() );
        object = nil;
        --if object.reset then object.reset() end
    end
    } );
end

-- 清空池
function M:clearObjectPool()
    for i = self.objectPool.numChildren, 1,  -1 do
        local temp = self.objectPool:remove( i );
        temp = nil;
    end
    display.remove( self.objectPool );
    self.objectPool = nil;
end

return M;