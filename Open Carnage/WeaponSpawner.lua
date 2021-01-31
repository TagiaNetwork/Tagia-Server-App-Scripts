-- Weapon Spawner
-- Version: 0.1
-- Uplodaed: OpenCarnage.net
-- Credits:
-- This script uses SAPP events. Example events.txt:
-- event_start $map:bloodgulch 'w8 2;cevent shotgun1'
-- event_custom $ename:shotgun1 'lua_call "WeaponSpawner" "spawnWeapon" "weap" "weapons" "shotgun" "shotgun" "97.73" "-155.51" "2.31";w8 32;cevent shotgun1'

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
            local primary_weapon = read_dword(player + 0x2F8 + 4*0)
            local secondary_weapon = read_dword(player + 0x2F8 + 4*1)

            if object_weapon == ObjectID or object_weapon == primary_weapon or object_weapon == secondary_weapon then
                return true
            else
                return false
            end
        end
    end
end

function spawnWeapon(k, t1, t2, t3, x, y, z)
    if object ~= nil and HasObject(object) ~= true then
        destroy_object(object)
    end
    object = spawn_object(k, t1 .. "\\" .. t2 .. "\\" .. t3 , x, y, z)
end
