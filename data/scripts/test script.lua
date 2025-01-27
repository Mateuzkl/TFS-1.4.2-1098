local talkaction = TalkAction("/test")

function talkaction.onSay(player, words, param, type)
    local itemId = 2400  -- ID of the item to be created

    local item = player:addItem(itemId, 1)
    if not item then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to create the item.")
        return false
    end

    item:setImbuement(0, IMBUEMENT_CRIT_3, IMBUING_DEFAULT_DURATION)
    item:setImbuement(1, IMBUEMENT_LEECH_LIFE_3, IMBUING_DEFAULT_DURATION)
    item:setImbuement(2, IMBUEMENT_LEECH_MANA_3, IMBUING_DEFAULT_DURATION)

    local totalSlots = item:getType():getImbuingSlots()

    if totalSlots > 0 then
        local emptySlots = 0
        for i = 0, totalSlots - 1 do
            if item:getImbuement(i) == nil then
                emptySlots = emptySlots + 1
            end
        end

        player:sendTextMessage(MESSAGE_INFO_DESCR, "The item has " .. totalSlots .. " imbuement slots.")

        if emptySlots > 0 then
            player:sendTextMessage(MESSAGE_INFO_DESCR, "The item has " .. emptySlots .. " empty slots.")
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, "All slots are filled.")
        end
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "This item has no imbuement slots.")
    end

    return true
end

talkaction:register()

local talkaction = TalkAction("/testcheck")

function talkaction.onSay(player, words, param, type)
    local slot = CONST_SLOT_LEFT -- Check the item in the left hand (weapon/shield)
    local item = player:getSlotItem(slot)

    if not item then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not holding any item in your left hand.")
        return false
    end

    local totalSlots = item:getType():getImbuingSlots()

    if totalSlots > 0 then
        local emptySlots = 0
        for i = 0, totalSlots - 1 do
            if item:getImbuement(i) == nil then
                emptySlots = emptySlots + 1
            end
        end

        player:sendTextMessage(MESSAGE_INFO_DESCR, "The item in your left hand has " .. totalSlots .. " imbuement slots.")

        if emptySlots > 0 then
            player:sendTextMessage(MESSAGE_INFO_DESCR, "The item has " .. emptySlots .. " empty slots.")
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, "All slots are filled.")
        end
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "The item in your left hand has no imbuement slots.")
    end

    return true
end

talkaction:register()
