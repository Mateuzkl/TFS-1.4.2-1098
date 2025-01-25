local event = Event()

local function debugLog(level, message, ...)
    local prefix = "[Debug][" .. level .. "] "
    print(prefix .. string.format(message, ...))
end

event.onDropLoot = function(self, corpse)
    local mType = self:getType()
    
    if mType:isRewardBoss() then
        corpse:registerReward()
        debugLog("info", "Registered reward for boss %s.", mType:getNameDescription())
        return
    end
    
    if configManager.getNumber(configKeys.RATE_LOOT) == 0 then
        debugLog("warning", "Loot rate is set to 0, no loot will be dropped.")
        return
    end
    
    local player = Player(corpse:getCorpseOwner())
    if not player then
        debugLog("error", "Corpse owner is invalid or missing.")
        return false
    end
    
    local bonusPrey = 0
    local percent = 1
    local preyBonusActive = false

    -- Prey Bonus Loot
    local preyBonusLoot = player:getPreyBonusLoot(mType)
    if preyBonusLoot > 0 then
        debugLog("info", "Player %s has a prey bonus loot of %d%% for monster type %s.", 
            player:getName(), preyBonusLoot, mType:getNameDescription())
        
        if preyBonusLoot >= math.random(100) then
            bonusPrey = preyBonusLoot
            percent = percent + (bonusPrey / 100)
            preyBonusActive = true
            debugLog("info", "Prey bonus applied! New loot percent: %.2f", percent)
        else
            debugLog("info", "Prey bonus not applied due to random chance.")
        end
    else
        debugLog("info", "No prey bonus loot for monster type %s.", mType:getNameDescription())
    end
    
    local lootText
    if player:getStamina() > 840 then
        local monsterLoot = mType:getLoot()
        
        for i, lootItem in ipairs(monsterLoot) do
            local originalChance = lootItem.chance
            local chance = originalChance * percent
            
            debugLog("info", "Processing loot item %d: Original chance = %.2f%%, Adjusted chance = %.2f%%.", 
                lootItem.itemId, originalChance / 1000, chance / 1000)
            
            if chance > 0 and math.random(100000) <= chance then
                local itemId = lootItem.itemId
                local maxCount = lootItem.maxCount or 1
                local count = math.random(1, maxCount)
                local adjustedCount = math.ceil(count * percent)
                
                local item = Game.createItem(itemId, adjustedCount)
                if item then
                    if corpse:addItemEx(item) ~= RETURNVALUE_NOERROR then
                        item:remove()
                        debugLog("error", "Failed to add item %d to corpse.", itemId)
                    else
                        debugLog("info", "Added item %d to corpse (Original count: %d, Adjusted count: %d).", 
                            itemId, count, adjustedCount)
                    end
                else
                    debugLog("error", "Failed to create item %d.", itemId)
                end
            end
        end
        
        if preyBonusActive then
            lootText = ("Prey Bonus Loot: Loot of %s: %s."):format(
                mType:getNameDescription(), corpse:getContentDescription())
        else
            lootText = ("Loot of %s: %s."):format(
                mType:getNameDescription(), corpse:getContentDescription())
        end
    else
        lootText = ("Loot of %s: nothing (due to low stamina)."):format(mType:getNameDescription())
    end
    
    local party = player:getParty()
    if party then
        party:broadcastPartyLoot(lootText)
    else
        if player:getStorageValue(Storage.STORAGEVALUE_LOOT) == 1 then
            sendChannelMessage(4, TALKTYPE_CHANNEL_O, lootText)
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, lootText)
        end
    end
end

event:register()
