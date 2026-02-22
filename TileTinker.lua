


-- ▀▀█▀▀ ▀█▀ ▒█░░░ ▒█▀▀▀ ▀▀█▀▀ ▀█▀ ▒█▄░▒█ ▒█░▄▀ ▒█▀▀▀ ▒█▀▀█ --
-- ░▒█░░ ▒█░ ▒█░░░ ▒█▀▀▀ ░▒█░░ ▒█░ ▒█▒█▒█ ▒█▀▄░ ▒█▀▀▀ ▒█▄▄▀ --
-- ░▒█░░ ▄█▄ ▒█▄▄█ ▒█▄▄▄ ░▒█░░ ▄█▄ ▒█░░▀█ ▒█░▒█ ▒█▄▄▄ ▒█░▒█ --

-- Autor: Norte (Discord: norte.m2) (X.com/norte_m2)






-- ===============================
-- ========== VARIABLES ==========
-- ===============================

-- Variables globales para los datos del objeto seleccionado
tileGUID               = nil
tileGUIDAnterior       = nil
tileEntryID            = nil
tileFileName           = nil
tileFileDataID         = nil
tilePosX               = nil
tilePosY               = nil
tilePosZ               = nil
tileOrientation        = nil
tileRotateX            = nil
tileRotateY            = nil
tileRotateZ            = nil
tileHasTint            = nil
tileColorR             = nil
tileColorG             = nil
tileColorB             = nil
tileColorA             = nil
tileSpellVisualID      = nil
tileScale              = nil
tileGroupLeaderGUID    = nil
tileObjectType         = nil
tileSaturation         = nil
tileGUIDLow            = nil
tileGUIDHigh           = nil
tileIsEditable         = nil


-- ===============================
-- ========== OBTENER DATOS ==========
-- ===============================

local function actualizarDatosTile()
    if not OPLastSelectedObjectData then
        print("No hay objeto seleccionado.")
        return
    end

    local data = OPLastSelectedObjectData

    tileGUID             = data[1]
    tileEntryID          = data[2]
    tileFileName         = data[3]
    tileFileDataID       = data[4]
    tilePosX             = data[5]
    tilePosY             = data[6]
    tilePosZ             = data[7]
    tileOrientation      = data[8]
    tileRotateX          = data[9]
    tileRotateY          = data[10]
    tileRotateZ          = data[11]
    tileScale            = data[18]
    tileGroupLeaderGUID  = data[19]
    tileObjectType       = data[20]
    tileGUIDLow          = data[22]
    tileGUIDHigh         = data[23]
	
end


-- Slash command opcional para ejecutarlo manualmente si quieres
SLASH_ACTUALIZARTILE1 = "/actualizartile"
SlashCmdList["ACTUALIZARTILE"] = function()
    actualizarDatosTile()
end



-- Comando para imprimir los datos del tile
SLASH_VERDATATILE1 = "/verdatatile"
SlashCmdList["VERDATATILE"] = function()
    if not OPLastSelectedObjectData then
        print("No hay objeto seleccionado.")
        return
    end

    -- Actualizamos los datos antes de imprimirlos
    actualizarDatosTile()

    -- Imprimir las variables actualizadas
    print("---- Datos del Tile ----")
    print("tileGUID:", tileGUID)
    print("tileEntryID:", tileEntryID)
    print("tileFileName:", tileFileName)
    print("tileFileDataID:", tileFileDataID)
    print("tilePosX:", tilePosX)
    print("tilePosY:", tilePosY)
    print("tilePosZ:", tilePosZ)
    print("tileOrientation:", tileOrientation)
    print("tileRotateX:", tileRotateX)
    print("tileRotateY:", tileRotateY)
    print("tileRotateZ:", tileRotateZ)
    print("tileScale:", tileScale)
    print("tileGroupLeaderGUID:", tileGroupLeaderGUID)
    print("tileObjectType:", tileObjectType)
    print("tileGUIDLow:", tileGUIDLow)
    print("tileGUIDHigh:", tileGUIDHigh)
    print("-------------------------")
end


local listener = CreateFrame("Frame")
local tileScale = nil
local editabletileScale = 1


-- ===============================
-- ==== FUNCIONES AUXILIARES =====
-- ===============================


-- Eliminar códigos de color
local function limpiarColores(texto)
    texto = texto:gsub("%[/?color.-%]", "")
    texto = texto:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    return texto
end


-- Crear listener para eventos del sistema
local listener = CreateFrame("Frame")
listener:RegisterEvent("CHAT_MSG_SYSTEM")

listener:SetScript("OnEvent", function(self, event, msg)
    local limpio = limpiarColores(msg):lower()
    if limpio:find("gameobject") then
        actualizarDatosTile()
        actualizarVentanaTinker()
    end
end)



-- ===============================
-- ========== ESCUCHA ============
-- ===============================

-- DETECTOR DE SCALE
local function detectarScale(msg)
    local encontrado = false

    if string.find(msg, "Scale:") then
        local despuesDeScale = string.match(msg, "Scale:%s*(.+)")
        if despuesDeScale then
            local limpio = limpiarColores(despuesDeScale)
            local numero = string.match(limpio, "^(%-?%d+%.?%d*)")
            if numero then
                tileScale = tonumber(numero)
                editabletileScale = tileScale
                actualizarVentanaMain()
                actualizarVentanaTinker()
                encontrado = true
            end
        end
    end

    if not encontrado and string.find(msg, "scale") then
        local despuesDeScale = string.match(msg, "scale%s*(.+)")
        if despuesDeScale then
            local limpio = limpiarColores(despuesDeScale)
            local numero = string.match(limpio, "^(%-?%d+%.?%d*)")
            if numero then
                tileScale = tonumber(numero)
                editabletileScale = tileScale
                actualizarVentanaMain()
                actualizarVentanaTinker()
                encontrado = true
            end
        end
    end
end

local function DetectarSeleccion(msg)
    local limpioMsg = limpiarColores(msg)
    if string.find(limpioMsg, "Selected") then
        local guidExtraido = string.match(limpioMsg, "GUID:%s*%(?(%-?%d+%.?%d*)%)?")
        if guidExtraido then
			tileGUIDAnterior = tileNuevoGUID
            tileNuevoGUID = tonumber(guidExtraido)
        end
    end
end

-- ESCUCHA CHAT
listener:RegisterEvent("CHAT_MSG_SYSTEM")
listener:SetScript("OnEvent", function(_, _, msg)
    detectarScale(msg)
	DetectarSeleccion(msg)
end)



-- ===============================
-- ========== FRAME TOP (OCULTO) =
-- ===============================

local scaleFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
scaleFrame:SetSize(200, 50)
scaleFrame:SetPoint("TOP", UIParent, "TOP", 0, -100)
scaleFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
scaleFrame:Hide() -- Ocultamos el frame visualmente

local scaleText = scaleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
scaleText:SetPoint("CENTER")
scaleText:SetText("SCALE: ---")

function actualizarVentanaMain()
    if editabletileScale then
        scaleText:SetText("SCALE: " .. editabletileScale)
    else
        scaleText:SetText("SCALE: ---")
    end
end

-- ===============================
-- ========== TILETINKER =========
-- ===============================

local tinkerWindow = CreateFrame("Frame", "TileTinkerWindow", UIParent, "BackdropTemplate")
tinkerWindow:SetSize(400, 350)
TileTinkerWindow:SetPoint("RIGHT", UIParent, "RIGHT", 100, 0)
tinkerWindow:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
tinkerWindow:EnableMouse(true)
tinkerWindow:SetMovable(true)
tinkerWindow:RegisterForDrag("LeftButton")
tinkerWindow:SetScript("OnDragStart", tinkerWindow.StartMoving)
tinkerWindow:SetScript("OnDragStop", tinkerWindow.StopMovingOrSizing)

-- Botón de cerrar (X)
local closeButton = CreateFrame("Button", nil, tinkerWindow, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", -5, -5)

-- Tótulo (amarillo)
local title = tinkerWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -20)
title:SetText("TileTinker")

tinkerWindow:Hide()





-- ===========================================================
-- ========== ABRIR CON COMANDO LA VENTANA PRINCIPAL =========
-- ===========================================================

SLASH_TILETINKER1 = "/tiletinker"
SLASH_TILETINKER2 = "/tiles"
SlashCmdList["TILETINKER"] = function()
    if tinkerWindow:IsShown() then
        tinkerWindow:Hide()
    else
        tinkerWindow:Show()
    end
end



-- ==========================================
-- ==========================================

-- ==========================================
-- ==========================================

-- ESCALAR


-- ==========================================
-- ==========================================

-- ==========================================
-- ==========================================






-- =======================================
-- ==========   SUBVENTANA ESCALA   ======
-- =======================================

-- Submarco contenedor para "Escala" con borde gris
local scaleSubFrame = CreateFrame("Frame", nil, tinkerWindow, "BackdropTemplate")
scaleSubFrame:SetSize(360, 50)
scaleSubFrame:SetPoint("TOP", tinkerWindow, "TOP", 0, -45)
scaleSubFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
scaleSubFrame:SetBackdropBorderColor(0.5, 0.5, 0.5) -- Gris medio
scaleSubFrame:SetBackdropColor(1, 1, 1, 0.8)  -- Blanco con opacidad 80%

-- Texto "Escala:"
local escalaLabel = scaleSubFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
escalaLabel:SetPoint("LEFT", scaleSubFrame, "LEFT", 10, 0)
escalaLabel:SetText("Escala:")

-- Casilla para introducir escala
local scaleInput = CreateFrame("EditBox", nil, scaleSubFrame, "InputBoxTemplate")
scaleInput:SetSize(40, 30)
scaleInput:SetPoint("LEFT", escalaLabel, "RIGHT", 10, 0)
scaleInput:SetAutoFocus(false)
scaleInput:SetText(tostring(tileScale))

scaleInput:SetScript("OnEnterPressed", function(self)
    local newValue = tonumber(self:GetText())
    if newValue then
        editabletileScale = newValue
        SendChatMessage(".gob scale " .. editabletileScale, "SAY")
        actualizarVentanaMain()
        actualizarVentanaTinker()
        self:ClearFocus()
    else
        print("Introduce un nómero vólido.")
    end
end)

function actualizarVentanaTinker()
    if tileScale then
        scaleInput:SetText(tostring(tileScale))
    else
        scaleInput:SetText("")
    end
end

---------------------- BOTONES ESCALA


-- Botón X2
local scaleButton = CreateFrame("Button", nil, scaleSubFrame, "UIPanelButtonTemplate")
scaleButton:SetSize(40, 30)
scaleButton:SetPoint("LEFT", scaleInput, "RIGHT", 5, 0)  -- Lo coloca justo al lado de la casilla de texto
scaleButton:SetText("x2")

-- Cambiar el color del texto a blanco
scaleButton:GetFontString():SetTextColor(1, 1, 1)  -- Blanco (RGB: 1, 1, 1)

-- Función que se ejecuta cuando se hace clic en el botón
scaleButton:SetScript("OnClick", function()
    -- Multiplicamos tileScale por 2 y enviamos el mensaje
    local newScale = tileScale * 2
    SendChatMessage(".gob scale " .. newScale, "SAY")
end)

-- Botón /2
local scaleButton2 = CreateFrame("Button", nil, scaleSubFrame, "UIPanelButtonTemplate")
scaleButton2:SetSize(40, 30)
scaleButton2:SetPoint("LEFT", scaleButton, "RIGHT", 0.5, 0)  -- Lo coloca justo al lado del primer botón
scaleButton2:SetText("1/2")

-- Cambiar el color del texto a blanco
scaleButton2:GetFontString():SetTextColor(1, 1, 1)  -- Blanco (RGB: 1, 1, 1)

-- Función que se ejecuta cuando se hace clic en el botón
scaleButton2:SetScript("OnClick", function()
    -- Dividimos tileScale entre 2 y enviamos el mensaje
    local newScale = tileScale / 2
    SendChatMessage(".gob scale " .. newScale, "SAY")
end)

-- Botón 0.25
local scaleButton25 = CreateFrame("Button", nil, scaleSubFrame, "UIPanelButtonTemplate")
scaleButton25:SetSize(40, 30)
scaleButton25:SetPoint("LEFT", scaleButton2, "RIGHT", 2, 0) 
scaleButton25:SetText("0.25")

scaleButton25:SetScript("OnClick", function()
    SendChatMessage(".gob scale 0.25", "SAY")
end)

-- Botón 0.5
local scaleButton5 = CreateFrame("Button", nil, scaleSubFrame, "UIPanelButtonTemplate")
scaleButton5:SetSize(40, 30)
scaleButton5:SetPoint("LEFT", scaleButton25, "RIGHT", 0.5, 0) 
scaleButton5:SetText("0.5")

scaleButton5:SetScript("OnClick", function()
    SendChatMessage(".gob scale 0.5", "SAY")
end)

-- Botón 1
local scaleButton1 = CreateFrame("Button", nil, scaleSubFrame, "UIPanelButtonTemplate")
scaleButton1:SetSize(40, 30)
scaleButton1:SetPoint("LEFT", scaleButton5, "RIGHT", 0.5, 0) 
scaleButton1:SetText("1")

scaleButton1:SetScript("OnClick", function()
    SendChatMessage(".gob scale 1", "SAY")
end)

-- Botón 2
local scaleButton02 = CreateFrame("Button", nil, scaleSubFrame, "UIPanelButtonTemplate")
scaleButton02:SetSize(40, 30)
scaleButton02:SetPoint("LEFT", scaleButton1, "RIGHT", 0.5, 0) 
scaleButton02:SetText("2")

scaleButton02:SetScript("OnClick", function()
    SendChatMessage(".gob scale 2", "SAY")
end)

-- ===============================
-- ===============================
-- ===============================


-- Inicializar
actualizarVentanaMain()
actualizarVentanaTinker()




-- ==========================================
-- ==========================================

-- ==========================================
-- ==========================================

-- MOVER


-- ==========================================
-- ==========================================

-- ==========================================
-- ==========================================







-- ==========================================
-- ==========   SUBVENTANA MOVER    =========
-- ==========================================

-- Subventana: MoverTileVentana
local moverTileVentana = CreateFrame("Frame", "MoverTileVentana", tinkerWindow, "BackdropTemplate")
moverTileVentana:SetSize(175, 160)
moverTileVentana:SetPoint("TOPLEFT", scaleSubFrame, "BOTTOMLEFT", 0, -10)
moverTileVentana:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
moverTileVentana:SetBackdropBorderColor(0.5, 0.5, 0.5) -- Gris medio
moverTileVentana:SetBackdropColor(1, 1, 1, 0.8) -- Opacidad a juego

-- Variable global de distancia
DistanciaMover = 1  -- Puedes cambiar este valor dinómicamente luego

-- Título "Mover Tile"
local moverTitle = moverTileVentana:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
moverTitle:SetPoint("TOP", 0, -5)
moverTitle:SetText("Mover Tile")

-- CASILLA DE DISTANCIA

-- Texto "Dist:"
local distLabel = moverTileVentana:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
distLabel:SetPoint("LEFT", moverTileVentana, "LEFT", 12, -25)
distLabel:SetText("Dist:")

-- Casilla para introducir distancia
local distInput = CreateFrame("EditBox", nil, moverTileVentana, "InputBoxTemplate")
distInput:SetSize(50, 30)
distInput:SetPoint("LEFT", distLabel, "RIGHT", 10, 0)
distInput:SetAutoFocus(false)
distInput:SetText(tostring(DistanciaMover))  -- Coloca el valor actual de DistanciaMover en el campo

distInput:SetScript("OnEnterPressed", function(self)
    local newValue = tonumber(self:GetText())  -- Obtiene el valor introducido
    if newValue then
        DistanciaMover = newValue  -- Actualiza la variable DistanciaMover con el nuevo valor
        actualizarVentanaDist()  -- Actualiza la ventana con el nuevo valor
        self:ClearFocus()  -- Elimina el enfoque del campo de texto
    else
        print("Introduce un nómero vólido.")  -- Muestra un mensaje si no es un nómero vólido
    end
end)

function actualizarVentanaDist()
    if DistanciaMover then
        distInput:SetText(tostring(DistanciaMover))  -- Actualiza el campo con el valor actual de DistanciaMover
    else
        distInput:SetText("")  -- Deja el campo vacóo si la distancia es nil
    end
end






-- BOTONES DISTANCIA

-- Botón X2
local distX2 = CreateFrame("Button", nil, scaleSubFrame, "UIPanelButtonTemplate")
distX2:SetSize(30, 20)
distX2:SetPoint("LEFT", distInput, "RIGHT", 5, 0)  -- Lo coloca justo al lado de la casilla de texto
distX2:SetText("x2")

-- Cambiar el color del texto a blanco
distX2:GetFontString():SetTextColor(1, 1, 1)  -- Blanco (RGB: 1, 1, 1)

-- Función que se ejecuta cuando se hace clic en el botón
distX2:SetScript("OnClick", function()
    -- Multiplicamos DistanciaMover por 2 y actualizamos la variable
    DistanciaMover = DistanciaMover * 2
    actualizarVentanaDist()  -- Actualiza la ventana con el nuevo valor
end)

-- Botón 1/2
local distEntre2 = CreateFrame("Button", nil, scaleSubFrame, "UIPanelButtonTemplate")
distEntre2:SetSize(30, 20)
distEntre2:SetPoint("LEFT", distX2, "RIGHT", 0.5, 0)  -- Lo coloca justo al lado del primer botón
distEntre2:SetText("1/2")

-- Cambiar el color del texto a blanco
distEntre2:GetFontString():SetTextColor(1, 1, 1)  -- Blanco (RGB: 1, 1, 1)

-- Función que se ejecuta cuando se hace clic en el botón
distEntre2:SetScript("OnClick", function()
    -- Dividimos DistanciaMover entre 2 y actualizamos la variable
    DistanciaMover = DistanciaMover / 2
    actualizarVentanaDist()  -- Actualiza la ventana con el nuevo valor
end)



-- BOTONES DEBAJO CASILLA DISTANCIA 


-- Botón 1 BORDE
local distBoton1 = CreateFrame("Button", nil, moverTileVentana, "UIPanelButtonTemplate")
distBoton1:SetSize(70, 25) 
distBoton1:SetPoint("TOP", distInput, "BOTTOM", 0, -1)  
distBoton1:SetText("1 Borde")

-- Reducir el tamaóo del texto
distBoton1:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 10)  -- Cambia el tamaóo del texto

distBoton1:SetScript("OnClick", function()
    DistanciaMover = tileScale * 0.25
    actualizarVentanaDist()  -- Actualiza la ventana con el nuevo valor
end)

-- Botón 1 TILE
local distBoton2 = CreateFrame("Button", nil, moverTileVentana, "UIPanelButtonTemplate")
distBoton2:SetSize(55, 25)  -- Cambiar el tamaóo del botón
distBoton2:SetPoint("LEFT", distBoton1, "RIGHT", 0.5, 0)  -- Lo coloca justo al lado del primer botón
distBoton2:SetText("1 Tile")

-- Reducir el tamaóo del texto
distBoton2:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 10)  -- Cambia el tamaóo del texto

distBoton2:SetScript("OnClick", function()
    -- Asignamos a DistanciaMover el valor de tileScale multiplicado por 4
    DistanciaMover = tileScale * 4
    actualizarVentanaDist()  -- Actualiza la ventana con el nuevo valor
end)

-- Botón RESET
local distBoton3 = CreateFrame("Button", nil, moverTileVentana, "UIPanelButtonTemplate")
distBoton3:SetSize(25, 25)  -- Cambiar el tamaóo del botón
distBoton3:SetPoint("TOP", distLabel, "BOTTOM", 0, -10)  
distBoton3:SetText("1")

-- Reducir el tamaóo del texto
distBoton3:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 10)  -- Cambia el tamaóo del texto
-- Cambiar el color del texto a blanco
distBoton3:GetFontString():SetTextColor(1, 1, 1)  -- Blanco (RGB: 1, 1, 1)

distBoton3:SetScript("OnClick", function()
    DistanciaMover = 1
    actualizarVentanaDist()  -- Actualiza la ventana con el nuevo valor
end)


-- BOTONES MOVER

-- Botón F (Forward)
local btnF = CreateFrame("Button", nil, moverTileVentana, "UIPanelButtonTemplate")
btnF:SetSize(50, 30)
btnF:SetPoint("TOP", moverTileVentana, "TOP", 0, -30)
btnF:SetText("F")
btnF:SetScript("OnClick", function()
    SendChatMessage(".gob move f " .. DistanciaMover, "SAY")
end)

-- Botón B (Back)
local btnB = CreateFrame("Button", nil, moverTileVentana, "UIPanelButtonTemplate")
btnB:SetSize(50, 30)
btnB:SetPoint("TOP", btnF, "BOTTOM", 0.5, 0)
btnB:SetText("B")
btnB:SetScript("OnClick", function()
    SendChatMessage(".gob move b " .. DistanciaMover, "SAY")
end)

-- Botón R (Right)
local btnR = CreateFrame("Button", nil, moverTileVentana, "UIPanelButtonTemplate")
btnR:SetSize(50, 30)
btnR:SetPoint("LEFT", btnB, "RIGHT", 1, 10)
btnR:SetText("R")
btnR:SetScript("OnClick", function()
    SendChatMessage(".gob move r " .. DistanciaMover, "SAY")
end)

-- Botón L (Left)
local btnL = CreateFrame("Button", nil, moverTileVentana, "UIPanelButtonTemplate")
btnL:SetSize(50, 30)
btnL:SetPoint("RIGHT", btnB, "LEFT", -1, 10)
btnL:SetText("L")
btnL:SetScript("OnClick", function()
    SendChatMessage(".gob move l " .. DistanciaMover, "SAY")
end)

-- Botón U (Up)
local btnU = CreateFrame("Button", nil, moverTileVentana, "UIPanelButtonTemplate")
btnU:SetSize(30, 30)
btnU:SetPoint("BOTTOM", btnL, "TOP", 1, 0)
btnU:SetText("U")
btnU:SetScript("OnClick", function()
    SendChatMessage(".gob move u " .. DistanciaMover, "SAY")
end)

-- Botón D (Down)
local btnD = CreateFrame("Button", nil, moverTileVentana, "UIPanelButtonTemplate")
btnD:SetSize(30, 30)
btnD:SetPoint("BOTTOM", btnR, "TOP", 1, 0)
btnD:SetText("D")
btnD:SetScript("OnClick", function()
    SendChatMessage(".gob move d " .. DistanciaMover, "SAY")
end)







-- ==========================================
-- ==========================================

-- ==========================================
-- ==========================================

-- FUNCION DE COPIAR


-- ==========================================
-- ==========================================

-- ==========================================
-- ==========================================







-- ==========================================
-- ===   DESPLEGABLE ES TILE O ES BORDE  ====
-- ==========================================

-- Desplegable en tinkerWindow
local DesplegableEsTileOEsBorde = CreateFrame("Frame", "DesplegableEsTileOEsBorde", tinkerWindow, "UIDropDownMenuTemplate")
DesplegableEsTileOEsBorde:SetPoint("CENTER", scaleSubFrame, "CENTER", 145, -44)  
UIDropDownMenu_SetWidth(DesplegableEsTileOEsBorde, 8)  -- Ancho ajustado del desplegable
UIDropDownMenu_SetText(DesplegableEsTileOEsBorde, "V")  -- Texto por defecto

-- Opciones disponibles
local opciones = {
    "Copiando un Tile",  -- Opción 1
    "Copiando un Borde", -- Opción 2
}

-- Variable para guardar la selección
local EsTileOEsBorde = 1  -- Por defecto "Copiando un Tile"

-- Función para inicializar el menó
UIDropDownMenu_Initialize(DesplegableEsTileOEsBorde, function(self, level)
    for i, opcion in ipairs(opciones) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = opcion
        info.func = function()
            UIDropDownMenu_SetText(DesplegableEsTileOEsBorde, opcion)
            if i == 1 then
                EsTileOEsBorde = 1  -- "Copiando un Tile"
            else
                EsTileOEsBorde = 2  -- "Copiando un Borde"
            end
        end
        -- Mostrar en amarillo si es la seleccionada
        if i == EsTileOEsBorde then
            info.checked = true
        else
            info.checked = false
        end
        info.keepShownOnClick = false  -- Ocultar el menó al seleccionar
        UIDropDownMenu_AddButton(info, level)
    end
end)


-- ==========================================
-- ==========   SUBVENTANA COPIAR   =========
-- ==========================================

-- Subventana: CopiarTileVentana
local copiarTileVentana = CreateFrame("Frame", "CopiarTileVentana", tinkerWindow, "BackdropTemplate")
copiarTileVentana:SetSize(175, 100)
copiarTileVentana:SetPoint("TOPLEFT", moverTileVentana, "TOPRIGHT", 10, 0)
copiarTileVentana:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
copiarTileVentana:SetBackdropBorderColor(0.5, 0.5, 0.5) -- Gris medio
copiarTileVentana:SetBackdropColor(1, 1, 1, 0.8) -- Opacidad a juego

-- Tótulo "Copiar Tile"
local copiarTitle = copiarTileVentana:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
copiarTitle:SetPoint("TOP", 0, -5)
copiarTitle:SetText("Copiar Tile")


-- BOTONES COPIAR

-- Botón F (Forward)
local BotonCopiarTileF = CreateFrame("Button", nil, copiarTileVentana, "UIPanelButtonTemplate")
BotonCopiarTileF:SetSize(50, 30)
BotonCopiarTileF:SetPoint("TOP", copiarTileVentana, "TOP", 0, -30)
BotonCopiarTileF:SetText("F")
BotonCopiarTileF:SetScript("OnClick", function()
    local factor = (EsTileOEsBorde == 2) and 0.25 or 4
    SendChatMessage(".gob copy f " .. (tileScale * factor), "SAY")
end)

-- Botón B (Back)
local BotonCopiarTileB = CreateFrame("Button", nil, copiarTileVentana, "UIPanelButtonTemplate")
BotonCopiarTileB:SetSize(50, 30)
BotonCopiarTileB:SetPoint("TOP", BotonCopiarTileF, "BOTTOM", 0.5, 0)
BotonCopiarTileB:SetText("B")
BotonCopiarTileB:SetScript("OnClick", function()
    local factor = (EsTileOEsBorde == 2) and 0.25 or 4
    SendChatMessage(".gob copy b " .. (tileScale * factor), "SAY")
end)

-- Botón R (Right)
local BotonCopiarTileR = CreateFrame("Button", nil, copiarTileVentana, "UIPanelButtonTemplate")
BotonCopiarTileR:SetSize(50, 30)
BotonCopiarTileR:SetPoint("LEFT", BotonCopiarTileB, "RIGHT", 1, 10)
BotonCopiarTileR:SetText("R")
BotonCopiarTileR:SetScript("OnClick", function()
    local factor = (EsTileOEsBorde == 2) and 0.25 or 4
    SendChatMessage(".gob copy r " .. (tileScale * factor), "SAY")
end)

-- Botón L (Left)
local BotonCopiarTileL = CreateFrame("Button", nil, copiarTileVentana, "UIPanelButtonTemplate")
BotonCopiarTileL:SetSize(50, 30)
BotonCopiarTileL:SetPoint("RIGHT", BotonCopiarTileB, "LEFT", -1, 10)
BotonCopiarTileL:SetText("L")
BotonCopiarTileL:SetScript("OnClick", function()
    local factor = (EsTileOEsBorde == 2) and 0.25 or 4
    SendChatMessage(".gob copy l " .. (tileScale * factor), "SAY")
end)

-- Botón U (Up)
local BotonCopiarTileU = CreateFrame("Button", nil, copiarTileVentana, "UIPanelButtonTemplate")
BotonCopiarTileU:SetSize(30, 30)
BotonCopiarTileU:SetPoint("BOTTOM", BotonCopiarTileL, "TOP", 1, 0)
BotonCopiarTileU:SetText("U")
BotonCopiarTileU:SetScript("OnClick", function()
    local factor = (EsTileOEsBorde == 2) and 0.25 or 4
    SendChatMessage(".gob copy u " .. (tileScale * factor), "SAY")
end)

-- Botón D (Down)
local BotonCopiarTileD = CreateFrame("Button", nil, copiarTileVentana, "UIPanelButtonTemplate")
BotonCopiarTileD:SetSize(30, 30)
BotonCopiarTileD:SetPoint("BOTTOM", BotonCopiarTileR, "TOP", 1, 0)
BotonCopiarTileD:SetText("D")
BotonCopiarTileD:SetScript("OnClick", function()
    local factor = (EsTileOEsBorde == 2) and 0.25 or 4
    SendChatMessage(".gob copy d " .. (tileScale * factor), "SAY")
end)





-- ==========================================
-- ==========================================


-- ==========================================
-- ===   SUBVENTANA COPIAR MANUALMENTE   ====
-- ==========================================

-- Subventana: Copiar Manual
local subVentanaCopiarManual = CreateFrame("Frame", "SubVentanaCopiarManual", copiarTileVentana, "BackdropTemplate")
subVentanaCopiarManual:SetSize(175, 57)
subVentanaCopiarManual:SetPoint("TOPLEFT", copiarTileVentana, "BOTTOMLEFT", 0, -2)
subVentanaCopiarManual:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
subVentanaCopiarManual:SetBackdropBorderColor(0.5, 0.5, 0.5)
subVentanaCopiarManual:SetBackdropColor(1, 1, 1, 0.8)

-- Tótulo de la subventana
local tituloCopiarManual = subVentanaCopiarManual:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
tituloCopiarManual:SetPoint("TOP", 0, -5)
tituloCopiarManual:SetText("Copiar Manualmente")

-- Desplegable a la izquierda
local DesplegableMoverManual = CreateFrame("Frame", "DesplegableMoverManual", subVentanaCopiarManual, "UIDropDownMenuTemplate")
DesplegableMoverManual:SetPoint("TOPLEFT", subVentanaCopiarManual, "TOPLEFT", -10, -25)
UIDropDownMenu_SetWidth(DesplegableMoverManual, 50)
UIDropDownMenu_SetText(DesplegableMoverManual, "Elige")

-- Opciones disponibles
local opciones = {
    "(U) Arriba",
    "(F) Frente",
    "(B) Atras",
    "(D) Abajo",
    "(L) Izquierda",
    "(R) Derecha",
}

-- Variables
local EjeDistMoverManual = nil  -- Guardaró el eje seleccionado
local NumDistMoverManual = 0    -- Guardaró el nómero de distancia

-- Función para inicializar el menó
UIDropDownMenu_Initialize(DesplegableMoverManual, function(self, level)
    for _, opcion in ipairs(opciones) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = opcion
        info.func = function()
            UIDropDownMenu_SetText(DesplegableMoverManual, opcion)
            -- Establecer el valor de la variable EjeDistMoverManual
            if opcion == "(U) Arriba" then
                EjeDistMoverManual = "u"
            elseif opcion == "(F) Frente" then
                EjeDistMoverManual = "f"
            elseif opcion == "(B) Atras" then
                EjeDistMoverManual = "b"
            elseif opcion == "(D) Abajo" then
                EjeDistMoverManual = "d"
            elseif opcion == "(L) Izquierda" then
                EjeDistMoverManual = "l"
            elseif opcion == "(R) Derecha" then
                EjeDistMoverManual = "r"
            end
        end
        info.checked = (opcion == "(U) Arriba" and EjeDistMoverManual == "u") or
                       (opcion == "(F) Frente" and EjeDistMoverManual == "f") or
                       (opcion == "(B) Atras" and EjeDistMoverManual == "b") or
                       (opcion == "(D) Abajo" and EjeDistMoverManual == "d") or
                       (opcion == "(L) Izquierda" and EjeDistMoverManual == "l") or
                       (opcion == "(R) Derecha" and EjeDistMoverManual == "r")
        info.keepShownOnClick = false
        UIDropDownMenu_AddButton(info, level)
    end
end)

-- Caja de texto (manual input)
local DistMoverManual = CreateFrame("EditBox", "DistMoverManual", subVentanaCopiarManual, "InputBoxTemplate")
DistMoverManual:SetSize(40, 20)
DistMoverManual:SetPoint("LEFT", DesplegableMoverManual, "RIGHT", -5, 3)
DistMoverManual:SetAutoFocus(false)
DistMoverManual:SetText("")  -- Inicia vacóo

-- Acción al presionar Enter en la caja de texto
DistMoverManual:SetScript("OnEnterPressed", function()
    -- Obtener el valor de la distancia
    NumDistMoverManual = tonumber(DistMoverManual:GetText()) or 0

    -- Enviar el mensaje al chat si se seleccionó una dirección y hay una distancia vólida
    if EjeDistMoverManual and NumDistMoverManual > 0 then
        SendChatMessage(".gob copy " .. EjeDistMoverManual .. " " .. NumDistMoverManual, "SAY")
        DistMoverManual:ClearFocus()  -- Quitar el enfoque de la caja de texto despuós de presionar Enter
    else
        print("Por favor, selecciona una distancia vólida.")
    end
end)


-- Botón aplicar
local BotonAplicarMoverManual = CreateFrame("Button", "BotonAplicarMoverManual", subVentanaCopiarManual, "UIPanelButtonTemplate")
BotonAplicarMoverManual:SetSize(40, 22)
BotonAplicarMoverManual:SetPoint("LEFT", DistMoverManual, "RIGHT", 5, 0)
BotonAplicarMoverManual:SetText("OK")

-- Acción del botón "OK"
BotonAplicarMoverManual:SetScript("OnClick", function()
    -- Obtener el valor de la distancia
    NumDistMoverManual = tonumber(DistMoverManual:GetText()) or 0

    -- Enviar el mensaje al chat
    if EjeDistMoverManual and NumDistMoverManual > 0 then
        SendChatMessage(".gob copy " .. EjeDistMoverManual .. " " .. NumDistMoverManual, "SAY")
    else
        print("Por favor, selecciona una dirección y una distancia vólida.")
    end
end)

-- ========================================== BOTON CLONAR

-- Botón para clonar tile
local ClonarTileBoton = CreateFrame("Button", nil, TileTinkerWindow, "UIPanelButtonTemplate")
ClonarTileBoton:SetSize(100, 20)
ClonarTileBoton:SetText("Clonar")
ClonarTileBoton:SetPoint("TOP", TileTinkerWindow, "TOP", 130, -268)

-- Acción al hacer clic
ClonarTileBoton:SetScript("OnClick", function()
    -- Enviar al chat el mensaje ".gob copy u 0"
    SendChatMessage(".gob copy u 0", "SAY")
end)




-- ==========================================
-- ==========================================

-- ==========================================
-- ==========================================

-- CAMBIO DE EJE


-- ==========================================
-- ==========================================

-- ==========================================
-- ==========================================



-- ==========================================
-- ==========================================
--            DE PARED A TECHO
-- ==========================================
-- ==========================================



-- ================================
-- ====== HACER ESQUINAS O TECHO VENTANAS Y BOTON ======
-- ================================

-- Altura base original de la ventana principal
local alturaBaseTinker = TileTinkerWindow:GetHeight()

-- === Ventana para Techo ===
local HacerTechoVentana = CreateFrame("Frame", "HacerTechoVentana", TileTinkerWindow, "BackdropTemplate")
HacerTechoVentana:SetSize(175, 114)
HacerTechoVentana:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
HacerTechoVentana:SetBackdropBorderColor(0.5, 0.5, 0.5)
HacerTechoVentana:SetBackdropColor(1, 1, 1, 0.8)
HacerTechoVentana:Hide()





-- ============================
-- === Crear Desplegable DE COPIAR DENTRO O FUERA ===
-- ============================

local CopiarDentroOFueraDesplegable = CreateFrame("Frame", "CopiarDentroOFueraDesplegable", HacerTechoVentana, "UIDropDownMenuTemplate")
CopiarDentroOFueraDesplegable:SetPoint("CENTER", HacerTechoVentana, "CENTER", 67, 69)
UIDropDownMenu_SetWidth(CopiarDentroOFueraDesplegable, 8)
UIDropDownMenu_SetText(CopiarDentroOFueraDesplegable, "V")

-- Opciones disponibles para el desplegable
local opcionesCopiarDentroOFuera = {
    "¿Cómo se colocará el nuevo Tile?",  -- i = 1 (no seleccionable)
    "Interseccion con la esquina",       -- i = 2 → valor = 2
    "Dentro de la esquina",              -- i = 3 → valor = 3
    "Fuera de la esquina",               -- i = 4 → valor = 4
}

-- Variable para guardar la selección
local CopiarDentroOFueraVariable = 2  -- Por defecto: Interseccion con la esquina

-- Función para inicializar el menú del desplegable
UIDropDownMenu_Initialize(CopiarDentroOFueraDesplegable, function(self, level)
    for i, opcion in ipairs(opcionesCopiarDentroOFuera) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = opcion

        if i == 1 then
            info.isTitle = true
            info.disabled = true
        else
            info.func = function()
                UIDropDownMenu_SetText(CopiarDentroOFueraDesplegable, opcion)
                CopiarDentroOFueraVariable = i  -- Asignar directamente el valor 2, 3 o 4
            end
        end

        -- Solo marcar como seleccionada si CopiarDentroOFueraVariable coincide con el índice (i)
        if i == CopiarDentroOFueraVariable then
            info.checked = true
        else
            info.checked = false
        end

        info.keepShownOnClick = false
        UIDropDownMenu_AddButton(info, level)
    end
end)


-- ============================
-- === CAMBIAR ORDEN PARED A TECHO, O TECHO A PARED ===
-- ============================

-- Variable para guardar la selección (por defecto opción 2)
local OrdenParedTechoPared = 2

-- ================================
-- === Ventanas OCULTABLES ===
-- ================================

-- === Ventana para Techos Ocultable ===

local VentanaTechosOcultable = CreateFrame("Frame", "VentanaTechosOcultable", HacerTechoVentana, "BackdropTemplate")
VentanaTechosOcultable:SetSize(175, 114)
VentanaTechosOcultable:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
VentanaTechosOcultable:SetBackdropBorderColor(0.5, 0.5, 0.5)
VentanaTechosOcultable:SetBackdropColor(1, 1, 1, 0.8)
VentanaTechosOcultable:SetPoint("CENTER", HacerTechoVentana, "CENTER", 0, 0)

local function actualizarVentanaTechosOcultable()
    if OrdenParedTechoPared == 2 then
        VentanaTechosOcultable:Show()
    else
        VentanaTechosOcultable:Hide()
    end
end


-- === Ventana para Paredes Ocultable ===


local VentanaParedesOcultable = CreateFrame("Frame", "VentanaParedesOcultable", HacerTechoVentana, "BackdropTemplate")
VentanaParedesOcultable:SetSize(175, 114)
VentanaParedesOcultable:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
VentanaParedesOcultable:SetBackdropBorderColor(0.5, 0.5, 0.5)
VentanaParedesOcultable:SetBackdropColor(1, 1, 1, 0.8)
VentanaParedesOcultable:SetPoint("CENTER", HacerTechoVentana, "CENTER", 0, 0)

local function actualizarVentanaParedesOcultable()
    if OrdenParedTechoPared == 3 then
        VentanaParedesOcultable:Show()
    else
        VentanaParedesOcultable:Hide()
    end
end


actualizarVentanaTechosOcultable()
actualizarVentanaParedesOcultable()


-- ================================
-- === Menú desplegable ORDEN ===
-- ================================

-- Crear el desplegable
local OtrosCambiosDesplegable = CreateFrame("Frame", "OtrosCambiosDesplegable", HacerTechoVentana, "UIDropDownMenuTemplate")
OtrosCambiosDesplegable:SetPoint("CENTER", HacerTechoVentana, "CENTER", -67, 45)
UIDropDownMenu_SetWidth(OtrosCambiosDesplegable, 8)
UIDropDownMenu_SetText(OtrosCambiosDesplegable, "De Pared a Techo/Suelo")  -- Texto por defecto

-- Opciones
local opcionesOtrosCambios = {
    "¿Qué cambio de eje queremos?:", -- i = 1 (título)
    "De Pared a Techo/Suelo (De 90 a 0 grados)",       -- i = 2
    "De Techo/Suelo a Pared (De 0 a 90 grados)",       -- i = 3
}

-- Inicializar menú
UIDropDownMenu_Initialize(OtrosCambiosDesplegable, function(self, level)
    for i, opcion in ipairs(opcionesOtrosCambios) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = opcion

        if i == 1 then
            info.isTitle = true
            info.disabled = true
        else
            info.func = function()
                UIDropDownMenu_SetText(OtrosCambiosDesplegable, opcion)

                if i == 2 then
                    OrdenParedTechoPared = 2
                    actualizarVentanaTechosOcultable()
					actualizarVentanaParedesOcultable()

                elseif i == 3 then
                    OrdenParedTechoPared = 3
                    actualizarVentanaTechosOcultable()
					actualizarVentanaParedesOcultable()
                end
            end
        end

        info.checked = (i == OrdenParedTechoPared)
        info.keepShownOnClick = false
        UIDropDownMenu_AddButton(info, level)
    end
end)

-- Mostrar u ocultar al cargar según la opción actual
actualizarVentanaTechosOcultable()

-- Título dentro de la ventana
local tituloHacerTecho = VentanaTechosOcultable:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
tituloHacerTecho:SetPoint("TOP", 0, -5)
tituloHacerTecho:SetText("Techos o Suelos")

-- ================================
-- === INTERIOR VENTANA PARED A TECHO ===
-- ================================


-- === Subventana: RepresentacionTileTecho ===

local RepresentacionTileTecho = CreateFrame("Frame", "RepresentacionTileTecho", VentanaTechosOcultable, "BackdropTemplate")
RepresentacionTileTecho:SetSize(17, 63)
RepresentacionTileTecho:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",  -- Estilo de borde normal
    tile = true, tileSize = 16, edgeSize = 12, -- Borde con grosor normal
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
RepresentacionTileTecho:SetBackdropBorderColor(0.5, 0.5, 0.5)  -- Gris para el borde
RepresentacionTileTecho:SetBackdropColor(0.8, 0.8, 0.8, 0.8)  -- Fondo gris clarito con algo de transparencia
RepresentacionTileTecho:SetPoint("CENTER", VentanaTechosOcultable, "CENTER", 0, -5)



-- Texto ARRIBA
local textoArribaTecho = VentanaTechosOcultable:CreateFontString(nil, "OVERLAY", "GameFontNormal")
textoArribaTecho:SetPoint("TOP", 0, -18)
textoArribaTecho:SetText("Arriba")
textoArribaTecho:SetFont("Fonts\\FRIZQT__.TTF", 10)  
textoArribaTecho:SetTextColor(0.7, 0.7, 0.7)  

-- Texto ABAJO
local textoAbajoTecho = VentanaTechosOcultable:CreateFontString(nil, "OVERLAY", "GameFontNormal")
textoAbajoTecho:SetPoint("TOP", 0, -95)
textoAbajoTecho:SetText("Abajo")
textoAbajoTecho:SetFont("Fonts\\FRIZQT__.TTF", 10)
textoAbajoTecho:SetTextColor(0.7, 0.7, 0.7)

-- Texto POSTERIOR (invertido el nombre con el de abajo)
local textoFrenteTecho = VentanaTechosOcultable:CreateFontString(nil, "OVERLAY", "GameFontNormal")
textoFrenteTecho:SetPoint("TOP", -32, -55)
textoFrenteTecho:SetText("Posterior")
textoFrenteTecho:SetFont("Fonts\\FRIZQT__.TTF", 10)
textoFrenteTecho:SetTextColor(0.7, 0.7, 0.7)

-- Texto FRENTE
local textoPosteriorTecho = VentanaTechosOcultable:CreateFontString(nil, "OVERLAY", "GameFontNormal")
textoPosteriorTecho:SetPoint("TOP", 28, -55)
textoPosteriorTecho:SetText("Frente")
textoPosteriorTecho:SetFont("Fonts\\FRIZQT__.TTF", 10)
textoPosteriorTecho:SetTextColor(0.7, 0.7, 0.7)

-- Texto TILE
local textoTileTecho = VentanaTechosOcultable:CreateFontString(nil, "OVERLAY", "GameFontNormal")
textoTileTecho:SetPoint("TOPLEFT", 82, -43)
textoTileTecho:SetFont("Fonts\\FRIZQT__.TTF", 9)
textoTileTecho:SetTextColor(0.7, 0.7, 0.7)
textoTileTecho:SetText("T\nI\nL\nE")




tileScaleAnterior = 1

-- Botón 1
local BotonHacerTecho1 = CreateFrame("Button", nil, VentanaTechosOcultable, "UIPanelButtonTemplate")
BotonHacerTecho1:SetSize(70, 20)
BotonHacerTecho1:SetText(" ")
BotonHacerTecho1:SetPoint("TOPLEFT", RepresentacionTileTecho, "TOPLEFT", -70, 0)

-- Acción al hacer clic
BotonHacerTecho1:SetScript("OnClick", function()
    -- Forzar actualización de datos antes de copiar valores
    actualizarDatosTile()


    -- Lógica según valor de CopiarDentroOFueraVariable
    if CopiarDentroOFueraVariable == 2 then
        SendChatMessage(".gob copy u " .. (tileScale * 1.75), "SAY")
        SendChatMessage(".gob move b " .. (tileScale * 1.75), "SAY")
        SendChatMessage(".gob rotate " .. tileRotateX .. " 0 " .. tileRotateZ, "SAY")
        
    elseif CopiarDentroOFueraVariable == 3 then
        SendChatMessage(".gob copy u " .. (tileScale * 1.75), "SAY")
        SendChatMessage(".gob move b " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob rotate " .. tileRotateX .. " 0 " .. tileRotateZ, "SAY")

    elseif CopiarDentroOFueraVariable == 4 then
        SendChatMessage(".gob copy u " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob move b " .. (tileScale * 1.75), "SAY")
        SendChatMessage(".gob rotate " .. tileRotateX .. " 0 " .. tileRotateZ, "SAY")
    else
        print("ERROR: no es un valor válido.")
    end
end)


-- Botón 2
local BotonHacerTecho2 = CreateFrame("Button", nil, VentanaTechosOcultable, "UIPanelButtonTemplate")
BotonHacerTecho2:SetSize(70, 20)
BotonHacerTecho2:SetText(" ")
BotonHacerTecho2:SetPoint("TOP", BotonHacerTecho1, "TOP", 87, 0)

-- Acción al hacer clic
BotonHacerTecho2:SetScript("OnClick", function()
    -- Forzar actualización de datos antes de copiar valores
    actualizarDatosTile()


    -- Lógica según valor de CopiarDentroOFueraVariable
    if CopiarDentroOFueraVariable == 2 then
        SendChatMessage(".gob copy u " .. (tileScale * 1.75), "SAY")
        SendChatMessage(".gob move f " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob rotate " .. tileRotateX .. " 0 " .. tileRotateZ, "SAY")
        
    elseif CopiarDentroOFueraVariable == 3 then
        SendChatMessage(".gob copy u " .. (tileScale * 1.75), "SAY")
        SendChatMessage(".gob move f " .. (tileScale * 2.25), "SAY")
        SendChatMessage(".gob rotate " .. tileRotateX .. " 0 " .. tileRotateZ, "SAY")

    elseif CopiarDentroOFueraVariable == 4 then
        SendChatMessage(".gob copy u " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob move f " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob rotate " .. tileRotateX .. " 0 " .. tileRotateZ, "SAY")
    else
        print("ERROR: no es un valor válido.")
    end
end)

-- Botón 3
local BotonHacerTecho3 = CreateFrame("Button", nil, VentanaTechosOcultable, "UIPanelButtonTemplate")
BotonHacerTecho3:SetSize(70, 20)
BotonHacerTecho3:SetText(" ")
BotonHacerTecho3:SetPoint("BOTTOM", BotonHacerTecho1, "TOP", 0, -60)

-- Acción al hacer clic
BotonHacerTecho3:SetScript("OnClick", function()
    -- Forzar actualización de datos antes de copiar valores
    actualizarDatosTile()


    -- Lógica según valor de CopiarDentroOFueraVariable
    if CopiarDentroOFueraVariable == 2 then
        SendChatMessage(".gob copy d " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob move b " .. (tileScale * 1.75), "SAY")
        SendChatMessage(".gob rotate " .. tileRotateX .. " 0 " .. tileRotateZ, "SAY")
        
    elseif CopiarDentroOFueraVariable == 3 then
        SendChatMessage(".gob copy d " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob move b " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob rotate " .. tileRotateX .. " 0 " .. tileRotateZ, "SAY")

    elseif CopiarDentroOFueraVariable == 4 then
        SendChatMessage(".gob copy d " .. (tileScale * 2.25), "SAY")
        SendChatMessage(".gob move b " .. (tileScale * 1.75), "SAY")
        SendChatMessage(".gob rotate " .. tileRotateX .. " 0 " .. tileRotateZ, "SAY")
    else
        print("ERROR: no es un valor válido.")
    end
end)


-- Botón 4
local BotonHacerTecho4 = CreateFrame("Button", nil, VentanaTechosOcultable, "UIPanelButtonTemplate")
BotonHacerTecho4:SetSize(70, 20)
BotonHacerTecho4:SetText(" ")
BotonHacerTecho4:SetPoint("TOP", BotonHacerTecho3, "TOP", 87, 0)

-- Acción al hacer clic
BotonHacerTecho4:SetScript("OnClick", function()
    -- Forzar actualización de datos antes de copiar valores
    actualizarDatosTile()


    -- Lógica según valor de CopiarDentroOFueraVariable
    if CopiarDentroOFueraVariable == 2 then
        SendChatMessage(".gob copy d " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob move f " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob rotate " .. tileRotateX .. " 0 " .. tileRotateZ, "SAY")
        
    elseif CopiarDentroOFueraVariable == 3 then
        SendChatMessage(".gob copy d " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob move f " .. (tileScale * 2.25), "SAY")
        SendChatMessage(".gob rotate " .. tileRotateX .. " 0 " .. tileRotateZ, "SAY")

    elseif CopiarDentroOFueraVariable == 4 then
        SendChatMessage(".gob copy d " .. (tileScale * 2.25), "SAY")
        SendChatMessage(".gob move f " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob rotate " .. tileRotateX .. " 0 " .. tileRotateZ, "SAY")
    else
        print("ERROR: no es un valor válido.")
    end
end)


-- ==========================================
-- ==========================================
--            DE TECHO A PARED
-- ==========================================
-- ==========================================


-- ==========================================
-- INTERIOR VENTANA PAREDES
-- ==========================================

-- MENU DESPLEGABLE ARRIBA O ABAJO?
-- ==========================================


-- Variable de control
ParedArribaOAbajo = "u"  -- "u" para Suelo → Pared, "d" para Techo → Pared

-- Crear el desplegable para elegir orientación
local DesplegableArribaOAbajo = CreateFrame("Frame", "DesplegableArribaOAbajo", VentanaParedesOcultable, "UIDropDownMenuTemplate")
DesplegableArribaOAbajo:SetPoint("CENTER", VentanaParedesOcultable, "CENTER", 67, 45)
UIDropDownMenu_SetWidth(DesplegableArribaOAbajo, 8)
UIDropDownMenu_SetText(DesplegableArribaOAbajo, "De Suelo a Pared")  -- Por defecto

-- Opciones del menú
local opcionesArribaOAbajo = {
    "Selecciona dirección: ", -- i = 1 (título)
    "De Suelo a Pared (Hacia arriba)",      -- i = 2 → "u"
    "De Techo a Pared (Hacia abajo)",      -- i = 3 → "d"
}

-- Inicializar menú
UIDropDownMenu_Initialize(DesplegableArribaOAbajo, function(self, level)
    for i, opcion in ipairs(opcionesArribaOAbajo) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = opcion

        if i == 1 then
            info.isTitle = true
            info.disabled = true
        else
            info.func = function()
                UIDropDownMenu_SetText(DesplegableArribaOAbajo, opcion)

                if i == 2 then
                    ParedArribaOAbajo = "u"
                elseif i == 3 then
                    ParedArribaOAbajo = "d"
                end

                if actualizarTituloAVertical then
                    actualizarTituloAVertical()
                end
            end
        end

        -- Marcar como seleccionada la opción actual
        if (i == 2 and ParedArribaOAbajo == "u") or (i == 3 and ParedArribaOAbajo == "d") then
            info.checked = true
        else
            info.checked = false
        end

        info.keepShownOnClick = false
        UIDropDownMenu_AddButton(info, level)
    end
end)


-- TEXTO DINAMICO: TECHO O SUELO
-- ==========================================


-- Texto de título dinámico
local TituloAVertical = VentanaParedesOcultable:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
TituloAVertical:SetPoint("TOP", 0, -5)
TituloAVertical:SetFont("Fonts\\FRIZQT__.TTF", 11)
TituloAVertical:SetTextColor(1, 1, 1, 1)

-- Función para actualizar el texto
function actualizarTituloAVertical()
    if ParedArribaOAbajo == "u" then
        TituloAVertical:SetText("De Suelo a Pared")
    elseif ParedArribaOAbajo == "d" then
        TituloAVertical:SetText("De Techo a Pared")
    else
        TituloAVertical:SetText("Tipo desconocido")
    end
end

-- Llamada inicial
actualizarTituloAVertical()


-- REPRESENTACION TILE CENTRAL
-- ==========================================

-- === Representación central ===
local RepresentacionTileTecho = CreateFrame("Frame", "RepresentacionTileTecho", VentanaParedesOcultable, "BackdropTemplate")
RepresentacionTileTecho:SetSize(40, 40)
RepresentacionTileTecho:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
RepresentacionTileTecho:SetBackdropBorderColor(0.4, 0.4, 0.4)
RepresentacionTileTecho:SetBackdropColor(0.9, 0.9, 0.9, 1)
RepresentacionTileTecho:SetPoint("CENTER", VentanaParedesOcultable, "CENTER", 0, -7)


-- BOTONES
-- ==========================================

-- === Botones alrededor de la representación ===
local BotonAVertical1 = CreateFrame("Button", "BotonAVertical1", VentanaParedesOcultable, "UIPanelButtonTemplate")
BotonAVertical1:SetSize(50, 20)
BotonAVertical1:SetPoint("BOTTOM", RepresentacionTileTecho, "TOP", 0, 2)
BotonAVertical1:SetText("F")

-- Acción al hacer clic en BotonAVertical1
BotonAVertical1:SetScript("OnClick", function()
    -- Forzar actualización de datos antes de copiar valores
    actualizarDatosTile()

    -- Lógica según valor de CopiarDentroOFueraVariable
    if CopiarDentroOFueraVariable == 2 then
		if ParedArribaOAbajo == "u" then
			SendChatMessage(".gob copy " .. ParedArribaOAbajo .. " " .. (tileScale * 2), "SAY")
			SendChatMessage(".gob move f " .. (tileScale * 1.75), "SAY")
			SendChatMessage(".gob rotate " .. tileRotateX .. " 90 " .. tileRotateZ, "SAY")
		 elseif ParedArribaOAbajo == "d" then 
            SendChatMessage(".gob copy d " .. (tileScale * 1.75), "SAY")
            SendChatMessage(".gob move f " .. (tileScale * 1.75), "SAY")
            SendChatMessage(".gob rotate " .. tileRotateX .. " 90 " .. tileRotateZ, "SAY")
        end

    elseif CopiarDentroOFueraVariable == 3 then
        if ParedArribaOAbajo == "u" then
            SendChatMessage(".gob copy u " .. (tileScale * 2.25), "SAY")
            SendChatMessage(".gob move f " .. (tileScale * 1.75), "SAY")
            SendChatMessage(".gob rotate " .. tileRotateX .. " 90 " .. tileRotateZ, "SAY")
        elseif ParedArribaOAbajo == "d" then 
            SendChatMessage(".gob copy d " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob move f " .. (tileScale * 1.75), "SAY")
            SendChatMessage(".gob rotate " .. tileRotateX .. " 90 " .. tileRotateZ, "SAY")
        end

    elseif CopiarDentroOFueraVariable == 4 then
        if ParedArribaOAbajo == "u" then
            SendChatMessage(".gob copy u " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob move f " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob rotate " .. tileRotateX .. " 90 " .. tileRotateZ, "SAY")
        elseif ParedArribaOAbajo == "d" then
            SendChatMessage(".gob copy d " .. (tileScale * 1.75), "SAY")
            SendChatMessage(".gob move f " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob rotate " .. tileRotateX .. " 90 " .. tileRotateZ, "SAY")
        end

    else
        print("ERROR: no es un valor válido.")
    end
end)







local BotonAVertical2 = CreateFrame("Button", "BotonAVertical2", VentanaParedesOcultable, "UIPanelButtonTemplate")
BotonAVertical2:SetSize(50, 20)
BotonAVertical2:SetPoint("TOP", RepresentacionTileTecho, "BOTTOM", 0, -2)
BotonAVertical2:SetText("B")

BotonAVertical2:SetScript("OnClick", function()
    -- Forzar actualización de datos antes de copiar valores
    actualizarDatosTile()

    -- Lógica según valor de CopiarDentroOFueraVariable
    if CopiarDentroOFueraVariable == 2 then
		if ParedArribaOAbajo == "u" then
			SendChatMessage(".gob copy " .. ParedArribaOAbajo .. " " .. (tileScale * 2), "SAY")
			SendChatMessage(".gob move b " .. (tileScale * 2), "SAY")
			SendChatMessage(".gob rotate " .. tileRotateX .. " 90 " .. tileRotateZ, "SAY")
		 elseif ParedArribaOAbajo == "d" then 
            SendChatMessage(".gob copy d " .. (tileScale * 1.75), "SAY")
            SendChatMessage(".gob move b " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob rotate " .. tileRotateX .. " 90 " .. tileRotateZ, "SAY")
        end

    elseif CopiarDentroOFueraVariable == 3 then
        if ParedArribaOAbajo == "u" then
            SendChatMessage(".gob copy u " .. (tileScale * 2.25), "SAY")
            SendChatMessage(".gob move b " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob rotate " .. tileRotateX .. " 90 " .. tileRotateZ, "SAY")
        elseif ParedArribaOAbajo == "d" then 
            SendChatMessage(".gob copy d " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob move b " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob rotate " .. tileRotateX .. " 90 " .. tileRotateZ, "SAY")
        end

    elseif CopiarDentroOFueraVariable == 4 then
        if ParedArribaOAbajo == "u" then
            SendChatMessage(".gob copy u " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob move b " .. (tileScale * 2.25), "SAY")
            SendChatMessage(".gob rotate " .. tileRotateX .. " 90 " .. tileRotateZ, "SAY")
        elseif ParedArribaOAbajo == "d" then
            SendChatMessage(".gob copy d " .. (tileScale * 1.75), "SAY")
            SendChatMessage(".gob move b " .. (tileScale * 2.25), "SAY")
            SendChatMessage(".gob rotate " .. tileRotateX .. " 90 " .. tileRotateZ, "SAY")
        end

    else
        print("ERROR: no es un valor válido.")
    end
end)

local BotonAVertical3 = CreateFrame("Button", "BotonAVertical3", VentanaParedesOcultable, "UIPanelButtonTemplate")
BotonAVertical3:SetSize(25, 50)
BotonAVertical3:SetPoint("RIGHT", RepresentacionTileTecho, "LEFT", -2, 0)
BotonAVertical3:SetText("L")

BotonAVertical3:SetScript("OnClick", function()
    -- Forzar actualización de datos antes de copiar valores
    actualizarDatosTile()

    -- Lógica según valor de CopiarDentroOFueraVariable
    if CopiarDentroOFueraVariable == 2 then
		if ParedArribaOAbajo == "u" then
			SendChatMessage(".gob copy " .. ParedArribaOAbajo .. " " .. (tileScale * 2), "SAY")
			SendChatMessage(".gob move l " .. (tileScale * 2), "SAY")
			SendChatMessage(".gob rotate 90 " .. tileRotateY .. " " .. tileRotateZ, "SAY")

		 elseif ParedArribaOAbajo == "d" then 
            SendChatMessage(".gob copy d " .. (tileScale * 1.75), "SAY")
            SendChatMessage(".gob move l " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob rotate 90 " .. tileRotateY .. " " .. tileRotateZ, "SAY")
        end

    elseif CopiarDentroOFueraVariable == 3 then
        if ParedArribaOAbajo == "u" then
            SendChatMessage(".gob copy u " .. (tileScale * 2.25), "SAY")
            SendChatMessage(".gob move l " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob rotate 90 " .. tileRotateY .. " " .. tileRotateZ, "SAY")
        elseif ParedArribaOAbajo == "d" then 
            SendChatMessage(".gob copy d " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob move l " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob rotate 90 " .. tileRotateY .. " " .. tileRotateZ, "SAY")
        end

    elseif CopiarDentroOFueraVariable == 4 then
        if ParedArribaOAbajo == "u" then
            SendChatMessage(".gob copy u " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob move l " .. (tileScale * 2.25), "SAY")
            SendChatMessage(".gob rotate 90 " .. tileRotateY .. " " .. tileRotateZ, "SAY")
        elseif ParedArribaOAbajo == "d" then
            SendChatMessage(".gob copy d " .. (tileScale * 1.75), "SAY")
            SendChatMessage(".gob move l " .. (tileScale * 2.25), "SAY")
            SendChatMessage(".gob rotate 90 " .. tileRotateY .. " " .. tileRotateZ, "SAY")
        end

    else
        print("ERROR: no es un valor válido.")
    end
end)

local BotonAVertical4 = CreateFrame("Button", "BotonAVertical4", VentanaParedesOcultable, "UIPanelButtonTemplate")
BotonAVertical4:SetSize(25, 50)
BotonAVertical4:SetPoint("LEFT", RepresentacionTileTecho, "RIGHT", 2, 0)
BotonAVertical4:SetText("R")

BotonAVertical4:SetScript("OnClick", function()
    -- Forzar actualización de datos antes de copiar valores
    actualizarDatosTile()

    -- Lógica según valor de CopiarDentroOFueraVariable
    if CopiarDentroOFueraVariable == 2 then
		if ParedArribaOAbajo == "u" then
			SendChatMessage(".gob copy " .. ParedArribaOAbajo .. " " .. (tileScale * 2), "SAY")
			SendChatMessage(".gob move r " .. (tileScale * 1.75), "SAY")
			SendChatMessage(".gob rotate 90 " .. tileRotateY .. " " .. tileRotateZ, "SAY")
		 elseif ParedArribaOAbajo == "d" then 
            SendChatMessage(".gob copy d " .. (tileScale * 1.75), "SAY")
            SendChatMessage(".gob move r " .. (tileScale * 1.75), "SAY")
            SendChatMessage(".gob rotate 90 " .. tileRotateY .. " " .. tileRotateZ, "SAY")
        end

    elseif CopiarDentroOFueraVariable == 3 then
        if ParedArribaOAbajo == "u" then
            SendChatMessage(".gob copy u " .. (tileScale * 2.25), "SAY")
            SendChatMessage(".gob move r " .. (tileScale * 1.75), "SAY")
            SendChatMessage(".gob rotate 90 " .. tileRotateY .. " " .. tileRotateZ, "SAY")
        elseif ParedArribaOAbajo == "d" then 
            SendChatMessage(".gob copy d " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob move r " .. (tileScale * 1.75), "SAY")
            SendChatMessage(".gob rotate 90 " .. tileRotateY .. " " .. tileRotateZ, "SAY")
        end

    elseif CopiarDentroOFueraVariable == 4 then
        if ParedArribaOAbajo == "u" then
            SendChatMessage(".gob copy u " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob move r " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob rotate 90 " .. tileRotateY .. " " .. tileRotateZ, "SAY")
        elseif ParedArribaOAbajo == "d" then
            SendChatMessage(".gob copy d " .. (tileScale * 1.75), "SAY")
            SendChatMessage(".gob move r " .. (tileScale * 2), "SAY")
            SendChatMessage(".gob rotate 90 " .. tileRotateY .. " " .. tileRotateZ, "SAY")
        end

    else
        print("ERROR: no es un valor válido.")
    end
end)



-- TEXTOS
-- ==========================================

-- === Texto central en el recuadro ===
local TextoAVertical1 = RepresentacionTileTecho:CreateFontString(nil, "OVERLAY", "GameFontNormal")
TextoAVertical1:SetPoint("CENTER", 0, 0)
TextoAVertical1:SetText("TILE")
TextoAVertical1:SetFont("Fonts\\FRIZQT__.TTF", 10)
TextoAVertical1:SetTextColor(0.7, 0.7, 0.7)

local TextoAVertical1 = VentanaParedesOcultable:CreateFontString(nil, "OVERLAY", "GameFontNormal")
TextoAVertical1:SetPoint("BOTTOMLEFT", 7, 10)
TextoAVertical1:SetText("VISTA AEREA")
TextoAVertical1:SetFont("Fonts\\FRIZQT__.TTF", 7)
TextoAVertical1:SetTextColor(1, 1, 1)








-- ==========================================
-- ==========================================
--            ESQUINAS
-- ==========================================
-- ==========================================




-- === Ventana para Esquinas ===

local EsquinasVentana = CreateFrame("Frame", "EsquinasVentana", TileTinkerWindow, "BackdropTemplate")
EsquinasVentana:SetSize(175, 114)
EsquinasVentana:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
EsquinasVentana:SetBackdropBorderColor(0.5, 0.5, 0.5)
EsquinasVentana:SetBackdropColor(1, 1, 1, 0.8)
EsquinasVentana:Hide()

local tituloEsquinas = EsquinasVentana:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
tituloEsquinas:SetPoint("TOP", 0, -5)
tituloEsquinas:SetText("Esquinas")

-- Subventana dentro Representar tile

local RepresentacionTileEsquinas = CreateFrame("Frame", "RepresentacionTileEsquinas", EsquinasVentana, "BackdropTemplate")
RepresentacionTileEsquinas:SetSize(17, 63)
RepresentacionTileEsquinas:SetPoint("CENTER", EsquinasVentana, "CENTER", 0, -5)
RepresentacionTileEsquinas:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
RepresentacionTileEsquinas:SetBackdropBorderColor(0.4, 0.4, 0.4)
RepresentacionTileEsquinas:SetBackdropColor(0.9, 0.9, 0.9, 0.7)


-- === Textos

-- Texto IZQUIERDA
local textoArribaEsquina = EsquinasVentana:CreateFontString(nil, "OVERLAY", "GameFontNormal")
textoArribaEsquina:SetPoint("TOP", 0, -18)
textoArribaEsquina:SetText("Izquierda")
textoArribaEsquina:SetFont("Fonts\\FRIZQT__.TTF", 10)  
textoArribaEsquina:SetTextColor(0.7, 0.7, 0.7)  

-- Texto DERECHA
local textoAbajoEsquina = EsquinasVentana:CreateFontString(nil, "OVERLAY", "GameFontNormal")
textoAbajoEsquina:SetPoint("TOP", 0, -95)
textoAbajoEsquina:SetText("Derecha")
textoAbajoEsquina:SetFont("Fonts\\FRIZQT__.TTF", 10)
textoAbajoEsquina:SetTextColor(0.7, 0.7, 0.7)

-- Texto FRENTE
local textoFrenteEsquina = EsquinasVentana:CreateFontString(nil, "OVERLAY", "GameFontNormal")
textoFrenteEsquina:SetPoint("TOP", 28, -55)
textoFrenteEsquina:SetText("Frente")
textoFrenteEsquina:SetFont("Fonts\\FRIZQT__.TTF", 10)
textoFrenteEsquina:SetTextColor(0.7, 0.7, 0.7)

-- Texto POSTERIOR
local textoPosteriorEsquina = EsquinasVentana:CreateFontString(nil, "OVERLAY", "GameFontNormal")
textoPosteriorEsquina:SetPoint("TOP", -32, -55)
textoPosteriorEsquina:SetText("Posterior")
textoPosteriorEsquina:SetFont("Fonts\\FRIZQT__.TTF", 10)
textoPosteriorEsquina:SetTextColor(0.7, 0.7, 0.7)

-- Texto TILE
local textoTileEsquina = EsquinasVentana:CreateFontString(nil, "OVERLAY", "GameFontNormal")
textoTileEsquina:SetPoint("TOPLEFT", 82, -43)
textoTileEsquina:SetFont("Fonts\\FRIZQT__.TTF", 9)
textoTileEsquina:SetTextColor(0.7, 0.7, 0.7)
textoTileEsquina:SetText("T\nI\nL\nE")

local TextoVistaAereaEsquinas = EsquinasVentana:CreateFontString(nil, "OVERLAY", "GameFontNormal")
TextoVistaAereaEsquinas:SetPoint("BOTTOMLEFT", 7, 10)
TextoVistaAereaEsquinas:SetText("VISTA AEREA")
TextoVistaAereaEsquinas:SetFont("Fonts\\FRIZQT__.TTF", 7)
TextoVistaAereaEsquinas:SetTextColor(1, 1, 1)




-- =========== BOTONES VENTANA ESQUINA


-- Botón 1
local BotonHacerEsquina1 = CreateFrame("Button", nil, EsquinasVentana, "UIPanelButtonTemplate")
BotonHacerEsquina1:SetSize(70, 20)
BotonHacerEsquina1:SetText(" ")
BotonHacerEsquina1:SetPoint("TOPLEFT", RepresentacionTileEsquinas, "TOPLEFT", -70, 0)

BotonHacerEsquina1:SetScript("OnClick", function()
    actualizarDatosTile()

    if CopiarDentroOFueraVariable == 2 then
        SendChatMessage(".gob copy b " .. (tileScale * 1.75), "SAY")
        SendChatMessage(".gob turn 90" , "SAY")
		SendChatMessage(".gob move f " .. (tileScale * 1.75), "SAY")
        
    elseif CopiarDentroOFueraVariable == 3 then
        SendChatMessage(".gob copy b " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob turn 90" , "SAY")
		SendChatMessage(".gob move f " .. (tileScale * 1.75), "SAY")

    elseif CopiarDentroOFueraVariable == 4 then
        SendChatMessage(".gob copy b " .. (tileScale * 1.75), "SAY")
        SendChatMessage(".gob turn 90" , "SAY")
		SendChatMessage(".gob move f " .. (tileScale * 2), "SAY")
    else
        print("ERROR: no es un valor válido.")
    end
end)

-- Botón 2
local BotonHacerEsquina2 = CreateFrame("Button", nil, EsquinasVentana, "UIPanelButtonTemplate")
BotonHacerEsquina2:SetSize(70, 20)
BotonHacerEsquina2:SetText(" ")
BotonHacerEsquina2:SetPoint("TOP", BotonHacerEsquina1, "TOP", 87, 0)

BotonHacerEsquina2:SetScript("OnClick", function()
    actualizarDatosTile()

    if CopiarDentroOFueraVariable == 2 then
        SendChatMessage(".gob copy f " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob turn 90" , "SAY")
		SendChatMessage(".gob move f " .. (tileScale * 1.75), "SAY")
        
    elseif CopiarDentroOFueraVariable == 3 then
        SendChatMessage(".gob copy f " .. (tileScale * 2.25), "SAY")
        SendChatMessage(".gob turn 90" , "SAY")
		SendChatMessage(".gob move f " .. (tileScale * 1.75), "SAY")

    elseif CopiarDentroOFueraVariable == 4 then
        SendChatMessage(".gob copy f " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob turn 90" , "SAY")
		SendChatMessage(".gob move f " .. (tileScale * 2), "SAY")
    else
        print("ERROR: no es un valor válido.")
    end
end)

-- Botón 3
local BotonHacerEsquina3 = CreateFrame("Button", nil, EsquinasVentana, "UIPanelButtonTemplate")
BotonHacerEsquina3:SetSize(70, 20)
BotonHacerEsquina3:SetText(" ")
BotonHacerEsquina3:SetPoint("BOTTOM", BotonHacerEsquina1, "TOP", 0, -60)

BotonHacerEsquina3:SetScript("OnClick", function()
    actualizarDatosTile()

    if CopiarDentroOFueraVariable == 2 then
        SendChatMessage(".gob copy b " .. (tileScale * 1.75), "SAY")
        SendChatMessage(".gob turn 90" , "SAY")
		SendChatMessage(".gob move b " .. (tileScale * 2), "SAY")
        
    elseif CopiarDentroOFueraVariable == 3 then
        SendChatMessage(".gob copy b " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob turn 90" , "SAY")
		SendChatMessage(".gob move b " .. (tileScale * 2), "SAY")

    elseif CopiarDentroOFueraVariable == 4 then
        SendChatMessage(".gob copy b " .. (tileScale * 1.75), "SAY")
        SendChatMessage(".gob turn 90" , "SAY")
		SendChatMessage(".gob move b " .. (tileScale * 2.25), "SAY")
    else
        print("ERROR: no es un valor válido.")
    end
end)

-- Botón 4
local BotonHacerEsquina4 = CreateFrame("Button", nil, EsquinasVentana, "UIPanelButtonTemplate")
BotonHacerEsquina4:SetSize(70, 20)
BotonHacerEsquina4:SetText(" ")
BotonHacerEsquina4:SetPoint("TOP", BotonHacerEsquina3, "TOP", 87, 0)

BotonHacerEsquina4:SetScript("OnClick", function()
    actualizarDatosTile()

    if CopiarDentroOFueraVariable == 2 then
        SendChatMessage(".gob copy f " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob turn 90" , "SAY")
		SendChatMessage(".gob move b " .. (tileScale * 2), "SAY")
        
    elseif CopiarDentroOFueraVariable == 3 then
        SendChatMessage(".gob copy f " .. (tileScale * 2.25), "SAY")
        SendChatMessage(".gob turn 90" , "SAY")
		SendChatMessage(".gob move b " .. (tileScale * 2), "SAY")

    elseif CopiarDentroOFueraVariable == 4 then
        SendChatMessage(".gob copy f " .. (tileScale * 2), "SAY")
        SendChatMessage(".gob turn 90" , "SAY")
		SendChatMessage(".gob move b " .. (tileScale * 2.25), "SAY")
    else
        print("ERROR: no es un valor válido.")
    end
end)










-- ==========================================

-- === Botón para abrir/cerrar las ventanas Techo y Esquinas ===
local BotonToggleTechoYEsquinas = CreateFrame("Button", nil, TileTinkerWindow, "UIPanelButtonTemplate")
BotonToggleTechoYEsquinas:SetSize(175, 20)
BotonToggleTechoYEsquinas:SetText("Cambios de Eje")
BotonToggleTechoYEsquinas:SetPoint("TOPLEFT", TileTinkerWindow, "TOPLEFT", 20, -270)
BotonToggleTechoYEsquinas:SetScript("OnClick", function()
    local mostrar = not HacerTechoVentana:IsShown()
    if mostrar then
        HacerTechoVentana:Show()
        EsquinasVentana:Show()
    else
        HacerTechoVentana:Hide()
        EsquinasVentana:Hide()
    end
    ActualizarLayout()
end)




-- ============================
-- === VENTANA DE INCLINACIóN ===
-- ============================

-- === Ventana: Inclinación ===
local InclinacionVentana = CreateFrame("Frame", "InclinacionVentana", TileTinkerWindow, "BackdropTemplate")
InclinacionVentana:SetSize(175, 84)
InclinacionVentana:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
InclinacionVentana:SetBackdropBorderColor(0.5, 0.5, 0.5)
InclinacionVentana:SetBackdropColor(1, 1, 1, 0.8)
InclinacionVentana:Hide()

local tituloInclinacion = InclinacionVentana:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
tituloInclinacion:SetPoint("TOP", 0, -5)
tituloInclinacion:SetText("Tiles Inclinados")


-- === Texto: "Ángulo:" ===
local TextoIntroducirAnguloInclinacion = InclinacionVentana:CreateFontString(nil, "OVERLAY", "GameFontNormal")
TextoIntroducirAnguloInclinacion:SetPoint("TOPLEFT", InclinacionVentana, "TOPLEFT", 10, -24)
TextoIntroducirAnguloInclinacion:SetText("Ángulo*:")

-- === Casilla para introducir ángulo ===
local CasillaIntroducirAnguloInclinacion = CreateFrame("EditBox", nil, InclinacionVentana, "InputBoxTemplate")
CasillaIntroducirAnguloInclinacion:SetSize(90, 20)
CasillaIntroducirAnguloInclinacion:SetPoint("LEFT", TextoIntroducirAnguloInclinacion, "RIGHT", 10, 0)
CasillaIntroducirAnguloInclinacion:SetAutoFocus(false)
CasillaIntroducirAnguloInclinacion:SetNumeric(true)

-- Variable para almacenar el ángulo introducido
VariableIntroducirAnguloInclinacion = 0

CasillaIntroducirAnguloInclinacion:SetScript("OnEnterPressed", function(self)
    local textoCasillaIntroducirAnguloInclinacion = self:GetText()
    local numeroIntroducirAnguloInclinacion = tonumber(textoCasillaIntroducirAnguloInclinacion)
    if numeroIntroducirAnguloInclinacion and numeroIntroducirAnguloInclinacion > 0 then
        VariableIntroducirAnguloInclinacion = numeroIntroducirAnguloInclinacion
    else
        print("ERROR: Introduce un ángulo mayor que 0.")
    end
    self:ClearFocus()
end)

local TextoAclarativoInclinacion = InclinacionVentana:CreateFontString(nil, "OVERLAY", "GameFontNormal")
TextoAclarativoInclinacion:SetPoint("BOTTOMLEFT", 7, 33)
TextoAclarativoInclinacion:SetText("*Solo si el tile no está ya inclinado.")
TextoAclarativoInclinacion:SetFont("Fonts\\FRIZQT__.TTF", 8)
TextoAclarativoInclinacion:SetTextColor(1, 1, 1)

-- === Botón Inclinación Debajo ===
local BotonInclinacionDebajo = CreateFrame("Button", nil, InclinacionVentana, "UIPanelButtonTemplate")
BotonInclinacionDebajo:SetSize(77, 20)
BotonInclinacionDebajo:SetText("Debajo")
BotonInclinacionDebajo:SetPoint("TOPLEFT", TextoIntroducirAnguloInclinacion, "BOTTOMLEFT", 0, -18)

	

BotonInclinacionDebajo:SetScript("OnClick", function()
	actualizarDatosTile()
    local LadoTileInclinacion = tileScale * 4

    -- Normalizar para valores cercanos a cero
    local rotX = math.abs(tileRotateX) < 0.0001 and 0 or tileRotateX
    local rotY = math.abs(tileRotateY) < 0.0001 and 0 or tileRotateY

    if rotX - rotY > 0.0001 then
        local TileInclinacionSin1 = math.sin(math.rad(tileRotateX))
        local TileInclinacionResultadoUP = TileInclinacionSin1 * LadoTileInclinacion
        local TileInclinacionSin2 = math.sin(math.rad(90 - tileRotateX))
        local TileInclinacionResultadoMOVER = TileInclinacionSin2 * LadoTileInclinacion
        SendChatMessage(".gob copy d " .. TileInclinacionResultadoUP, "SAY")
        SendChatMessage(".gob move r " .. TileInclinacionResultadoMOVER, "SAY")

    elseif rotY - rotX > 0.0001 then
        local TileInclinacionSin1 = math.sin(math.rad(tileRotateY))
        local TileInclinacionResultadoUP = TileInclinacionSin1 * LadoTileInclinacion
        local TileInclinacionSin2 = math.sin(math.rad(90 - tileRotateY))
        local TileInclinacionResultadoMOVER = TileInclinacionSin2 * LadoTileInclinacion
        SendChatMessage(".gob copy d " .. TileInclinacionResultadoUP, "SAY")
        SendChatMessage(".gob move f " .. TileInclinacionResultadoMOVER, "SAY")

    else
        if VariableIntroducirAnguloInclinacion == 0 then
            print("ERROR: El tile no está inclinado y no has introducido primero un ángulo en la casilla. Realiza una de estas dos cosas primero.")
        else
            SendChatMessage(".gob rotate " .. VariableIntroducirAnguloInclinacion .. " " .. tileRotateY .. " " .. tileRotateZ, "SAY")
            actualizarDatosTile()
            local TileInclinacionSin1 = math.sin(math.rad(VariableIntroducirAnguloInclinacion))
            local TileInclinacionResultadoUP = TileInclinacionSin1 * LadoTileInclinacion
            local TileInclinacionSin2 = math.sin(math.rad(90 - VariableIntroducirAnguloInclinacion))
            local TileInclinacionResultadoMOVER = TileInclinacionSin2 * LadoTileInclinacion
            SendChatMessage(".gob copy d " .. TileInclinacionResultadoUP, "SAY")
            SendChatMessage(".gob move r " .. TileInclinacionResultadoMOVER, "SAY")
        end
    end
end)



-- === Botón Inclinación Encima ===
local BotonInclinacionEncima = CreateFrame("Button", nil, InclinacionVentana, "UIPanelButtonTemplate")
BotonInclinacionEncima:SetSize(77, 20)
BotonInclinacionEncima:SetText("Encima")
BotonInclinacionEncima:SetPoint("LEFT", BotonInclinacionDebajo, "RIGHT", 2, 0)

BotonInclinacionEncima:SetScript("OnClick", function()
    actualizarDatosTile()
    local LadoTileInclinacion = tileScale * 4

    -- Normalizar para valores cercanos a cero
    local rotX = math.abs(tileRotateX) < 0.0001 and 0 or tileRotateX
    local rotY = math.abs(tileRotateY) < 0.0001 and 0 or tileRotateY

    if rotX - rotY > 0.0001 then
        local TileInclinacionSin1 = math.sin(math.rad(tileRotateX))
        local TileInclinacionResultadoUP = TileInclinacionSin1 * LadoTileInclinacion
        local TileInclinacionSin2 = math.sin(math.rad(90 - tileRotateX))
        local TileInclinacionResultadoMOVER = TileInclinacionSin2 * LadoTileInclinacion
        SendChatMessage(".gob copy u " .. TileInclinacionResultadoUP, "SAY")
        SendChatMessage(".gob move l " .. TileInclinacionResultadoMOVER, "SAY")

    elseif rotY - rotX > 0.0001 then
        local TileInclinacionSin1 = math.sin(math.rad(tileRotateY))
        local TileInclinacionResultadoUP = TileInclinacionSin1 * LadoTileInclinacion
        local TileInclinacionSin2 = math.sin(math.rad(90 - tileRotateY))
        local TileInclinacionResultadoMOVER = TileInclinacionSin2 * LadoTileInclinacion
        SendChatMessage(".gob copy u " .. TileInclinacionResultadoUP, "SAY")
        SendChatMessage(".gob move b " .. TileInclinacionResultadoMOVER, "SAY")

    else
        if VariableIntroducirAnguloInclinacion == 0 then
            print("ERROR: El tile no está inclinado y no has introducido primero un ángulo en la casilla. Realiza una de estas dos cosas primero.")
        else
            SendChatMessage(".gob rotate " .. VariableIntroducirAnguloInclinacion .. " " .. tileRotateY .. " " .. tileRotateZ, "SAY")
            actualizarDatosTile()
            local TileInclinacionSin1 = math.sin(math.rad(VariableIntroducirAnguloInclinacion))
            local TileInclinacionResultadoUP = TileInclinacionSin1 * LadoTileInclinacion
            local TileInclinacionSin2 = math.sin(math.rad(90 - VariableIntroducirAnguloInclinacion))
            local TileInclinacionResultadoMOVER = TileInclinacionSin2 * LadoTileInclinacion
            SendChatMessage(".gob copy u " .. TileInclinacionResultadoUP, "SAY")
            SendChatMessage(".gob move l " .. TileInclinacionResultadoMOVER, "SAY")
        end
    end
end)





-- ============================
-- === VENTANA DE ROTACIONES ===
-- ============================




-- === Ventana: Rotaciones ===
local RotacionesVentana = CreateFrame("Frame", "RotacionesVentana", TileTinkerWindow, "BackdropTemplate")
RotacionesVentana:SetSize(175, 123)
RotacionesVentana:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
RotacionesVentana:SetBackdropBorderColor(0.5, 0.5, 0.5)
RotacionesVentana:SetBackdropColor(1, 1, 1, 0.8)
RotacionesVentana:Hide()

local tituloRotaciones = RotacionesVentana:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
tituloRotaciones:SetPoint("TOP", 0, -5)
tituloRotaciones:SetText("Rotaciones")

-- === Boton Girar 90 grados ===

local PonerA90GradosBoton = CreateFrame("Button", nil, RotacionesVentana, "UIPanelButtonTemplate")
PonerA90GradosBoton:SetSize(85, 18)
PonerA90GradosBoton:SetText("Rotar Y 90°")
PonerA90GradosBoton:SetPoint("CENTER", RotacionesVentana, "CENTER", -37, 30)

PonerA90GradosBoton:SetScript("OnClick", function()
    actualizarDatosTile()

    local rotateY90 = tileRotateY + 90

    -- Normalizar valor si pasa de 360
    if rotateY90 >= 360 then
        rotateY90 = rotateY90 - 360
    end

    -- Correcciones específicas
    if rotateY90 >= 268 and rotateY90 <= 272 then
        rotateY90 = 90
    elseif rotateY90 >= 178 and rotateY90 <= 182 then
        rotateY90 = 0
    end

    SendChatMessage(".gob rotate " .. tileRotateX .. " " .. rotateY90 .. " " .. tileRotateZ, "SAY")
end)



-- === PARTE GIRAR X EN GRADOS ===

local tituloRotaciones2 = RotacionesVentana:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
tituloRotaciones2:SetPoint("TOP", 59, -28)
tituloRotaciones2:SetText("Girar:")

-- === Casilla de Inversión de Giro ===
local TextoInvertirGiro = RotacionesVentana:CreateFontString(nil, "OVERLAY", "GameFontNormal")
TextoInvertirGiro:SetPoint("TOPRIGHT", tituloRotaciones2, "BOTTOMRIGHT", -12, -62)
TextoInvertirGiro:SetText("Invertir:")
TextoInvertirGiro:SetFont("Fonts\\FRIZQT__.TTF", 10)
TextoInvertirGiro:SetTextColor(1, 1, 1)

local CasillaInvertirTurn = CreateFrame("CheckButton", nil, RotacionesVentana, "UICheckButtonTemplate")
CasillaInvertirTurn:SetSize(20, 20)
CasillaInvertirTurn:SetPoint("LEFT", TextoInvertirGiro, "RIGHT", 0, 0)

local function calcularGiro(valor)
    if CasillaInvertirTurn:GetChecked() then
        return -valor
    else
        return valor
    end
end

-- === Botón Girar Z +15 ===
local BotonGirar15 = CreateFrame("Button", nil, RotacionesVentana, "UIPanelButtonTemplate")
BotonGirar15:SetSize(50, 25)
BotonGirar15:SetText("15º")
BotonGirar15:SetPoint("TOPLEFT", PonerA90GradosBoton, "BOTTOMLEFT", 0, -3)
BotonGirar15:SetScript("OnClick", function()
    SendChatMessage(".gob turn " .. calcularGiro(15), "SAY")
end)

-- === Botón Girar Z +30 ===
local BotonGirar30 = CreateFrame("Button", nil, RotacionesVentana, "UIPanelButtonTemplate")
BotonGirar30:SetSize(50, 25)
BotonGirar30:SetText("30º")
BotonGirar30:SetPoint("LEFT", BotonGirar15, "RIGHT", 5, 0)
BotonGirar30:SetScript("OnClick", function()
    SendChatMessage(".gob turn " .. calcularGiro(30), "SAY")
end)

-- === Botón Girar Z +45 ===
local BotonGirar45 = CreateFrame("Button", nil, RotacionesVentana, "UIPanelButtonTemplate")
BotonGirar45:SetSize(50, 25)
BotonGirar45:SetText("45º")
BotonGirar45:SetPoint("LEFT", BotonGirar30, "RIGHT", 5, 0)
BotonGirar45:SetScript("OnClick", function()
    SendChatMessage(".gob turn " .. calcularGiro(45), "SAY")
end)

-- === Botón Girar Z +60 ===
local BotonGirar60 = CreateFrame("Button", nil, RotacionesVentana, "UIPanelButtonTemplate")
BotonGirar60:SetSize(50, 25)
BotonGirar60:SetText("60º")
BotonGirar60:SetPoint("TOP", BotonGirar15, "BOTTOM", 0, -1)
BotonGirar60:SetScript("OnClick", function()
    SendChatMessage(".gob turn " .. calcularGiro(60), "SAY")
end)

-- === Botón Girar Z +90 ===
local BotonGirar90 = CreateFrame("Button", nil, RotacionesVentana, "UIPanelButtonTemplate")
BotonGirar90:SetSize(50, 25)
BotonGirar90:SetText("90º")
BotonGirar90:SetPoint("LEFT", BotonGirar60, "RIGHT", 5, 0)
BotonGirar90:SetScript("OnClick", function()
    SendChatMessage(".gob turn " .. calcularGiro(90), "SAY")
end)

-- === Botón Girar Z +180 ===
local BotonGirar180 = CreateFrame("Button", nil, RotacionesVentana, "UIPanelButtonTemplate")
BotonGirar180:SetSize(50, 25)
BotonGirar180:SetText("180º")
BotonGirar180:SetPoint("LEFT", BotonGirar90, "RIGHT", 5, 0)
BotonGirar180:SetScript("OnClick", function()
    SendChatMessage(".gob turn " .. calcularGiro(180), "SAY")
end)



-- === Botón Set 0 Grados ===

local Set0GradosBoton = CreateFrame("Button", nil, RotacionesVentana, "UIPanelButtonTemplate")
Set0GradosBoton:SetSize(90, 15)
Set0GradosBoton:SetText("Establecer 0°")
Set0GradosBoton:SetPoint("TOPLEFT", BotonGirar60, "BOTTOMLEFT", 0, -3)

-- Cambiar el color del texto a blanco
Set0GradosBoton:GetFontString():SetTextColor(1, 1, 1)

Set0GradosBoton:SetScript("OnClick", function()
    actualizarDatosTile()
    SendChatMessage(".gob rotate 0 0 0 ", "SAY")
end)




-- === Botón único para mostrar/ocultar ambas ventanas
local BotonToggleInclinacion = CreateFrame("Button", nil, TileTinkerWindow, "UIPanelButtonTemplate")
BotonToggleInclinacion:SetSize(90, 20)
BotonToggleInclinacion:SetText("Rotaciones")
BotonToggleInclinacion:SetPoint("TOPLEFT", TileTinkerWindow, "TOPLEFT", 60, -370)
BotonToggleInclinacion:SetScript("OnClick", function()
    local mostrar = not InclinacionVentana:IsShown()
    InclinacionVentana:SetShown(mostrar)
    RotacionesVentana:SetShown(mostrar)
    ActualizarLayout()
end)





-- ==========================================
-- ==========================================
--               SELECCIONES
-- ==========================================
-- ==========================================


-- === Ventana: Selecciones ===
local VentanaSelecciones = CreateFrame("Frame", "VentanaSelecciones", TileTinkerWindow, "BackdropTemplate")
VentanaSelecciones:SetSize(360, 40)
VentanaSelecciones:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
VentanaSelecciones:SetBackdropBorderColor(0.5, 0.5, 0.5)
VentanaSelecciones:SetBackdropColor(1, 1, 1, 0.8)
VentanaSelecciones:Hide()

local tituloSelecciones = VentanaSelecciones:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
tituloSelecciones:SetPoint("TOP", 0, -5)
tituloSelecciones:SetText("Selecciones:")

-- === Botón para mostrar/ocultar la ventana de selecciones ===
local BotonVentanaSelecciones = CreateFrame("Button", nil, TileTinkerWindow, "UIPanelButtonTemplate")
BotonVentanaSelecciones:SetSize(87, 20)
BotonVentanaSelecciones:SetText("Selecciones")
BotonVentanaSelecciones:SetPoint("TOP", BotonToggleInclinacion, "TOP", -88, 0)
BotonVentanaSelecciones:SetScript("OnClick", function()
    local mostrar = not VentanaSelecciones:IsShown()
    VentanaSelecciones:SetShown(mostrar)
    ActualizarLayout()
end)

-- === Botones dentro de VentanaSelecciones ===

-- Botón 1
local BotonSelecciones1 = CreateFrame("Button", nil, VentanaSelecciones, "UIPanelButtonTemplate")
BotonSelecciones1:SetSize(80, 20)
BotonSelecciones1:SetText("Select")
BotonSelecciones1:SetPoint("TOPLEFT", VentanaSelecciones, "TOPLEFT", 10, -10)

BotonSelecciones1:SetScript("OnClick", function()
    SendChatMessage(".gob sel", "SAY")
end)

-- Botón 2
local BotonSelecciones2 = CreateFrame("Button", nil, VentanaSelecciones, "UIPanelButtonTemplate")
BotonSelecciones2:SetSize(80, 20)
BotonSelecciones2:SetText("Unselect")
BotonSelecciones2:SetPoint("TOPLEFT", BotonSelecciones1, "TOPRIGHT", 5, 0)

BotonSelecciones2:SetScript("OnClick", function()
    SendChatMessage(".gob unsel", "SAY")
end)

-- Botón 3 con texto en rojo
local BotonSelecciones3 = CreateFrame("Button", nil, VentanaSelecciones, "UIPanelButtonTemplate")
BotonSelecciones3:SetSize(80, 20)
BotonSelecciones3:SetText("|cffff6666Delete|r")
BotonSelecciones3:SetPoint("TOPLEFT", BotonSelecciones2, "TOPRIGHT", 5, 0)

BotonSelecciones3:SetScript("OnClick", function()
    SendChatMessage(".gob del", "SAY")
end)

-- Botón 
local BotonSelecciones4 = CreateFrame("Button", nil, VentanaSelecciones, "UIPanelButtonTemplate")
BotonSelecciones4:SetSize(80, 20)
BotonSelecciones4:SetText("Sel Anterior")
BotonSelecciones4:SetPoint("TOPLEFT", BotonSelecciones3, "TOPRIGHT", 5, 0)

BotonSelecciones4:SetScript("OnClick", function()
	SendChatMessage(".gob sel " .. tileGUIDAnterior, "SAY")
end)

-- === Subventana: Replace ===
local SubventanaReplace = CreateFrame("Frame", "SubventanaReplace", VentanaSelecciones, "BackdropTemplate")
SubventanaReplace:SetSize(360, 63)
SubventanaReplace:SetPoint("TOPLEFT", VentanaSelecciones, "BOTTOMLEFT", 0, -5) -- Ajusta posición si lo necesitas
SubventanaReplace:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
SubventanaReplace:SetBackdropBorderColor(0.5, 0.5, 0.5)
SubventanaReplace:SetBackdropColor(1, 1, 1, 0.9)

-- Texto: "Gob Replace:"
local TextoReplace1 = SubventanaReplace:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
TextoReplace1:SetPoint("TOPLEFT", 10, -15)
TextoReplace1:SetText("Replace:")

local TextoReplace2 = SubventanaReplace:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
TextoReplace2:SetPoint("TOPLEFT", 10, -40)
TextoReplace2:SetText("Gob mass: ")

-- Botón 1
local BotonReplace1 = CreateFrame("Button", "BotonReplace1", SubventanaReplace, "UIPanelButtonTemplate")
BotonReplace1:SetSize(105, 20)
BotonReplace1:SetText("Remplazar este")
BotonReplace1:SetPoint("LEFT", TextoReplace1, "RIGHT", 3, 0)

BotonReplace1:SetScript("OnClick", function()
    actualizarDatosTile() -- Llama a la función que actualiza los datos del tile
    TileRemplazadoGUID = tileGUID -- Guarda el valor actual del tileGUID
	TileRemplazadoENTRY = tileEntryID
    print("Vas a reemplazar: " .. tostring(tileFileName))
end)

-- Botón 2
local BotonReplace2 = CreateFrame("Button", "BotonReplace2", SubventanaReplace, "UIPanelButtonTemplate")
BotonReplace2:SetSize(123, 20)
BotonReplace2:SetText("Remplazar por este")
BotonReplace2:SetPoint("LEFT", BotonReplace1, "RIGHT", 3, 0)

BotonReplace2:SetScript("OnClick", function()
    actualizarDatosTile() -- Llama a la función que actualiza los datos del tile
    TileRemplazadorGUID = tileEntryID -- Guarda el valor actual del tileGUID
    print("Vas a usar como remplazo: " .. tostring(tileFileName))
end)




-- Icono de información
local InfoIcon = CreateFrame("Frame", nil, SubventanaReplace)
InfoIcon:SetSize(25, 25)
InfoIcon:SetPoint("TOPLEFT", 330, 10)

local texture = InfoIcon:CreateTexture(nil, "ARTWORK")
texture:SetAllPoints()
texture:SetTexture("Interface\\COMMON\\help-i") -- Icono de info clásico de Blizzard

-- Tooltip al pasar el ratón por encima
InfoIcon:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Al hacer click en un botón, guardará el último objeto que seleccionaste.\nSi seleccionas [Remplazar Este], ese último objeto en gob sel será remplazado.\nLuego selecciona otro gob y [Remplazar por Este], y el de antes, al darle a aplicar, será reemplaazado por este nuevo.", nil, nil, nil, nil, true)
    GameTooltip:Show()
end)

InfoIcon:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

-- Variable para el estado del checkbox
EsGobMass = false

-- Casilla de verificación
local GobMassCasilla = CreateFrame("CheckButton", nil, SubventanaReplace, "UICheckButtonTemplate")
GobMassCasilla:SetPoint("LEFT", TextoReplace2, "RIGHT", -2, 0)
GobMassCasilla:SetSize(30, 30)
GobMassCasilla:SetChecked(false)

-- Comportamiento al hacer clic
GobMassCasilla:SetScript("OnClick", function(self)
    EsGobMass = self:GetChecked()
end)

local TextoReplace2 = SubventanaReplace:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
TextoReplace2:SetPoint("TOPLEFT", 115, -40)
TextoReplace2:SetText("Radio:")

-- Variable para el valor del radio
GobMassRadio = 1

-- Slider
local SliderGobMassRadio = CreateFrame("Slider", "SliderGobMassRadio", SubventanaReplace, "OptionsSliderTemplate")
SliderGobMassRadio:SetOrientation("HORIZONTAL")
SliderGobMassRadio:SetSize(120, 20)
SliderGobMassRadio:SetPoint("LEFT", TextoReplace2, "RIGHT", 10, 0)
SliderGobMassRadio:SetMinMaxValues(1, 200)
SliderGobMassRadio:SetValueStep(1)
SliderGobMassRadio:SetValue(GobMassRadio)
SliderGobMassRadio:Show()

-- Etiqueta del slider
SliderGobMassRadioLow:SetText(" ")
SliderGobMassRadioHigh:SetText(" ")
SliderGobMassRadioText:SetText(" ")

-- EditBox sincronizado
local EditBoxGobMassRadio = CreateFrame("EditBox", nil, SubventanaReplace, "InputBoxTemplate")
EditBoxGobMassRadio:SetSize(55, 20)
EditBoxGobMassRadio:SetPoint("LEFT", SliderGobMassRadio, "RIGHT", 10, 0)
EditBoxGobMassRadio:SetAutoFocus(false)
EditBoxGobMassRadio:SetNumeric(true)
EditBoxGobMassRadio:SetNumber(GobMassRadio)

-- Cuando se mueve el slider
SliderGobMassRadio:SetScript("OnValueChanged", function(self, value)
    GobMassRadio = math.floor(value + 0.5)
    EditBoxGobMassRadio:SetNumber(GobMassRadio)
end)

-- Cuando se edita el editbox
EditBoxGobMassRadio:SetScript("OnEnterPressed", function(self)
    local value = tonumber(self:GetText())
    if value and value >= 0 and value <= 200 then
        GobMassRadio = value
        SliderGobMassRadio:SetValue(value)
    else
        self:SetNumber(GobMassRadio) -- Restaurar si el valor no es válido
    end
    self:ClearFocus()
end)


-- Botón APLICAR REPLACE
local BotonReplace3 = CreateFrame("Button", "BotonReplace3", SubventanaReplace, "UIPanelButtonTemplate")
BotonReplace3:SetSize(50, 20)
BotonReplace3:SetText("Aplicar")
BotonReplace3:SetPoint("LEFT", BotonReplace2, "RIGHT", 3, 0)

BotonReplace3:SetScript("OnClick", function()
    -- Verificamos si EsGobMass es verdadero o falso
    if EsGobMass then
        -- Si EsGobMass es true, enviamos el comando con GobMassRadio
        if TileRemplazadoGUID and TileRemplazadorGUID then
            SendChatMessage(".gob mass replace " .. TileRemplazadoENTRY .. " " .. TileRemplazadorGUID .. " " .. GobMassRadio, "SAY")
        else
            print("ERROR: Falta seleccionar uno de los tiles.")
        end
    else
        -- Si EsGobMass es false, ejecutamos el comando normal
        if TileRemplazadoGUID and TileRemplazadorGUID then
            SendChatMessage(".gob sel " .. TileRemplazadoGUID, "SAY")
            SendChatMessage(".gob replace " .. TileRemplazadorGUID, "SAY")
        else
            print("ERROR: Falta seleccionar uno de los tiles.")
        end
    end
end)




-- ==========================================
-- ==========================================
--            FUNCIONES FINALES
-- ==========================================
-- ==========================================


-- ============================
-- === ACTUALIZAR LAYOUT ===
-- ============================
function ActualizarLayout()
    local baseY = -270
    local xOffset = 20

    -- Botón único en la parte superior izquierda
    BotonToggleTechoYEsquinas:SetPoint("TOPLEFT", TileTinkerWindow, "TOPLEFT", xOffset, baseY)

    -- Posiciones de las ventanas de techo y esquinas (en la misma fila)
    if HacerTechoVentana:IsShown() then
        HacerTechoVentana:SetPoint("TOPLEFT", BotonToggleTechoYEsquinas, "BOTTOMLEFT", 0, -5)
    end
    if EsquinasVentana:IsShown() then
        EsquinasVentana:SetPoint("TOPLEFT", HacerTechoVentana, "TOPRIGHT", 10, 0)
    end

    -- Posición del botón de inclinación, debajo de HacerTechoVentana (si está visible) o debajo del botón si no
    if HacerTechoVentana:IsShown() then
        BotonToggleInclinacion:SetPoint("TOPLEFT", HacerTechoVentana, "BOTTOMLEFT", 86, -5)
    else
        BotonToggleInclinacion:SetPoint("TOPLEFT", BotonToggleTechoYEsquinas, "BOTTOMLEFT", 86, -5)
    end

    -- Posición de la ventana de inclinación
    if InclinacionVentana:IsShown() then
        InclinacionVentana:SetPoint("TOPLEFT", BotonToggleInclinacion, "BOTTOMLEFT", -85, -5)
    end

    -- Posición de la ventana de rotaciones
    if RotacionesVentana:IsShown() then
        if InclinacionVentana:IsShown() then
            RotacionesVentana:SetPoint("TOPLEFT", InclinacionVentana, "TOPRIGHT", 10, 25)
        else
            RotacionesVentana:SetPoint("TOPLEFT", BotonToggleInclinacion, "BOTTOMLEFT", 0, -5)
        end
    end

    -- Posición de la ventana de selecciones
    if VentanaSelecciones:IsShown() then
        if InclinacionVentana:IsShown() then
            VentanaSelecciones:SetPoint("TOPLEFT", InclinacionVentana, "BOTTOMLEFT", 0, -17)
			tituloSelecciones:SetPoint("TOP", -140, 15)
			tituloSelecciones:Show()
        else
            VentanaSelecciones:SetPoint("TOPLEFT", BotonVentanaSelecciones, "BOTTOMLEFT", 0, -5)
			tituloSelecciones:Hide()
        end
    end

    -- Ajustar altura de la ventana principal
    local alturaTotal = baseY * -1
    if HacerTechoVentana:IsShown() then alturaTotal = alturaTotal + HacerTechoVentana:GetHeight() + 5 end
    alturaTotal = alturaTotal + BotonToggleInclinacion:GetHeight() + 55
    if InclinacionVentana:IsShown() then alturaTotal = alturaTotal + InclinacionVentana:GetHeight() + 15 end
    if VentanaSelecciones:IsShown() then alturaTotal = alturaTotal + VentanaSelecciones:GetHeight() + 60 end

    TileTinkerWindow:SetHeight(math.max(alturaTotal, alturaBaseTinker))
end

-- Llamada inicial para asegurar posición correcta
ActualizarLayout()




