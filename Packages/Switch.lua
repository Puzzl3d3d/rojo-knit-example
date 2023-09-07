local module = {}
local switch = {}

switch.__index = switch

module.__call = function(t, var): Switch
	local switchObject = {}
	
	switchObject.var = var
	
	setmetatable(switchObject, switch)
	
	return switchObject
end

function switch:case(value: any, callback: ()->(), ...): Switch
	if self.expired then return self end
	if self.var == value then
		self.returned = {callback(...)}
		self.expired = true
	end
	return self
end
function switch:otherwise(callback: ()->(), ...): Switch-- Cannot use name "else" because it is a reserved keyword
	if self.expired then return self end
	self.returned = {callback(...)}
	self.expired = true
	return self
end

-- Aliases
switch.other = switch.otherwise
switch.except = switch.otherwise
switch.unless = switch.otherwise

switch.match = switch.case

type case = (any, (any?)->(any?), any?) -> Switch
type otherwise = ((any?)->(any?), any?) -> Switch
export type Switch = {
	case: case,
	match: case,
	
	otherwise: otherwise,
	other: otherwise,
	except: otherwise,
	unless: otherwise	
}

return setmetatable(module, module)