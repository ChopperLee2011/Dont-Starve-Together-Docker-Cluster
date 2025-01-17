--[[
Copyright (C) 2018, 2019 Zarklord

This file is part of Gem Core.

The source code of this program is shared under the RECEX
SHARED SOURCE LICENSE (version 1.0).
The source code is shared for referrence and academic purposes
with the hope that people can read and learn from it. This is not
Free and Open Source software, and code is not redistributable
without permission of the author. Read the RECEX SHARED
SOURCE LICENSE for details 
The source codes does not come with any warranty including
the implied warranty of merchandise. 
You should have received a copy of the RECEX SHARED SOURCE
LICENSE in the form of a LICENSE file in the root of the source
directory. If not, please refer to 
<https://raw.githubusercontent.com/Recex/Licenses/master/SharedSourceLicense/LICENSE.txt>
]]

local _G = GLOBAL

local MakeGemFunction, DeleteGemFunction = gemrun("gemfunctionmanager")

local MiscStuff = gemrun("tools/misc")

gemrun("memspikefix")
gemrun("tools/customtechtree")
gemrun("tools/krampednaughtiness")
gemrun("tools/componentspoofer")
gemrun("tools/soundmanager")
_G.GetNextTickPosition, _G.DoFakePhysicsWallMovement = gemrun("tools/physicscollisions")
_G.AddShardRPCHandler, _G.SendShardRPC, _G.SendShardRPCToServer = gemrun("tools/shardrpc")
_G.AddClientRPCHandler, _G.SendClientRPC = gemrun("tools/clientrpc")
local AddGetSet, RemoveGetSet = gemrun("tools/globalmetatable")

for k, v in pairs(MiscStuff.Global) do
	GLOBAL[k] = v
end

AddGetSet("TheLocalPlayer", function(t, n)
    return not _G.TheNet:IsDedicated() and _G.ThePlayer or nil
end, nil, true)

gemrun("globalpause_patches")
gemrun("worldseedhelper")

modimport("gemscripts/legacy_modmain")

MakeGemFunction("extendenvironment", function(functionname, env, ...)
    local gemrun = gemrun
    _G.setfenv(1, env)
    UpvalueHacker = gemrun("tools/upvaluehacker")
    LocalVariableHacker = gemrun("tools/localvariablehacker")
    bit = gemrun("bit")
    DebugPrint = gemrun("tools/misc").Global.DebugPrint
    DynamicTileManager = gemrun("tools/dynamictilemanager")
    AddShardRPCHandler = _G.AddShardRPCHandler
    AddClientRPCHandler = _G.AddClientRPCHandler
    if modname then
        gemrun("forcememspikefix", true)
        function GetModModConfigData(optionname, modmodname, ...)
            return _G.GetModModConfigData(optionname, modmodname, modname, ...)
        end
    else
        GetModModConfigData = _G.GetModModConfigData
    end
end, true)

--after initializing, run beta fixes.
if CurrentRelease.GreaterOrEqualTo("R09_ROT_SALTYDOG") then
    gemrun("betafixes")
end

local _InitializeModMain = _G.ModManager.InitializeModMain
function _G.ModManager:InitializeModMain(modname, env, mainfile, ...)
    if mainfile == "modmain.lua" then
        env.gemrun = gemrun
    end
    return _InitializeModMain(self, modname, env, mainfile, ...)
end

DeleteGemFunction("gemfunctionmanager")