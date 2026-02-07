local addonInfo, privateVars = ...

local elementManager 	= privateVars.elementManager

local elementPool = {
    ["nkMapElementCanvas"] = {},
    ["nkMapElementTexture"] = {}
}

-- Fügt ein Element dem Pool hinzu
function elementManager.ReturnElement(elementType, element)

    element:SetVisible(false)
    element:destroy()
    table.insert(elementPool[elementType], element)

end

-- Holt ein Element aus dem Pool oder erstellt ein neues
function elementManager.GetElement(elementType, elementName, parent)

    if next(elementPool[elementType]) then
        local element = table.remove(elementPool[elementType])
        --element:Reset(elementName, parent)
        return element
    end

    -- Falls kein passendes Element im Pool, erstelle ein neues
    return LibMap.uiCreateFrame(elementType, elementName, parent)

end

-- Setzt ein Element zurück, um es wiederverwendbar zu machen
function elementManager.ResetElement(element, elementName, parent)

    element:SetId(elementName)
    element:SetParent(parent)
    element:SetVisible(true)
    -- Weitere Eigenschaften zurücksetzen, falls nötig
end

-- Gibt die aktuelle Größe des Pools zurück (für Debugging)
function elementManager.GetPoolSize()
    return #elementPool
end