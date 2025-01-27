-- Handler for applying imbuement (Opcode 0xD5)
local imbuingApplyHandler = PacketHandler(0xD5)

function imbuingApplyHandler.onReceive(self, msg)
    local slotId = msg:getByte()
    local imbuId = msg:getByte()
    msg:skipBytes(3) -- Skip the 3 extra bytes
    local luckProtection = msg:getByte() ~= 0

    print(string.format("Received Imbuement Apply: slotId=%d, imbuId=%d, luckProtection=%s", slotId, imbuId, tostring(luckProtection)))

    self:getPlayer():applyImbuement(slotId, imbuId, luckProtection)
end

imbuingApplyHandler:register()


-- Handler for toggling the imbuement panel (Opcode 0x60)
local imbuPanelHandler = PacketHandler(0x60)

function imbuPanelHandler.onReceive(self, msg)
    local enabled = msg:getByte() ~= 0x00

    print(string.format("Received Imbuement Panel Toggle: enabled=%s", tostring(enabled)))

    self:getPlayer():toggleImbuPanel(enabled)
end

imbuPanelHandler:register()


-- Handler for clearing an imbuement (Opcode 0xD6)
local imbuingClearHandler = PacketHandler(0xD6)

function imbuingClearHandler.onReceive(self, msg)
    local slotId = msg:getByte()

    print(string.format("Received Imbuement Clear: slotId=%d", slotId))

    self:getPlayer():clearImbuement(slotId)
end

imbuingClearHandler:register()


-- Handler for exiting the imbuement UI (Opcode 0xD7)
local imbuingExitHandler = PacketHandler(0xD7)

function imbuingExitHandler.onReceive(self, msg)
    print("Received Imbuement Exit")

    self:getPlayer():exitImbuement()
end

imbuingExitHandler:register()
