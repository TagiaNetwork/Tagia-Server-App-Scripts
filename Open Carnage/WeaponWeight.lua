-- Weapon Weight
-- Version: 0.2
-- Uplodaed: OpenCarnage.net
-- Credits:
	-- Snagged the weapon tags from Backpack weapons by aLTis (https://opencarnage.net/index.php?/profile/1639-altis/)
	-- SetSpeedOfPlayer function from sprint script by Kavawuvi (https://opencarnage.net/index.php?/profile/1240-kavawuvi/)
	-- Tucker for OpenCarnage forums

--------------------
-- Configuration: --
--------------------

local enabled = true
local player_weight = 1 -- how heavy the player is by default

--------------------

api_version = "1.12.0.0"
ce, client_info_size = 0x40, 0xEC


local WEAPONS = {
    ["weapons\\assault rifle\\assault rifle"] = {["name"] = "ar", ["weight"] = "0.2"},
    ["weapons\\shotgun\\shotgun"] = {["name"] = "sg", ["weight"] = "0.3"},
    ["weapons\\sniper rifle\\sniper rifle"] = {["name"] = "sr", ["weight"] = "0.2"},
    ["weapons\\pistol\\pistol"] = {["name"] = "p", ["weight"] = "0"},
    ["weapons\\plasma pistol\\plasma pistol"] = {["name"] = "pp", ["weight"] = "0"},
    ["weapons\\needler\\mp_needler"] = {["name"] = "n", ["weight"] = "0.2"},
    ["weapons\\plasma rifle\\plasma rifle"] = {["name"] = "pr", ["weight"] = "0.2"},
    ["weapons\\rocket launcher\\rocket launcher"] = {["name"] = "rl", ["weight"] = "0.3"},
    ["weapons\\flamethrower\\flamethrower"] = {["name"] = "f", ["weight"] = "0"},
    ["weapons\\plasma_cannon\\plasma_cannon"] = {["name"] = "frg", ["weight"] = "0.3"},
    ["weapons\\gravity rifle\\gravity rifle"] = {["name"] = "ar", ["weight"] = "0.2"},
}


function OnScriptLoad()
    register_callback(cb["EVENT_JOIN"],"OnPlayerJoin")
    register_callback(cb["EVENT_LEAVE"],"OnPlayerLeave")
    register_callback(cb["EVENT_SPAWN"],"OnPlayerSpawn")
    register_callback(cb["EVENT_VEHICLE_ENTER"],"OnVehicleEnter")
    register_callback(cb["EVENT_VEHICLE_EXIT"],"OnVehicleExit")
    register_callback(cb["EVENT_TICK"],"OnTick")
    if halo_type == "PC" then execute_command("quit")end --play custom edition lul
end
function OnScriptUnload() end

inVehicle = {}

function OnPlayerJoin(PlayerIndex)
    inVehicle[PlayerIndex] = false
end

function OnPlayerLeave(PlayerIndex)
    inVehicle[PlayerIndex] = false
end

function OnVehicleEnter(PlayerIndex)
    inVehicle[PlayerIndex] = true
end

function OnVehicleExit(PlayerIndex)
    inVehicle[PlayerIndex] = false
end

function OnPlayerSpawn(PlayerIndex)
    SetSpeedOfPlayer(PlayerIndex, player_weight)
end

function SetSpeedOfPlayer(PlayerIndex,Speed)
    Speed = math.floor(Speed * 40 + 0.5) / 40
    local player = get_player(PlayerIndex)
    local player_speed = (read_float(get_player(PlayerIndex)) * 40 + 0.5) / 40
    if(player_speed ~= Speed) then
        write_float(get_player(PlayerIndex) + 0x6C, Speed)
    end
end
function GetName(object)
    if object ~= 0 then
        return read_string(read_dword(read_short(object) * 32 + 0x40440038))
    end
end



function OnTick()
    for PlayerIndex = 1,16 do
        if(player_alive(PlayerIndex) == true) then
            local player = get_dynamic_player(PlayerIndex)
            if player ~= nil and read_float(player + 0xE0) ~= 0 then
                local weapon_slot = read_byte(player + 0x2F2)
                local primary_weapon = get_object_memory(read_dword(player + 0x2F8 + 4*0))
                local secondary_weapon = get_object_memory(read_dword(player + 0x2F8 + 4*1))

                local primary_weapon_name = GetName(primary_weapon)
                local secondary_weapon_name = GetName(secondary_weapon)
                local weight = 0

                if primary_weapon_name ~= nil and lookup_tag("weap", primary_weapon_name) ~= nil and WEAPONS[primary_weapon_name]["name"] ~= nil then
                    weight = weight + WEAPONS[primary_weapon_name]["weight"]
                end

                if  secondary_weapon_name ~= nil and lookup_tag("weap", secondary_weapon_name) ~= nil and WEAPONS[secondary_weapon_name]["name"] ~= nil then
                    weight = weight + WEAPONS[secondary_weapon_name]["weight"]
                end

                if inVehicle[PlayerIndex] == false then
                    SetSpeedOfPlayer(PlayerIndex,player_weight - weight)
                end

            end
        end
    end
end
