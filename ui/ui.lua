local addonInfo, privateVars = ...

---------- init namespace ---------

if not LibMap then LibMap = {} end
if not LibMap.ui then LibMap.ui = {} end

if not privateVars.uiFunctions then privateVars.uiFunctions = {} end
if not privateVars.uiNames then privateVars.uiNames = {} end

if privateVars.uiContext == nil then privateVars.uiContext = UI.CreateContext("LibMap.ui") end

if not privateVars.uiElements then privateVars.uiElements  = {} end

local data       		= privateVars.data
local internal   		= privateVars.internal
local uiFunctions		= privateVars.uiFunctions
local uiNames    		= privateVars.uiNames
local uiElements		= privateVars.uiElements

local uiContext   		= privateVars.uiContext
local uiTooltipContext	= nil

if not uiElements.messageDialog then uiElements.messageDialog = {} end
if not uiElements.confirmDialog then uiElements.confirmDialog = {} end

local InspectSystemSecure 		= Inspect.System.Secure
local InspectAddonCurrent 		= Inspect.Addon.Current
local InspectAbilityNewDetail	= Inspect.Ability.New.Detail
local InspectAbilityDetail		= Inspect.Ability.Detail
local stringUpper				= string.upper
local stringFormat				= string.format
local stringLower				= string.lower
local stringGSub				= string.gsub

---------- init variables --------- 

data.frameCount = 0
data.canvasCount = 0
data.textCount = 0
data.textureCount = 0
data.uiBoundLeft, data.uiBoundTop, data.uiBoundRight, data.uiBoundBottom = UIParent:GetBounds()

---------- init local variables ---------

local _fonts = {}

---------- addon internal function block ---------

function internal.uiCheckTooltips ()

	-- local now = oFuncs.oInspectTimeFrame()
	-- if tooltipCheckTime == nil or now - tooltipCheckTime > 1 then
		-- tooltipCheckTime = now

		if uiElements.abilityTooltip ~= nil and uiElements.abilityTooltip:GetVisible() == true then
			if uiElements.abilityTooltip:GetTarget():GetVisible() == false then uiElements.abilityTooltip:SetVisible(false) end
		end
	
		if uiElements.genericTooltip ~= nil and uiElements.genericTooltip:GetVisible() == true then
			if uiElements.genericTooltip:GetTarget():GetVisible() == false then uiElements.genericTooltip:SetVisible(false) end
		end
	
		if uiElements.itemTooltip ~= nil and uiElements.itemTooltip:GetVisible() == true then
			if uiElements.itemTooltip:GetTarget():GetVisible() == false then uiElements.itemTooltip:SetVisible(false) end
		end
	--end

end


function internal.uiSetupBoundCheck()

	local testFrameH = LibEKL.UICreateFrame ('nkFrame', "LibMap.ui.boundTestFrameH", uiContext)
	testFrameH:SetBackgroundColor(0, 0, 0, 0)
	testFrameH:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
	testFrameH:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 1)

	testFrameH:EventAttach(Event.UI.Layout.Size, function (self)
		data.uiBoundLeft, data.uiBoundTop, data.uiBoundRight, data.uiBoundBottom = UIParent:GetBounds()
	end, testFrameH:GetName() .. ".UI.Layout.Size")

	local testFrameV = LibEKL.UICreateFrame("nkFrame", "boundTestFrameV", uiContext)
	testFrameV:SetBackgroundColor(0, 0, 0, 0)
	testFrameV:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
	testFrameV:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 1, 0)

	testFrameV:EventAttach(Event.UI.Layout.Size, function (self)		
		data.uiBoundLeft, data.uiBoundTop, data.uiBoundRight, data.uiBoundBottom = UIParent:GetBounds()
	end, testFrameV:GetName() .. ".UI.Layout.Size")
	
end

---------- library public function block ---------


function LibMap.uiCreateFrame (frameType, name, parent)

	if frameType == nil or name == nil or parent == nil then
		LibEKL.Tools.Error.Display (addonInfo.identifier, stringFormat("LibMap.uiCreateFrame - invalid number of parameters\nexpecting: type of frame (string), name of frame (string), parent of frame (object)\nreceived: %s, %s, %s", frameType, name, parent))
		return
	end

	local uiObject = nil

	local checkFrameType = stringUpper(frameType) 
	local func = uiFunctions[checkFrameType]
	if func == nil then
		LibEKL.Tools.Error.Display (addonInfo.identifier, stringFormat("LibMap.uiCreateFrame - unknown frame type [%s]", frameType))
	else
		uiObject = func(name, parent)
	end

	return uiObject

end

function LibMap.uiSetBounds(left, top, right, bottom)

  if left ~= nil then data.uiBoundLeft = left end
  if top ~= nil then data.uiBoundTop = top end
  if right ~= nil then data.uiBoundRight = right end
  if bottom ~= nil then data.uiBoundBottom = bottom end

end

function LibMap.uiGetBoundLeft ()
	return data.uiBoundLeft
end

function LibMap.uiGetBoundRight ()
	return data.uiBoundRight
end

function LibMap.uiGetBoundTop ()
	return data.uiBoundTop
end

function LibMap.uiGetBoundBottom ()
	return data.uiBoundBottom
end

function LibMap.uiClearBounds()

  data.uiBoundLeft, data.uiBoundTop, data.uiBoundRight, data.uiBoundBottom = UIParent:GetBounds()
  
end

-- generic ui functions to handle screen size and bounds

function LibMap.ui.registerFont (addonId, name, path)

	if _fonts[addonId] == nil then _fonts[addonId] = {} end

	_fonts[addonId][name] = path

end


function LibMap.ui.getFont (addonId, name, path)

	if _fonts[addonId] == nil then return nil end

	return _fonts[addonId][name]

end

function LibMap.ui.setFont (uiElement, addonId, name)

	uiElement:SetFont(addonId, _fonts[addonId][name])

end