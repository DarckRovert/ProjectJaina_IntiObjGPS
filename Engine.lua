-- WoW 3.3.5 / Lua 5.1. No loadstring, RunScript or arbitrary GM commands.
ProjectJaina_IntiObjGPS = { prefix = "INTIGPS1", realm = "Inti (Pruebas)", maxObjects = 200, maxLetters = 40000 }
local M = ProjectJaina_IntiObjGPS
local SCALE_MIN, SCALE_MAX = 0.01, 50

local function valid(s, integer, min, max)
    local n = tonumber(s)
    return n and n == n and n >= min and n <= max and (not integer or n == math.floor(n))
end

function M.Parse(text)
    if #text > M.maxLetters then return nil, "Texto demasiado largo (maximo " .. M.maxLetters .. " caracteres)." end
    local rows, words, lineByWord, line, lastPos = {}, {}, {}, 1, 1
    for start, token in text:gmatch("()(%S+)") do
        local _, breaks = text:sub(lastPos, start - 1):gsub("\n", "")
        line = line + breaks
        words[#words + 1] = token
        lineByWord[#lineByWord + 1] = line
        lastPos = start + #token
    end
    local i = 1
    while i <= #words do
        if words[i] ~= ".objgps" then
            return nil, "Linea " .. (lineByWord[i] or line) .. ": usa .objgps ENTRY MAPA X Y Z O ESCALA."
        end
        local start, nextCommand = i, nil
        for j = i + 1, math.min(#words, i + 9) do
            if words[j] == ".objgps" then nextCommand = j; break end
        end
        local stop = nextCommand and (nextCommand - 1) or math.min(#words, i + 8)
        local count = stop - start + 1
        if count ~= 8 then
            return nil, "Linea " .. (lineByWord[start] or line) .. ": usa .objgps ENTRY MAPA X Y Z O ESCALA."
        end
        local a = {}
        for j = start, stop do a[#a + 1] = words[j] end
        if not (valid(a[2], true, 1, 4294967295) and valid(a[3], true, 0, 65535) and
            valid(a[4], false, -17066, 17066) and valid(a[5], false, -17066, 17066) and
            valid(a[6], false, -17066, 17066) and valid(a[7], false, -100000, 100000) and
            valid(a[8], false, SCALE_MIN, SCALE_MAX)) then
            return nil, "Linea " .. (lineByWord[start] or line) .. ": numero invalido. Usa punto decimal; escala entre 0.01 y 50."
        end
        local data = table.concat(a, " ", 2)
        if #data > 220 then return nil, "Linea " .. (lineByWord[start] or line) .. " demasiado larga." end
        rows[#rows + 1] = { data = data, source = lineByWord[start] or line }
        if #rows > M.maxObjects then return nil, "Maximo " .. M.maxObjects .. " objetos por lote." end
        i = stop + 1
    end
    if #rows == 0 then return nil, "Pega al menos una linea .objgps." end
    return rows
end

-- Stop-and-wait upload: at most one command outstanding, no automatic retry.
function M.New(send, clock, notify, allowed)
    local e = { state = "idle", done = 0, serial = 0 }
    function e:Status(state, message)
        self.state = state
        notify(state, message)
    end
    function e:Transmit(op)
        if not allowed() then self:Status("error", "Solo funciona conectado a Inti (Pruebas)."); return false end
        self.deadline = clock() + 15
        send(".objgpsbatch " .. self.token .. " " .. op)
        return true
    end
    function e:Validate(text, seed)
        if self.state == "uploading" or self.state == "running" or self.state == "starting" or self.state == "stopping" then return end
        local rows, err = M.Parse(text)
        if not rows then self:Status("error", err); return end
        if not allowed() then self:Status("error", "Solo funciona conectado a Inti (Pruebas)."); return end
        self.serial = self.serial + 1
        self.token = tostring(seed) .. "_" .. self.serial
        self.rows, self.source, self.index, self.done = rows, text, 0, 0
        self:Status("uploading", "Validando " .. #rows .. " objetos en Inti; no se crea nada...")
        self:Transmit("begin " .. #rows)
    end
    function e:NextRow()
        self.index = self.index + 1
        self:Transmit("row " .. self.index .. " " .. self.rows[self.index].data)
    end
    function e:Receive(message)
        local token, kind, detail = message:match("^([^|]+)|([^|]+)|(.*)$")
        if token ~= self.token or not allowed() then return end
        if kind == "ERROR" then
            self.nextSend, self.deadline = nil, nil
            self:Status("error", detail)
        elseif kind == "STOP" then
            self.nextSend, self.deadline = nil, nil
            self:Status("stopped", detail)
        elseif self.state == "uploading" then
            if kind == "BEGIN" and self.index == 0 and tonumber(detail) == #self.rows then
                self.deadline, self.nextSend = nil, clock() + 0.5
            elseif kind == "ROW" and tonumber(detail) == self.index and self.index < #self.rows then
                self.deadline, self.nextSend = nil, clock() + 0.5
            elseif kind == "READY" and self.index == #self.rows and tonumber(detail) == #self.rows then
                self.deadline, self.readyUntil = nil, clock() + 170
                self:Status("ready", #self.rows .. " objetos validados. Ejecutar los guardara permanentemente.")
            end
        elseif kind == "RUNNING" and self.state == "starting" then
            self.deadline = clock() + 15
            self:Status("running", "Creando y verificando cada objeto...")
        elseif kind == "PLACED" and (self.state == "running" or self.state == "stopping") then
            local row, guid, entry, scale = detail:match("^(%d+) (%d+) (%d+) ([%d%.%-]+)$")
            row = tonumber(row)
            if row and self.rows and self.rows[row] and row == self.done + 1 then
                self.done, self.deadline = row, clock() + 15
                notify("placed", "Linea " .. self.rows[row].source .. ": entry " .. entry .. ", GUID " .. guid ..
                    ", escala " .. scale .. " | .gobject delete " .. guid)
            end
        elseif kind == "DONE" and (self.state == "running" or self.state == "stopping") then
            self.deadline = nil
            self:Status("done", detail .. " objetos guardados. No se ejecutara otra vez este lote.")
        end
    end
    function e:Run(text)
        if self.state ~= "ready" then return end
        if text ~= self.source then self:Status("error", "El texto cambio. Vuelve a validar."); return end
        if clock() > self.readyUntil then self:Status("error", "La validacion vencio. Valida otra vez."); return end
        self:Status("starting", "Enviando ejecucion a Inti...")
        self:Transmit("run")
    end
    function e:Cancel()
        if not self.token then return end
        self.nextSend = nil
        self:Status("stopping", "Solicitando detener; los objetos ya creados permanecen.")
        self:Transmit("cancel")
    end
    function e:Changed()
        if self.state == "ready" or self.state == "uploading" or self.state == "starting" or self.state == "running" then self:Cancel() end
    end
    function e:Update()
        if self.nextSend and clock() >= self.nextSend then
            self.nextSend = nil
            self:NextRow()
        elseif self.deadline and clock() > self.deadline then
            self.deadline = nil
            if self.state == "running" or self.state == "starting" then
                self:Cancel()
            else
                self:Status("error", "Sin respuesta del Lua de Inti. No se reintenta. Revisa el registro antes de repetir.")
            end
        elseif self.state == "ready" and clock() > self.readyUntil then
            self:Status("error", "Validacion vencida; vuelve a validar.")
        end
    end
    return e
end
