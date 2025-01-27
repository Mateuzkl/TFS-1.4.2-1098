function Creature:onChangeOutfit(outfit)
    if hasEvent.onChangeOutfit then
        return Event.onChangeOutfit(self, outfit)
    end
    return true
end

function Creature:onTargetCombat(target)
    if hasEvent.onTargetCombat then
        return Event.onTargetCombat(self, target)
    end
    return RETURNVALUE_NOERROR
end

function Creature:onHear(speaker, words, type)
    if hasEvent.onHear then
        return Event.onHear(self, speaker, words, type)
    end
    return true
end

function Creature:onChangeZone(fromZone, toZone)
    if hasEvent.onChangeZone then
        return Event.onChangeZone(self, fromZone, toZone)
    end
end

function Creature:onAddCondition(condition, isForced)
    if hasEvent.onAddCondition then
        return Event.onAddCondition(self, condition, isForced)
    end
    return RETURNVALUE_NOERROR
end
