function Player:sendItemInspection(item, descriptions, openCyclopedia, isVirtual)
    local response = NetworkMessage()
    response:addByte(0x76) -- header
    response:addByte(0x00) -- switch

    response:addByte(openCyclopedia and 0x01 or 0x00)
    response:addU32(0)
    response:addByte(0x01)

    if tonumber(item) then
        local itemType = ItemType(item)
        if not itemType then
            self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
            return
        end

        response:addString(string.format("%s", itemType:getNameDescription(nil, true)))
        response:addItemType(itemType)
        item = itemType
    else
        response:addString(string.format("%s", item:getNameDescription(item:getSubType(), true)))
        response:addItem(item)
    end

    if ImbuingSystem then
        response:addImbuements(item, isVirtual)
    else
        response:addByte(0)
    end

    if descriptions and #descriptions > 0 then
        response:addByte(#descriptions)
        for i = 1, #descriptions do
            response:addString(descriptions[i][1])
            response:addString(descriptions[i][2])
        end
    else
        response:addByte(0)
    end

    response:sendToPlayer(self)
end

function getItemDetails(item)
    local isVirtual = false
    local itemType

    if tonumber(item) then
        isVirtual = true
        itemType = ItemType(item)
        if not itemType then
            return
        end
        item = itemType
    elseif item:isItemType() then
        isVirtual = true
        itemType = item
    else
        itemType = item:getType()
    end

    local descriptions = {}

    local desc = itemType:getDescription()
    if not isVirtual and item:hasAttribute(ITEM_ATTRIBUTE_DESCRIPTION) then
        desc = item:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION)
    end

    if desc and #desc > 0 then
        descriptions[#descriptions + 1] = {"Description", desc}
    end

    if ImbuingSystem then
        for _, imbuement in pairs(getInspectImbuements(item, isVirtual)) do
            descriptions[#descriptions + 1] = imbuement
        end
    end

    return descriptions
end
