local Utils = {
    Instance = {};
    Math = {};
    Table = {};
    Event = {};
    Class = {};
}

-- Math
function Utils.Math:Random(minimum, maximum)
    return math.random()*(maximum-minimum) + minimum
end

-- Table
function Utils.Table:Random(tbl: {any})
    return tbl[math.random(1, #tbl)]
end
function Utils.Table:Find(tbl: {any}, value: any)
    local keys = {}
    for key,val in pairs(tbl) do
        if val == value then
            table.insert(keys, key)
        end
    end
    if #keys == 1 then
        return unpack(keys)
    elseif #keys > 1 then
        return keys
    end
end

-- Instance
function Utils.Instance:GetRandomChild(instance: Instance)
	return Utils.Table:Random(instance:GetChildren())
end
function Utils.Instance:GetRandomPosition(part: BasePart, padding: number?): Vector3
	local SizeX, SizeY, SizeZ = part.Size.X, part.Size.Y, part.Size.Z
    -- Padding
	SizeX *= padding or 1
	SizeZ *= padding or 1
	
	local MidPosition = part.Position
	
	local PosX = math.random(-SizeX/2, SizeX/2) + MidPosition.X
	local PosY = MidPosition.Y + (SizeY/2)
	local PosZ = math.random(-SizeZ/2, SizeZ/2) + MidPosition.Z
	
	return Vector3.new(PosX, PosY, PosZ)
end
function Utils.Instance:SetCollisionGroup(instance: Instance, group: string?, recursive: boolean?)
    for _,part in pairs( if recursive then instance:GetDescendants() else instance:GetChildren() ) do
        if part:IsA("BasePart") then
            part.CollisionGroup = group or "Default"
        end
    end
end

-- Event
function Utils.Event:BindConnect(func, ...)
    local args = {...}
    return function (...)
        func(unpack(args), ...)
    end
end

-- Class
function Utils.Class:New(parentClass)
    local class = {}

    class.__index = parentClass or class

    setmetatable(class, parentClass or class)

    return class
end

return Utils