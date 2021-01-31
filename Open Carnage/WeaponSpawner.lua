-- Weapon Spawner
-- Version: 0.1
-- Uplodaed: OpenCarnage.net
-- Credits:

--------------------
-- Configuration: --
--------------------

local enabled = true

--------------------

api_version = "1.12.0.0"
ce, client_info_size = 0x40, 0xEC

function OnScriptLoad()
    if halo_type == "PC" then execute_command("quit")end --play custom edition lul
end
function OnScriptUnload() end

function HasObject(ObjectID)
    for PlayerIndex = 1,16 do
        if(player_alive(PlayerIndex) == true) then
            local player = get_dynamic_player(PlayerIndex)
            local object_weapon = read_dword(player + 0x118)
            if object_weapon == ObjectID then
                return true
            else
                return false
            end
        end
    end
end


function spawnWeapon()
    if object ~= nil and HasObject(object) ~= true then
        destroy_object(object)
    end
    object = spawn_object("weap", "weapons\\shotgun\\shotgun", 97.73, -155.51, 2.31)

    cprint("spawnWeapon() executed")
end
