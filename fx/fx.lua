local addonInfo, privateVars = ...

---------- init namespace ---------

if not LibMap then LibMap = {} end
if not LibMap.fx then LibMap.fx = {} end

local internal   = privateVars.internal

local InspectTimeReal 		= Inspect.Time.Real
local InspectAddonCurrent	= Inspect.Addon.Current

local mathRad = math.rad

---------- init local variables ---------

local _fxStore = {}
local _fxCount = 0

---------- library public function block ---------

function LibMap.fx.register (id, frame, effect)

	if _fxStore[id] == nil then _fxCount = _fxCount + 1 end
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

	if not _fxStore or not id or not _fxStore[id] then return end
	_fxStore[id] = nil
	if _fxCount > 0 then _fxCount = _fxCount - 1 end

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

	if _fxCount == 0 then return end

	local debugId
	if nkDebug then debugId = nkDebug.traceStart (InspectAddonCurrent(), "LibMap internal.processFX") end

	local now = InspectTimeReal()

	-- das Problem scheint zu sein wenn die Size ändert und die Texture nicht passt

	for id, details in pairs (_fxStore) do

		if details.frame:GetVisible() then

			if _fxStore[id].lastUpdate ~= nil then				
				if details.effect.id == "rotateCanvas" then
					if now - _fxStore[id].lastUpdate > (details.effect.speed or 1) then
						_fxStore[id].lastUpdate = now
						if details.angle == nil then details.angle = 0 else details.angle = details.angle + 1 end
						details.effect.fill.transform = LibEKL.Tools.Gfx.Rotate(details.frame, mathRad(details.angle), (details.effect.scale or 1))						
						details.frame:SetShape(details.effect.path, details.effect.fill, nil)
					end
				end
			end
		end
	end

	if nkDebug then nkDebug.traceEnd (InspectAddonCurrent(), "LibMap internal.processFX", debugId) end	

end