-----------------------------------------------------------------
-- @package     LuneraLITE
-- @author      Richard
-- @build       v1.4.0
-- @release     11.22.2015
-----------------------------------------------------------------

-----------------------------------------------------------------
-- [ TABLES ]
-----------------------------------------------------------------
Lunera = Lunera or {}
Lunera.Script = Lunera.Script or {}
Lunera.Script.Name = "LuneraLITE"
Lunera.Script.Author = "Richard"
Lunera.Script.Build = "1.4.0"
Lunera.Script.Released = "Nov 22, 2015"
Lunera.Script.Website = "https://scriptfodder.com/scripts/view/1621"

Lunera.Settings = Lunera.Settings or {}
Lunera.Language = Lunera.Language or {}

-----------------------------------------------------------------
-- [ AUTOLOADER ]
-----------------------------------------------------------------

local luaroot = "lunera"
local name = "Lunera"

local LuneraStartupHeader = {
    '\n\n',
    [[.................................................................... ]],
}

local LuneraStartupInfo = {
    [[[title]....... ]] .. Lunera.Script.Name .. [[ ]],
    [[[build]....... v]] .. Lunera.Script.Build .. [[ ]],
    [[[released].... ]] .. Lunera.Script.Released .. [[ ]],
    [[[author]...... ]] .. Lunera.Script.Author .. [[ ]],
    [[[website]..... ]] .. Lunera.Script.Website .. [[ ]],
}

local LuneraStartupFooter = {
    [[.................................................................... ]],
}

function Lunera:PerformCheck(func)
    if (type(func)=="function") then
        return true
    end
    return false
end

for k, i in ipairs( LuneraStartupHeader ) do 
    MsgC( Color( 255, 255, 0 ), i .. '\n' )
end

for k, i in ipairs( LuneraStartupInfo ) do 
    MsgC( Color( 255, 255, 255 ), i .. '\n' )
end

for k, i in ipairs( LuneraStartupFooter ) do 
    MsgC( Color( 255, 255, 0 ), i .. '\n\n' )
end

-----------------------------------------------------------------
-- [ SERVER-SIDE ACTIONS ]
-----------------------------------------------------------------

if SERVER then

    local fol = luaroot .. "/"
    local files, folders = file.Find(fol .. "*", "LUA")

    for k, v in pairs(files) do
        include(fol .. v)
    end

    for _, folder in SortedPairs(folders, true) do
        if folder == "." or folder == ".." then continue end

        for _, File in SortedPairs(file.Find(fol .. folder .. "/sh_*.lua", "LUA"), true) do
            MsgC(Color(255, 255, 0), "[" .. Lunera.Script.Name .. "] SHARED file: " .. File .. "\n")
            AddCSLuaFile(fol .. folder .. "/" .. File)
            include(fol .. folder .. "/" .. File)
        end
    end

    for _, folder in SortedPairs(folders, true) do
        if folder == "." or folder == ".." then continue end

        for _, File in SortedPairs(file.Find(fol .. folder .. "/sv_*.lua", "LUA"), true) do
            MsgC(Color(255, 255, 0), "[" .. Lunera.Script.Name .. "] SERVER file: " .. File .. "\n")
            include(fol .. folder .. "/" .. File)
        end
    end

    for _, folder in SortedPairs(folders, true) do
        if folder == "." or folder == ".." then continue end

        for _, File in SortedPairs(file.Find(fol .. folder .. "/cl_*.lua", "LUA"), true) do
            MsgC(Color(255, 255, 0), "[" .. Lunera.Script.Name .. "] CLIENT file: " .. File .. "\n")
            AddCSLuaFile(fol .. folder .. "/" .. File)
        end
    end

    for _, folder in SortedPairs(folders, true) do
        if folder == "." or folder == ".." then continue end

        for _, File in SortedPairs(file.Find(fol .. folder .. "/vgui_*.lua", "LUA"), true) do
            MsgC(Color(255, 255, 0), "[" .. Lunera.Script.Name .. "] CLIENT file: " .. File .. "\n")
            AddCSLuaFile(fol .. folder .. "/" .. File)
        end
    end

    MsgC(Color( 0, 255, 0 ), "\n..........................[ Lunera Loaded ].........................\n\n")

end

-----------------------------------------------------------------
-- [ CLIENT-SIDE ACTIONS ]
-----------------------------------------------------------------

if CLIENT then

    local root = "lunera" .. "/"
    local _, folders = file.Find(root .. "*", "LUA")

    for _, folder in SortedPairs(folders, true) do
        if folder == "." or folder == ".." then continue end

        for _, File in SortedPairs(file.Find(root .. folder .. "/sh_*.lua", "LUA"), true) do
            MsgC(Color(255, 255, 0), "[" .. Lunera.Script.Name .. "] SHARED file: " .. File .. "\n")
            include(root .. folder .. "/" .. File)
        end
    end

    for _, folder in SortedPairs(folders, true) do
        for _, File in SortedPairs(file.Find(root .. folder .. "/cl_*.lua", "LUA"), true) do
            MsgC(Color(255, 255, 0), "[" .. Lunera.Script.Name .. "] CLIENT file: " .. File .. "\n")
            include(root .. folder .. "/" .. File)
        end
    end

    for _, folder in SortedPairs(folders, true) do
        for _, File in SortedPairs(file.Find(root .. folder .. "/vgui_*.lua", "LUA"), true) do
            MsgC(Color(255, 0, 0), "[" .. Lunera.Script.Name .. "] VGUI file: " .. File .. "\n")
            include(root .. folder .. "/" .. File)
        end
    end

    MsgC(Color( 0, 255, 0 ), "\n..........................[ Lunera Loaded ].........................\n\n")

end

local function MOTDDraw(text)
    MsgC(Color( 0, 255, 0 ), "\n...........................[ Lunera MOTD ]..........................\n\n")
    MsgC(Color(255, 255, 255, 255), text)
    MsgC(Color( 0, 255, 0 ), "\n....................................................................\n\n")
end

local function MOTDFetch(html, len, headers, code)
    if not headers or headers.Status and string.sub(headers.Status, 1, 3) != "200" then 
        return 
    end
    MOTDDraw(html)
end

local function MOTDShow()
    http.Fetch("http://galileomanager.com/api/products/1621/motd-lte.txt", MOTDFetch, fn.Id)
end
timer.Simple(10, MOTDShow)