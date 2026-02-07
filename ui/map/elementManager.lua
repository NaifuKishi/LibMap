-- ElementManager für LibMap
-- Verwaltet die Wiederverwendung von UI-Elementen, um Performance zu optimieren

local ElementManager = {}
local elementPool = {}

-- Fügt ein Element dem Pool hinzu
function ElementManager.ReturnElement(element)
    if element and element.GetType and element.SetVisible then
        element:SetVisible(false)
        table.insert(elementPool, element)
    end
end

-- Holt ein Element aus dem Pool oder erstellt ein neues
function ElementManager.GetElement(elementType, elementName, parent, elementClass)
    -- Suche nach einem passenden Element im Pool
    for i, element in ipairs(elementPool) do
        if element.GetType and element:GetType() == elementType then
            table.remove(elementPool, i)
            element:Reset(elementName, parent)
            return element
        end
    end
    -- Falls kein passendes Element im Pool, erstelle ein neues
    return LibMap.uiCreateFrame(elementClass, elementName, parent)
end

-- Setzt ein Element zurück, um es wiederverwendbar zu machen
function ElementManager.ResetElement(element, elementName, parent)
    element:SetId(elementName)
    element:SetParent(parent)
    element:SetVisible(true)
    -- Weitere Eigenschaften zurücksetzen, falls nötig
end

-- Gibt die aktuelle Größe des Pools zurück (für Debugging)
function ElementManager.GetPoolSize()
    return #elementPool
end

-- Leert den Pool (z.B. beim Beenden des Addons)
function ElementManager.ClearPool()
    for _, element in ipairs(elementPool) do
        if element.destroy then
            element:destroy()
        end
    end
    elementPool = {}
end

return ElementManager