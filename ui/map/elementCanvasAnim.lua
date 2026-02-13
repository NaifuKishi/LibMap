local addonInfo, privateVars = ...

---------- init namespace ---------

if not LibMap then LibMap = {} end

if not privateVars.uiFunctions then privateVars.uiFunctions = {} end

local uiFunctions   = privateVars.uiFunctions
local internal      = privateVars.internal
local mapData       = privateVars.mapData

local mathFloor		= math.floor
local mathRad		= math.rad
local mathAbs		= math.abs

---------- addon internal function block ---------

local function _uiMapElementCanvasAnim(name, parent)

	local thisData = nil
	local parentMap = nil
	local zoom = 1
	local tooltipTitle = nil
	local tooltipLines = nil
	local maxZoom = 4
	local waypoint = nil
	--local radian = nil
	local tooltip = false
	local effectName = nil
	local fill = nil
	local stroke = nil  
	local duplicate = false
	local visibleState = false
	local animationSpeed = 0
	local lastX, lastY = 0, 0
	local lastAngle = 0
	local thisId
	local elementType

	local path = {{xProportional = 0, yProportional = 0}, {xProportional = 0, yProportional = 1}, {xProportional = 1, yProportional = 1},  {xProportional = 1, yProportional = 0}, {xProportional = 0, yProportional = 0}}

	local coordX, coordY, zoom = 0, 0, nil

	local mapElement = LibEKL.UICreateFrame("nkCanvas", name .. ".canvasAnim", parent)
	mapElement:SetLayer(2)
	mapElement:SetVisible(false)

	function mapElement:SetParentMap(newParentMap) parentMap = newParentMap end

	function mapElement:SetType(newElementType)

		elementType = newElementType

		thisData = mapData.mapElements[newElementType]
		
		mapElement:SetWidth(thisData.width)
		mapElement:SetHeight(thisData.height)

		if thisData.path ~= nil then path = thisData.path end

		fill = thisData.fill
		stroke = thisData.stroke

		if parentMap:GetAnimated() == true then
			mapElement:RegisterAnimation (parentMap:GetAnimationSpeed())
		else
			mapElement:SetShape(path, fill, stroke)
		end

		if thisData.layer ~= nil then mapElement:SetLayer(thisData.layer) end
		
	end

	function mapElement:GetElementType() return elementType end

	function mapElement:SetToolTip(title, newDesc)

		if title == nil and newDesc == nil then return end

		local descStart

		if title ~= nil then    
			tooltipTitle = LibEKL.strings.trim (title)
			if newDesc ~= nil then descStart = 1 end
		else 
			tooltipTitle, descStart = newDesc[1], 2
		end

		tooltipLines = {}

		if descStart ~= nil then
			for idx = descStart, #newDesc, 1 do
				table.insert (tooltipLines, { text = newDesc[idx], wordwrap = true, minWidth = 250 })
			end
		end

	end

	function mapElement:SetCoord(x, y)

		if x == coordX and y == coordY then return end

		if x ~= nil then coordX = x end
		if y ~= nil then coordY = y end

		if coordX == nil or coordY == nil then return end

		local mapInfo = parentMap:GetMapInfo()

		local xP = 1 / (mapInfo.x2 - mapInfo.x1) * (coordX - mapInfo.x1)
		local yP = 1 /  (mapInfo.y2 - mapInfo.y1) * (coordY - mapInfo.y1) 

		local thisX, thisY

		local thisMap = parentMap:GetMap()

		thisX = (thisMap:GetWidth() * xP) - (mapElement:GetWidth() / 2)
		thisY = (thisMap:GetHeight() * yP) - (mapElement:GetWidth() / 2)

		if mathFloor(thisX) ~= lastX or mathFloor(thisY) ~= lastY then

			lastX = mathFloor(thisX)
			lastY = mathFloor(thisY)

			mapElement:SetPoint("TOPLEFT", thisMap, "TOPLEFT", thisX, thisY)
		end

	end

	function mapElement:SetZoom(newZoom)
	
		if newZoom == zoom then return end

		local factor = thisData.factor or 1

		if thisData.minZoom ~= nil then 
			if thisData.minZoom > newZoom then
				mapElement:SetHeight(thisData.width / thisData.minZoom * newZoom * factor)
				mapElement:SetWidth(thisData.height / thisData.minZoom * newZoom * factor)
			else
				mapElement:SetHeight(thisData.width * factor)
				mapElement:SetWidth(thisData.height * factor)
			end
		else
			mapElement:SetHeight(thisData.width / maxZoom * newZoom* factor)
			mapElement:SetWidth(thisData.height / maxZoom * newZoom* factor)
		end

		zoom = newZoom

		if coordX ~= nil and coordY ~= nil then mapElement:SetCoord() end

		local scale = 1 / thisData.width * mapElement:GetWidth()
		LibMap.fx.update (effectName, { scale = scale}) 
		
	end

	--[[
	function mapElement:SetAngle(angle) 

		if lastAngle == nil then lastAngle = 0 end

		local newAngle = angle

		if newAngle == lastAngle then return end

		local newRadian

		if thisData.angleCorr ~= nil then
			newRadian = mathRad(angle + thisData.angleCorr)
		else
			newRadian = mathRad(angle)
		end

		if radian == nil or mathAbs(newRadian - radian) > .1 then
			radian = newRadian
			mapElement:ReDraw()
		end

		lastAngle = newAngle

	end

	function mapElement:ReDraw()

		local scale = 1 / thisData.width * mapElement:GetWidth()

		if radian ~= nil then 
			fill.transform = LibEKL.Tools.Gfx.Rotate(mapElement, radian, scale)
		end

		mapElement:SetShape(path, fill, stroke)
		
	end	
]]

	function mapElement:GetCoord() return coordX, coordY end
	function mapElement:GetTooltip() return tooltip end

	----- Animation

	function mapElement:RegisterAnimation (thisAnimationSpeed)

		if parentMap:GetAnimated() == true then
			if thisData.anim == "rotation" then
				effectName = name .. ".rotate"

				--local animZoom = thisData.animZoom or 1
				local scale = 1 / thisData.width * mapElement:GetWidth()

				LibMap.fx.register (effectName, mapElement, {id = "rotateCanvas", speed = (thisAnimationSpeed or 0), scale = scale, path = path, fill = fill  })
			elseif thisData.anim == "pulse" then
				effectName = name .. ".pulse"

				local scale = 1 / thisData.width * mapElement:GetWidth()

				LibMap.fx.register (effectName, mapElement, {id = "pulseCanvas", speed = (thisAnimationSpeed or 0), scale = scale, path = path, fill = fill  })
			elseif thisData.anim == "animation" then
				effectName = name .. ".animation"

				local animZoom = thisData.animZoom or 1				
				local scale = animZoom or 1 / thisData.width * mapElement:GetWidth()

				LibMap.fx.register (effectName, mapElement, {id = "animateCanvas", speed = .2, scale = scale, path = path, fill = fill, textureList = thisData.textureList })
			else
				effectName = nil
			end
		end

	end

	function mapElement:SetAnimated(flag, newAnimationSpeed)
		
		if thisData.anim == nil then return end

		if newAnimationSpeed ~= animationSpeed then
			animationSpeed = newAnimationSpeed or 0
			if effectName ~= nil then 
				LibMap.fx.cancel(effectName)
				effectName = nil 
			end
		end	
	
		if flag == true then
			if effectName == nil then mapElement:RegisterAnimation(animationSpeed) end
		else
			if effectName ~= nil then 
				LibMap.fx.cancel(effectName)
				effectName = nil 
			end
		end
	end

	function mapElement:SetId(newId) thisId = newId end
	function mapElement:GetId() return thisId end
	function mapElement:GetType() return "nkMapElementCanvasAnim" end

	local oSetVisible = mapElement.SetVisible

	function mapElement:SetVisible(flag)
		if flag == visibleState then return end
		visibleState = flag
		oSetVisible(self, flag)

		if effectName then
			if flag then
				LibMap.fx.updateTime(effectName)
			else
				LibMap.fx.pauseEffect(effectName)
			end
		end
	end

	function mapElement:Reset()
		
		LibMap.fx.cancel(effectName)
		effectName = nil

		fill = thisData.fill
		stroke = thisData.stroke
		mapElement:SetShape(path, fill, stroke)

		mapElement:SetWidth(thisData.width)
		mapElement:SetHeight(thisData.height)

		path = {{xProportional = 0, yProportional = 0}, {xProportional = 0, yProportional = 1}, {xProportional = 1, yProportional = 1},  {xProportional = 1, yProportional = 0}, {xProportional = 0, yProportional = 0}}
		fill = nil
		stroke = nil  

		coordX, coordY, zoom = 0, 0, nil
		lastX, lastY = 0, 0				
		lastAngle = 0

		thisData = nil		
		thisId = nil
		elementType = nil

		tooltipTitle = nil
		tooltipLines = nil
		--radian = nil
		visibleState = false
		
  	end

	----- Events

	mapElement:EventAttach(Event.UI.Input.Mouse.Cursor.In, function ()
	
		if tooltipTitle == nil then return end

		local thisTooltip = parentMap:GetTooltip()

		thisTooltip:SetTitle(tooltipTitle)
		thisTooltip:SetLines(tooltipLines)
		thisTooltip:ClearPoint("TOPRIGHT")
		thisTooltip:SetPoint("TOPLEFT", mapElement, "CENTER", 10, 0)

		if thisTooltip:GetLeft() + thisTooltip:GetWidth() > parentMap:GetLeft() + parentMap:GetWidth() or thisTooltip:GetLeft() + thisTooltip:GetWidth() > UIParent:GetLeft() + UIParent:GetWidth() then
			thisTooltip:ClearPoint("TOPLEFT")
			thisTooltip:SetPoint("TOPRIGHT", mapElement, "CENTER", -10, 0)
		end

		thisTooltip:SetVisible(true)
		tooltip = true
		
	end, mapElement:GetName() .. ".Cursor.In")

	mapElement:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function ()

		local thisTooltip = parentMap:GetTooltip()
	
		thisTooltip:SetVisible(false)
		tooltip = false
		
	end, mapElement:GetName() .. ".Cursor.Out")

	return mapElement
  
end

uiFunctions.NKMAPELEMENTCANVASANIM = _uiMapElementCanvasAnim