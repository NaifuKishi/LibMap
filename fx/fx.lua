local addonInfo, privateVars = ...

---------- init namespace ---------

if not LibMap then LibMap = {} end
if not LibMap.fx then LibMap.fx = {} end

local internal   = privateVars.internal

local InspectTimeReal 		= Inspect.Time.Real
local InspectAddonCurrent	= Inspect.Addon.Current

---------- init local variables ---------

local _fxStore = {}

---------- library public function block ---------

function LibMap.fx.register (id, frame, effect)

	_fxStore[id] = { frame = frame, effect = effect }
	_fxStore[id].lastUpdate = InspectTimeReal()

end

function LibMap.fx.update (id, effect)

  if _fxStore[id] == nil then return end

  for key, value in pairs (effect) do
    _fxStore[id].effect[key] = value
  end
  
end

function LibMap.fx.cancel (id) 

	_fxStore[id] = nil 
	
end

function LibMap.fx.updateTime (id)
  if _fxStore[id] ~= nil then
    _fxStore[id].lastUpdate = InspectTimeReal()
    _fxStore[id].lastRun = nil
  end
end

function LibMap.fx.pauseEffect(id)
  if _fxStore[id] ~= nil then
	  _fxStore[id].lastUpdate = nil
  end
end

---------- addon internal function block ---------

function internal.processFX()

	local debugId  
	if nkDebug then debugId = nkDebug.traceStart (InspectAddonCurrent(), "LibMap internal.processFX") end

	local now = InspectTimeReal()


	for id, details in pairs (_fxStore) do

		if details.frame:GetVisible() then

			if _fxStore[id].lastUpdate ~= nil then
				if details.effect.id == "rotateCanvas" then					
					if now - _fxStore[id].lastUpdate > (details.effect.speed or 1) and details.frame:GetVisible() == true then
						_fxStore[id].lastUpdate = now   

						if details.angle == nil then details.angle = 0 else details.angle = details.angle + 1 end

						local radian = math.rad(details.angle)
						--local m = LibEKL.Tools.Gfx.Rotate(details.frame, radian, (details.effect.scale or 1))
						--details.effect.fill.transform = m:Get()    						
						--dump ( LibEKL.Tools.Gfx.Rotate(details.frame, radian, (details.effect.scale or 1)))

						local matrix = LibEKL.Tools.Gfx.Rotate(details.frame, radian, (details.effect.scale or 1))
						--dump (matrix)
						
						details.effect.fill.transform = matrix
						details.frame:SetShape(details.effect.path, details.effect.fill, nil)
						--print (details.frame:GetWidth(), details.frame:GetHeight())
					end    
				end
			end
		end
	end

	if nkDebug then nkDebug.traceEnd (InspectAddonCurrent(), "LibMap internal.processFX", debugId) end	

end