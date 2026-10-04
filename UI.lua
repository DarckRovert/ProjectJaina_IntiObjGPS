local M = IntiObjGPS
local function allowed() return GetRealmName() == M.realm end
local function chat(text) DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00[Inti GPS]|r " .. text) end

local frame = CreateFrame("Frame", "IntiObjGPSWindow", UIParent)
frame:SetSize(660, 580)
frame:SetPoint("CENTER")
frame:SetFrameStrata("DIALOG")
frame:SetMovable(true)
frame:SetClampedToScreen(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32,
    edgeSize = 32, insets = { left = 10, right = 10, top = 10, bottom = 10 } })
frame:Hide()
UISpecialFrames[#UISpecialFrames + 1] = "IntiObjGPSWindow"

local function label(text, y, font)
    local f = frame:CreateFontString(nil, "OVERLAY", font or "GameFontHighlightSmall")
    f:SetPoint("TOPLEFT", 22, y)
    f:SetWidth(610)
    f:SetJustifyH("LEFT")
    f:SetText(text)
    return f
end
label("Inti | Objetos por GPS", -22, "GameFontNormalLarge")
label("Una linea por objeto: .objgps ENTRY MAPA X Y Z O ESCALA", -52)
label("Max. 200 | GM 3 | tu mapa, mundo abierto | hasta 500 yardas | escala absoluta | confirmacion por objeto", -72)

local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", -5, -5)
close:SetScript("OnClick", function() frame:Hide() end)

local scroll = CreateFrame("ScrollFrame", "IntiObjGPSInputScroll", frame, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", 24, -100)
scroll:SetSize(588, 255)
local edit = CreateFrame("EditBox", "IntiObjGPSInput", scroll)
edit:SetMultiLine(true)
edit:SetAutoFocus(false)
edit:SetFontObject(ChatFontNormal)
edit:SetWidth(580)
edit:SetHeight(255)
edit:SetMaxLetters(M.maxLetters)
edit:SetTextInsets(5, 5, 5, 5)
edit:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
edit:SetScript("OnCursorChanged", function(_, _, y, _, height)
    local top, bottom = scroll:GetVerticalScroll(), scroll:GetVerticalScroll() + scroll:GetHeight()
    y = -y
    if y < top then scroll:SetVerticalScroll(math.max(0, y))
    elseif y + height > bottom then scroll:SetVerticalScroll(y + height - scroll:GetHeight()) end
end)
scroll:SetScrollChild(edit)
scroll:SetScript("OnMouseDown", function() edit:SetFocus() end)

local status = label("Pega tus lineas y pulsa Validar. Todavia no se creara ningun objeto.", -370)
status:SetHeight(42)
local progress = label("", -415)
label("Ejecutar guarda en la DB de Inti. Detener NO borra los objetos ya creados.", -507)
label("Puedes cerrar la ventana durante Ejecutar; usa Detener si quieres cortar el lote.", -530)

local function button(text, x, width)
    local b = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    b:SetPoint("TOPLEFT", x, -459)
    b:SetSize(width, 28)
    b:SetText(text)
    return b
end
local validate, run, cancel, history = button("Validar", 24, 125), button("Ejecutar", 160, 125),
    button("Detener", 296, 125), button("Registro", 432, 175)
run:Disable()
cancel:Disable()

local logFrame = CreateFrame("Frame", "IntiObjGPSLogWindow", UIParent)
logFrame:SetSize(700, 380)
logFrame:SetPoint("CENTER")
logFrame:SetFrameStrata("FULLSCREEN_DIALOG")
logFrame:SetBackdrop(frame:GetBackdrop())
logFrame:EnableMouse(true)
logFrame:Hide()
UISpecialFrames[#UISpecialFrames + 1] = "IntiObjGPSLogWindow"
local logClose = CreateFrame("Button", nil, logFrame, "UIPanelCloseButton")
logClose:SetPoint("TOPRIGHT", -5, -5)
local logTitle = logFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
logTitle:SetPoint("TOPLEFT", 24, -20)
logTitle:SetText("Registro GPS | Ctrl+A, Ctrl+C para copiar")
local logScroll = CreateFrame("ScrollFrame", "IntiObjGPSLogScroll", logFrame, "UIPanelScrollFrameTemplate")
logScroll:SetPoint("TOPLEFT", 24, -55)
logScroll:SetSize(625, 295)
local logEdit = CreateFrame("EditBox", nil, logScroll)
logEdit:SetMultiLine(true)
logEdit:SetAutoFocus(false)
logEdit:SetFontObject(ChatFontNormal)
logEdit:SetSize(615, 295)
logEdit:SetScript("OnEscapePressed", function(self) self:ClearFocus(); logFrame:Hide() end)
logScroll:SetScrollChild(logEdit)
logClose:SetScript("OnClick", function() logFrame:Hide() end)

local e
local function record(text)
    IntiObjGPSHistory = IntiObjGPSHistory or {}
    IntiObjGPSHistory[#IntiObjGPSHistory + 1] = date("%Y-%m-%d %H:%M:%S") .. " " .. UnitName("player") .. " " .. text
    while #IntiObjGPSHistory > 2000 do table.remove(IntiObjGPSHistory, 1) end
end
local function notify(state, text)
    if state == "placed" then
        record(text)
        chat(text)
        progress:SetText("Creados: " .. e.done .. " / " .. #e.rows)
        return
    end
    status:SetText(text)
    if e and allowed() then
        if state == "uploading" or state == "starting" or state == "running" or state == "ready" or state == "stopping" then
            IntiObjGPSPending = { token = e.token, owner = UnitName("player"), realm = M.realm }
        elseif state == "done" or state == "stopped" then IntiObjGPSPending = nil end
    end
    local busy = state == "uploading" or state == "starting" or state == "running" or state == "stopping"
    if busy then validate:Disable() else validate:Enable() end
    if state == "ready" then run:Enable() else run:Disable() end
    if busy or state == "ready" then cancel:Enable() else cancel:Disable() end
    if state == "uploading" then progress:SetText("Sin objetos creados. Validacion completa antes de ejecutar.") end
    if state == "error" or state == "done" or state == "stopped" then record(text); chat(text) end
end
e = M.New(function(command) SendChatMessage(command, "SAY") end, GetTime, notify, allowed)
edit:SetScript("OnTextChanged", function(self, userInput)
    if userInput then IntiObjGPSDraft = self:GetText(); e:Changed() end
end)
validate:SetScript("OnClick", function()
    edit:ClearFocus()
    e:Validate(edit:GetText(), time() .. "_" .. math.floor(GetTime() * 1000))
end)

StaticPopupDialogs["INTIGPS_RUN_CONFIRM"] = {
    text = "Crear %d objetos PERMANENTES en Inti?\nCada objeto se crea y se verifica antes de continuar. Detener no borra lo ya creado.",
    button1 = "Ejecutar", button2 = "Cancelar", timeout = 0, whileDead = true, hideOnEscape = true,
    OnAccept = function() e:Run(edit:GetText()) end
}
run:SetScript("OnClick", function()
    if e.state == "ready" then edit:ClearFocus(); StaticPopup_Show("INTIGPS_RUN_CONFIRM", #e.rows) end
end)
cancel:SetScript("OnClick", function() e:Cancel() end)
history:SetScript("OnClick", function()
    logEdit:SetText(table.concat(IntiObjGPSHistory or {}, "\n"))
    logEdit:SetCursorPosition(0)
    logScroll:SetVerticalScroll(0)
    logFrame:Show()
end)
frame:SetScript("OnHide", function()
    StaticPopup_Hide("INTIGPS_RUN_CONFIRM")
    edit:ClearFocus()
    if e.state == "uploading" or e.state == "ready" or e.state == "starting" then e:Cancel() end
end)

-- Listener stays active when the window is hidden, to receive cancellation/results.
local listener = CreateFrame("Frame")
listener:RegisterEvent("ADDON_LOADED")
listener:RegisterEvent("CHAT_MSG_ADDON")
listener:RegisterEvent("PLAYER_ENTERING_WORLD")
listener:SetScript("OnEvent", function(_, event, prefix, message, channel, sender)
    if event == "ADDON_LOADED" then
        if prefix == "IntiObjGPS" and type(IntiObjGPSDraft) == "string" then edit:SetText(IntiObjGPSDraft:sub(1, M.maxLetters)) end
        return
    end
    if event == "PLAYER_ENTERING_WORLD" then
        if not allowed() then frame:Hide(); logFrame:Hide() end
        -- On UI reload, cancel the previous token, never resume/run it.
        local pending = IntiObjGPSPending
        if allowed() and not e.token and type(pending) == "table" and pending.realm == M.realm and
            pending.owner == UnitName("player") and type(pending.token) == "string" and
            #pending.token <= 32 and pending.token:match("^[%w_]+$") then
            e.token = pending.token
            e:Cancel()
        end
        return
    end
    -- Server replies are whispers attributed to the receiving player, not other GMs.
    if prefix == M.prefix and channel == "WHISPER" and sender and
        sender:match("^[^-]+") == UnitName("player") then e:Receive(message) end
end)
listener:SetScript("OnUpdate", function() e:Update() end)
SLASH_INTIOBJGPS1 = "/objgps"
SlashCmdList["INTIOBJGPS"] = function()
    if not allowed() then chat("Solo disponible en Inti (Pruebas)."); return end
    if frame:IsShown() then frame:Hide() else frame:Show() end
end
