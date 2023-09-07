-- Module by @Puzzled3d

local EasyDatastore = {}
local StoreStruct = {}

local LastData = {}

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

function EasyDatastore._getPlayerKey(plr: number|Player|string): string
	if typeof(plr) == "string" then return plr end    

	local user_id = if typeof(plr) == "number" then plr else plr.UserId

	return "Player_"..user_id
end
function EasyDatastore._getPlr(plr: number|Player|string): Player
	local userId
	if typeof(plr) == "string" then
		-- Remove everything but the numbers
		-- E.g. Converts "Player_12345" (string) into 12345 (number)
		userId = tonumber(({plr:gsub("%D", "")})[1])
	elseif typeof(plr) == "number" then
		userId = plr
	else
		return plr
	end
	return Players:GetPlayerByUserId(userId)
end
function EasyDatastore.OnGetError(plr, err, ds_key)
	if plr then
		plr:Kick("Unexpected error getting data, please rejoin")
	else
		print("OnGetError | Player is nil")
	end
end
function EasyDatastore.OnSetError(plr, err, ds_key)
	warn("EasyDatastore | Could not save player data")
end
function EasyDatastore._get(plr: number|Player|string, ds_key, default)
	local key
	if typeof(plr) == "string" then
		key = plr
	else
		key = EasyDatastore._getPlayerKey(plr)
	end

	if not LastData[key] then LastData[key] = {} end

	if LastData[key][ds_key] then
		return LastData[key][ds_key]
	end

	local datastore = DataStoreService:GetDataStore(ds_key)

	local success, data = pcall(datastore.GetAsync, datastore, EasyDatastore._getPlayerKey(plr))

	if not success then
		warn("EasyDatastore | Error in Get function with key",ds_key,"and player",EasyDatastore._getPlr(plr),"|",data)
		EasyDatastore.OnGetError(EasyDatastore._getPlr(plr), data, ds_key)

		return
	end

	return data or default
end
function EasyDatastore._set(ds_key, plr: number|Player|string, data)
	local datastore = DataStoreService:GetDataStore(ds_key)

	local key
	if typeof(plr) == "string" then
		key = plr
	else
		key = EasyDatastore._getPlayerKey(plr)
	end

	if not LastData[key] then LastData[key] = {} end

	LastData[key][ds_key] = data

	local success, err
	if data then
		success, err = pcall(datastore.SetAsync, datastore, key, data)
	else
		success, err = pcall(datastore.RemoveAsync, datastore, key)
	end

	if not success then
		warn("EasyDatastore | Error in Set function with key",ds_key,"and player",EasyDatastore._getPlr(plr),"|",err)
		EasyDatastore.OnSetError(EasyDatastore._getPlr(plr), err, ds_key)
	end

	return success
end
function EasyDatastore._increment(ds_key, plr: number|Player|string, amount)
	local oldData = EasyDatastore._get(plr, ds_key, 0)
	return EasyDatastore._set(ds_key, plr, oldData + amount)
end

function StoreStruct:set(plr: number|Player|string, data)
	return EasyDatastore._set(self.key, plr, data)
end
function StoreStruct:increment(plr, amount)
	return EasyDatastore._increment(self.key, plr, amount)
end
function StoreStruct.__call(self, ...)
	local args = {...}
	local player = args[1]
	table.remove(args, 1)
	-- Get function
	return EasyDatastore._get(player, self.key, unpack(args))
end

StoreStruct.__index = StoreStruct

EasyDatastore.__index = function(table, key)
	local store = setmetatable({}, StoreStruct)

	store.key = key

	return store
end

setmetatable(EasyDatastore, EasyDatastore)

-- Event handling
game.ReplicatedStorage:FindFirstChild("EDSS_Remote", true).OnServerInvoke = function(player, index, default)
	return select(2, pcall(EasyDatastore[index], player, default))
end

return EasyDatastore