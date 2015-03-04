require("libs.ScriptConfig")

config = ScriptConfig.new()
config:SetParameter("Aggro", "K")
config:SetParameter("UnAggro", "L")
config:Load()

function numpad( strkey )
        if strkey == "n0" then return 96
                elseif strkey == "n1" then return 97
                elseif strkey == "n2" then return 98
                elseif strkey == "n3" then return 99
                elseif strkey == "n4" then return 100
                elseif strkey == "n5" then return 101
                elseif strkey == "n6" then return 102
                elseif strkey == "n7" then return 103
                elseif strkey == "n8" then return 104
                elseif strkey == "n9" then return 105
                elseif strkey == "n*" then return 106
                elseif strkey == "n+" then return 107
                elseif strkey == "n-" then return 109
                elseif strkey == "n." then return 110
                elseif strkey == "n/" then return 111
                elseif strkey == "space" then return 32
                elseif string.len(strkey) > 2 or strkey == "" then return 124
                else return string.byte( strkey )
        end
end

aggro = numpad(config.Aggro)
unaggro = numpad(config.UnAggro)

registered = false

function Key(msg,code)
    if not client.connected or client.loading or client.console or client.chat then return end
    if not mp then
        mp = entityList:GetMyPlayer()
        return
    end
    if msg == KEY_UP then
        if mp.selection and mp.selection[1] and mp.selection[1].handle == entityList:GetMyHero().handle then
            if code == aggro then
                local enemies = entityList:FindEntities({type=LuaEntity.TYPE_HERO,illusion=false,visible=true,team=(5-mp.team)})
                if enemies and #enemies == 0 then
                    enemies = entityList:FindEntities({type=LuaEntity.TYPE_HERO,illusion=false,visible=false,team=(5-mp.team)})
                end
                NextAction(enemies[1],false)
            elseif code == unaggro then
                local allycreeps = entityList:FindEntities({classId=CDOTA_BaseNPC_Creep_Lane,team=mp.team})
                NextAction(allycreeps[1],true)
            end
        end
    end
end

function NextAction(target,unag)
    if not target then return end
    prev = {mp.orderId,mp.orderPosition,mp.target,mp.source}
    mp:Attack(target)
    mp:HoldPosition()
end



function Load()
    if registered then return end
    mp = nil
    script:RegisterEvent(EVENT_KEY,Key)
    registered = true
end

function Close()
    if not registered then return end
    script:UnregisterEvent(Key)
    mp = nil
    registered = false
end

script:RegisterEvent(EVENT_LOAD,Load)
script:RegisterEvent(EVENT_CLOSE,Close)

if client.connected and not client.loading then
    Load()
end
