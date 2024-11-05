local http = require("gamesense/http")
local json = require("json")
local base64 = require("gamesense/base64")

local loaded_scripts = {}
local current_time = 0

local function get_current_time()
    return os.time()  
end

local function download_and_run(url)
    http.get(url, function(success, response)
        if success and response.status == 200 then
            local func, err = load(response.body)
            if func then
                local success, exec_err = pcall(func)
                if success then
                    print("Lua loaded and executed successfully.")
                else
                    print("Error executing Lua: " .. exec_err)
                end
            else
                print("Error loading Lua from: " .. url .. " - " .. err)
            end
        else
            print("Failed to download Lua. Status: " .. response.status)
        end
    end)
end

local function unload_script(script_name)
    if loaded_scripts[script_name] then
        loaded_scripts[script_name] = nil
        print(script_name .. " Lua unloaded successfully.")
        client.reload_active_scripts()
        print("Active scripts reloaded.")
        client.exec("play music/3kliksphilip_01/mainmenu")
    else
        print("No Lua to unload for " .. script_name)
    end
end

local scripts = {
    "\a7AFF67FF • \aFFFFFFFFBolt",
    "\a7AFF67FF • \aFFFFFFFFdivine",
    "\a7AFF67FF • \aFFFFFFFFWraith",
    "\a7AFF67FF • \aFFFFFFFFEcstasy",
    "\a7AFF67FF • \aFFFFFFFFAi Peek",
    "\a7AFF67FF • \aFFFFFFFFEtterance",
    "\a7AFF67FF • \aFFFFFFFFFeelSense",
    "\a7AFF67FF • \aFFFFFFFFInteritus",
    "\a7AFF67FF • \aFFFFFFFFInferno Beta",
    "\a7AFF67FF • \aFFFFFFFFHysteria 2.1",
    "\a7AFF67FF • \aFFFFFFFFLuaSense Beta",
    "\a7AFF67FF • \aFFFFFFFFAmbani Recode",
    "\a7AFF67FF • \aFFFFFFFFResolveX (chatgpt edition)",
    "\a7AFF67FF • \aFFFFFFFFAngelwings Debug 2.5",
    "\a7AFF67FF • \aFFFFFFFFGamesense.tools Alpha",
}

local script_urls = {
    ["\a7AFF67FF • \aFFFFFFFFWraith"] = "https://raw.githubusercontent.com/blacklicker59322/main/refs/heads/main/Wraith.lua",
    ["\a7AFF67FF • \aFFFFFFFFFeelSense"] = "https://raw.githubusercontent.com/blacklicker59322/main/refs/heads/main/feelsense_1.lua",
    ["\a7AFF67FF • \aFFFFFFFFResolveX (chatgpt edition)"]    = "https://raw.githubusercontent.com/blacklicker59322/main/refs/heads/main/ResolveXEnchanted.lua",
    ["\a7AFF67FF • \aFFFFFFFFHysteria 2.1"] = "https://raw.githubusercontent.com/blacklicker59322/main/refs/heads/main/hysteria2.1.lua",
    ["\a7AFF67FF • \aFFFFFFFFGamesense.tools Alpha"] = "https://raw.githubusercontent.com/blacklicker59322/main/refs/heads/main/Gamesensetools_alpha.lua",
    ["\a7AFF67FF • \aFFFFFFFFAngelwings Debug 2.5"]   = "https://raw.githubusercontent.com/blacklicker59322/main/refs/heads/main/Angelwingsdebug_latest.lua",
    ["\a7AFF67FF • \aFFFFFFFFAmbani Recode"] = "https://raw.githubusercontent.com/blacklicker59322/main/refs/heads/main/ambanirecode.lua",
    ["\a7AFF67FF • \aFFFFFFFFAi Peek"] = "https://raw.githubusercontent.com/blacklicker59322/main/refs/heads/main/autopeek%20(%20ai%20peek).lua",
    ["\a7AFF67FF • \aFFFFFFFFBolt"] = "https://raw.githubusercontent.com/blacklicker59322/main/refs/heads/main/bolt_lua_same_lua_as_perfects.lua",
    ["\a7AFF67FF • \aFFFFFFFFInferno Beta"] = "https://raw.githubusercontent.com/blacklicker59322/main/refs/heads/main/inferno-beta-gs.lua",
    ["\a7AFF67FF • \aFFFFFFFFLuaSense Beta"] = "https://raw.githubusercontent.com/blacklicker59322/main/refs/heads/main/luasense.lua",
    ["\a7AFF67FF • \aFFFFFFFFEtterance"]    = "https://raw.githubusercontent.com/blacklicker59322/main/refs/heads/main/etternace.lua",
    ["\a7AFF67FF • \aFFFFFFFFEcstasy"]    = "https://raw.githubusercontent.com/blacklicker59322/main/refs/heads/main/ecstasy.lua",
    ["\a7AFF67FF • \aFFFFFFFFDivine"]    = "https://raw.githubusercontent.com/blacklicker59322/main/refs/heads/main/divine_selfleak_upd.lua",
    ["\a7AFF67FF • \aFFFFFFFFInteritus"]    = "https://raw.githubusercontent.com/blacklicker59322/main/refs/heads/main/interitus.lua",
}

local name_ui = ui.new_label("LUA", "B", "\aFFFFFFFFCat Loader")

local steamname = panorama.open("CSGOHud").MyPersonaAPI.GetName()
local script_selection_listbox = ui.new_listbox("LUA", "B", " ", table.unpack(scripts))

local function load_or_unload_script()
    local selected_index = ui.get(script_selection_listbox) + 1
    local selected_script = scripts[selected_index]
    local selected_script_url = script_urls[selected_script]

    if selected_script_url then
        if loaded_scripts[selected_script] then
            unload_script(selected_script)
        else
            download_and_run(selected_script_url)
            loaded_scripts[selected_script] = true
            client.exec("play buttons/button3")
        end
    else
        print("Invalid Lua selection.")
    end
end

local load_unload = ui.new_button("LUA", "B", "\aA9A9A9FFLoad \aA9A9A9FF/ \aA9A9A9FFUnload ", load_or_unload_script)

local namesteam = ui.new_label("LUA", "B", "\aFFFFFFFFSteam Username : \a75AB6FFF" .. steamname)

client.set_event_callback("shutdown", function()
    for script_name in pairs(loaded_scripts) do
        unload_script(script_name)
    end
end)

local function update_time()
    current_time = current_time + 1
end

client.set_event_callback("on_timer", function()
    update_time()
end)

-- coded by deju & cat
