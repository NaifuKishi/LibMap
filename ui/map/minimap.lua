local addonInfo, privateVars = ...

---------- init namespace ---------

if not LibMap then LibMap = {} end

if not privateVars.uiFunctions then privateVars.uiFunctions = {} end
if not privateVars.elementManager then privateVars.elementManager = {} end

local uiFunctions   	= privateVars.uiFunctions
local internal      	= privateVars.internal
local data          	= privateVars.data
local mapData       	= privateVars.mapData
local elementManager	= privateVars.elementManager

local inspectAddonCurrent	= Inspect.Addon.Current
local inspectMouse			= Inspect.Mouse

local stringFormat			= string.format
local stringLower			= string.lower
local stringFind			= string.find

local mathFloor				= math.floor
local mathAbs				= math.abs
local mathMax				= math.max

local LibMapUUID				= LibEKL.Tools.UUID

---------- addon internal function block ---------

local function _uiMiniMap(name, parent)

	if LibMap.internal.checkEvents (name, true) == false then return nil end 

	---------- VARIABLES ---------- 

	local activeMap = nil;
	local activeType = nil;
	local mapInfo = nil
	local scale = nil
	local scaleStep = nil
	local x, y
	local drag = false
	local mouseData = nil
	local coordX, coordY = 0, 0
	local elements = {}
	local checkIdentical = {}
	local maximized = false
	local maximizedX, maximizedY = 1, 1
	local maximizedScale = 1
	local width, height = 425, 370
	local maximizedWidth, maximizedHeight = 800, 600
	local origCoordX, origCoordY = nil, nil, nil
	local origX, origY = nil, nil
	local maxZoom = 6
	local cursorX, cursorY
	local coordsArea = {}
	local waypoint = nil
	local cursorCoordX, cursorCoordY
	local animated = true
	local smoothScroll = true  
	local animationSpeed = 0
	local allowWayPoints = true

	local mapWidth, mapHeight
	local maskWidth, maskHeight

	---------- UI ELEMENTS ----------

	local ui = LibEKL.UICreateFrame("nkWindowElement", name .. ".window", parent)
	ui:SetWidth(425)
	ui:SetHeight(370)
	ui:SetDragable(true)
	ui:SetCloseable(false)
	ui:SetFontSize(12) 

	local mask = UI.CreateFrame('Mask', name .. ".mask", ui:GetContent())
	mask:SetPoint("TOPLEFT", ui:GetContent(), "TOPLEFT")
	mask:SetPoint("BOTTOMRIGHT", ui:GetContent(), "BOTTOMRIGHT")

	local testFrame = LibEKL.UICreateFrame("nkFrame", name .. ".text", mask)
	testFrame:SetPoint("CENTER", mask, "CENTER")
	testFrame:SetWidth(5)
	testFrame:SetHeight(5)
	testFrame:SetBackgroundColor(1, 0, 0, 1)
	testFrame:SetLayer(99)

	maskHeight = mask:GetHeight()
	maskWidth = mask:GetWidth()

	local lastTileX, lastTileY

	local mapTiles = {}

	for idx1 = 1, 3, 1 do
		for idx2 = 1, 3, 1 do
			local thisMap = LibEKL.UICreateFrame("nkTexture", stringFormat("%s.map.%dx%d", name, idx1, idx2), mask)
			thisMap:SetLayer(1)
			table.insert(mapTiles, thisMap)
		end
	end
	
	mapTiles[5]:SetPoint("CENTER", mask, "CENTER")
	mapTiles[4]:SetPoint("CENTERRIGHT", mapTiles[5], "CENTERLEFT")
	mapTiles[6]:SetPoint("CENTERLEFT", mapTiles[5], "CENTERRIGHT")

	mapTiles[2]:SetPoint("CENTERBOTTOM", mapTiles[5], "CENTERTOP")
	mapTiles[1]:SetPoint("CENTERRIGHT", mapTiles[2], "CENTERLEFT")	
	mapTiles[3]:SetPoint("CENTERLEFT", mapTiles[2], "CENTERRIGHT")
		
	mapTiles[8]:SetPoint("CENTERTOP", mapTiles[5], "CENTERBOTTOM")
	mapTiles[7]:SetPoint("CENTERRIGHT", mapTiles[8], "CENTERLEFT")	
	mapTiles[9]:SetPoint("CENTERLEFT", mapTiles[8], "CENTERRIGHT")

	function ui:SetWorld(newWorld)
		mapInfo = newWorld
		lastTileX, lastTileY = nil, nil
	end

	function ui:SetCoord(x, y)
		-- 1. Kachel-Koordinaten berechnen
		local tileX = math.floor(x / 256) * 256
		local tileY = math.floor(y / 256) * 256

		-- 2. Offset innerhalb der Kachel berechnen
		local offsetX = x % 256
		local offsetY = y % 256

		-- 3. Verschiebung berechnen, um den Spieler in die Mitte zu bringen
		local shiftX = 128 - offsetX
		local shiftY = 128 - offsetY

    	-- Apply the offset to the center tile
    	mapTiles[5]:SetPoint("CENTER", mask, "CENTER", shiftX, shiftY)

		-- Only update textures when the tile changes
		if tileX ~= lastTileX or tileY ~= lastTileY then
			lastTileX = tileX
			lastTileY = tileY

			mapTiles[1]:SetTextureAsync("Rift", stringFormat(mapInfo.path, tileX - 256, tileY - 256))
			mapTiles[2]:SetTextureAsync("Rift", stringFormat(mapInfo.path, tileX, tileY - 256))
			mapTiles[3]:SetTextureAsync("Rift", stringFormat(mapInfo.path, tileX + 256, tileY - 256))

			mapTiles[4]:SetTextureAsync("Rift", stringFormat(mapInfo.path, tileX - 256, tileY))
			mapTiles[5]:SetTextureAsync("Rift", stringFormat(mapInfo.path, tileX, tileY))
			mapTiles[6]:SetTextureAsync("Rift", stringFormat(mapInfo.path, tileX + 256, tileY))

			mapTiles[7]:SetTextureAsync("Rift", stringFormat(mapInfo.path, tileX - 256, tileY + 256))
			mapTiles[8]:SetTextureAsync("Rift", stringFormat(mapInfo.path, tileX, tileY + 256))
			mapTiles[9]:SetTextureAsync("Rift", stringFormat(mapInfo.path, tileX + 256, tileY + 256))
		end

	end

	return ui
	
end

uiFunctions.NKMINIMAP = _uiMiniMap