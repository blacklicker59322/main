-- Define resolver settings in the "Rage" "Other" category
local paste = ui.new_label("Rage", "Other", "They Said Define a paste and I sent this")
local resolver_enabled = ui.new_checkbox("Rage", "Other", "Enable ResolveX")
local resolver_debug = ui.new_checkbox("Rage", "Other", "Resolver Logs")
local resolver_mode = ui.new_combobox("Rage", "Other", "Resolver Mode", "Standard", "Adaptive", "Experimental", "Advanced", "Complex", "Custom")
local resolver_iterations = ui.new_slider("Rage", "Other", "Enhanced Resolver Phases", 1, 10, 1, true, "", 1)
local resolver_complexity = ui.new_slider("Rage", "Other", "Resolver Complexity", 1, 100, 50, true, "", 1)

-- Cached data for resolver logic
local cached_yaw = {}
local cached_lby = {}
local player_states = {}
local shot_history = {}

-- Throttling parameters
local last_log_time = 0
local log_interval = 5 -- Time in seconds to wait before allowing new logs

-- Utility functions
local function normalize_angle(angle)
    while angle > 180 do angle = angle - 360 end
    while angle < -180 do angle = angle + 360 end
    return angle
end

local function calculate_delta(angle1, angle2)
    if angle1 == nil or angle2 == nil then
        return 0
    end
    return math.abs(normalize_angle(angle1 - angle2))
end

local function get_max_desync_delta(player)
    return (entity.get_prop(player, "m_flPoseParameter", 11) * 58) + 0.5
end

local function update_player_state(player)
    if not player_states[player] then
        player_states[player] = { shots_fired = 0, hits = 0, misses = 0, desync_detected = false, last_yaw = nil }
    end
end

local function get_player_name(player)
    return entity.get_player_name(player) or "Unknown"
end

local function log_debug(message)
    if ui.get(resolver_debug) then
        local current_time = globals.curtime()
        if (current_time - last_log_time) >= log_interval then
            client.log(message)
            last_log_time = current_time
        end
    end
end

local function log_resolver(player, mode, success)
    if ui.get(resolver_debug) then
        local player_name = get_player_name(player)
        local status = success and "successfully resolved" or "resolution failed"
        log_debug("Player: " .. player_name .. " Mode: " .. mode .. " " .. status)
    end
end

local function get_random_factor()
    return math.random() * ui.get(resolver_complexity) / 100
end

-- Resolver logic functions
local function resolve_standard(player)
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local player_lby = entity.get_prop(player, "m_flLowerBodyYawTarget")
    
    local yaw_delta = calculate_delta(player_yaw, cached_yaw[player])
    local lby_delta = calculate_delta(player_lby, cached_lby[player])
    
    if yaw_delta > 25 then -- Lowered threshold for better accuracy
        local new_yaw = normalize_angle(player_yaw + get_max_desync_delta(player))
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
        log_resolver(player, "Standard", true)
    else
        entity.set_prop(player, "m_angEyeAngles[1]", player_lby)
        log_resolver(player, "Standard", false)
    end
    
    cached_yaw[player] = player_yaw
    cached_lby[player] = player_lby
end

local function resolve_adaptive(player)
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local player_lby = entity.get_prop(player, "m_flLowerBodyYawTarget")
    
    local yaw_delta = calculate_delta(player_yaw, cached_yaw[player])
    local lby_delta = calculate_delta(player_lby, cached_lby[player])
    
    if yaw_delta > 25 then -- Lowered threshold for better accuracy
        local max_desync = get_max_desync_delta(player)
        local new_yaw = normalize_angle(player_yaw + max_desync)
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
        log_resolver(player, "Adaptive", true)
    else
        entity.set_prop(player, "m_angEyeAngles[1]", player_lby)
        log_resolver(player, "Adaptive", false)
    end
    
    cached_yaw[player] = player_yaw
    cached_lby[player] = player_lby
end

local function resolve_experimental(player)
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local player_lby = entity.get_prop(player, "m_flLowerBodyYawTarget")
    
    local yaw_delta = calculate_delta(player_yaw, cached_yaw[player])
    local lby_delta = calculate_delta(player_lby, cached_lby[player])
    
    if yaw_delta > 25 then -- Lowered threshold for better accuracy
        local max_desync = get_max_desync_delta(player)
        local iterations = ui.get(resolver_iterations)
        
        for i = 1, iterations do
            local new_yaw = normalize_angle(player_yaw + (i * (max_desync / iterations)))
            entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
        end
        log_resolver(player, "Experimental", true)
    else
        entity.set_prop(player, "m_angEyeAngles[1]", player_lby)
        log_resolver(player, "Experimental", false)
    end
    
    cached_yaw[player] = player_yaw
    cached_lby[player] = player_lby
end

local function resolve_advanced(player)
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local player_lby = entity.get_prop(player, "m_flLowerBodyYawTarget")
    local max_desync = get_max_desync_delta(player)
    local yaw_delta = calculate_delta(player_yaw, cached_yaw[player])
    local lby_delta = calculate_delta(player_lby, cached_lby[player])
    
    if yaw_delta > 25 then -- Lowered threshold for better accuracy
        local new_yaw = normalize_angle(player_yaw + max_desync * 0.75)
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
        log_resolver(player, "Advanced", true)
    elseif lby_delta > 25 then
        local new_yaw = normalize_angle(player_lby + max_desync * 0.75)
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
        log_resolver(player, "Advanced", true)
    else
        entity.set_prop(player, "m_angEyeAngles[1]", player_lby)
        log_resolver(player, "Advanced", false)
    end
    
    cached_yaw[player] = player_yaw
    cached_lby[player] = player_lby
end

local function resolve_complex(player)
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local player_lby = entity.get_prop(player, "m_flLowerBodyYawTarget")
    local max_desync = get_max_desync_delta(player)
    local yaw_delta = calculate_delta(player_yaw, cached_yaw[player])
    local lby_delta = calculate_delta(player_lby, cached_lby[player])
    local random_factor = get_random_factor()
    
    if yaw_delta > 25 then -- Lowered threshold for better accuracy
        local new_yaw = normalize_angle(player_yaw + max_desync * random_factor)
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
        log_resolver(player, "Complex", true)
    elseif lby_delta > 25 then
        local new_yaw = normalize_angle(player_lby + max_desync * random_factor)
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
        log_resolver(player, "Complex", true)
    else
        entity.set_prop(player, "m_angEyeAngles[1]", player_lby)
        log_resolver(player, "Complex", false)
    end
    
    cached_yaw[player] = player_yaw
    cached_lby[player] = player_lby
end

local function resolve_custom(player)
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local player_lby = entity.get_prop(player, "m_flLowerBodyYawTarget")
    local max_desync = get_max_desync_delta(player)
    local yaw_delta = calculate_delta(player_yaw, cached_yaw[player])
    local lby_delta = calculate_delta(player_lby, cached_lby[player])
    local random_factor = get_random_factor()
    
    if yaw_delta > 25 then -- Lowered threshold for better accuracy
        local new_yaw = normalize_angle(player_yaw + max_desync * random_factor)
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
        log_resolver(player, "Custom", true)
    elseif lby_delta > 25 then
        local new_yaw = normalize_angle(player_lby + max_desync * random_factor)
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
        log_resolver(player, "Custom", true)
    else
        local new_yaw = normalize_angle(player_yaw + (max_desync * random_factor / 2))
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
        log_resolver(player, "Custom", false)
    end
    
    cached_yaw[player] = player_yaw
    cached_lby[player] = player_lby
end

-- Main resolver function
local function resolver()
    if not ui.get(resolver_enabled) then
        return
    end
    
    local resolver_type = ui.get(resolver_mode)
    local players = entity.get_players(true)
    
    for _, player in ipairs(players) do
        if entity.is_alive(player) and not entity.is_dormant(player) and entity.is_enemy(player) then
            update_player_state(player)
            if resolver_type == "Standard" then
                resolve_standard(player)
            elseif resolver_type == "Adaptive" then
                resolve_adaptive(player)
            elseif resolver_type == "Experimental" then
                resolve_experimental(player)
            elseif resolver_type == "Advanced" then
                resolve_advanced(player)
            elseif resolver_type == "Complex" then
                resolve_complex(player)
            elseif resolver_type == "Custom" then
                resolve_custom(player)
            end
        end
    end
end

-- Event to trigger resolver
client.set_event_callback("paint", resolver)

-- Log initialization
client.log("Resolvex Loaded Have Fun!")
client.log("Last update 8/9/2024")

-- Function to track shots fired, hits, and misses
local function track_shots(player, event_type)
    if not player_states[player] then
        update_player_state(player)
    end

    if event_type == "fire" then
        player_states[player].shots_fired = player_states[player].shots_fired + 1
        log_debug(" Initialized Anti Aim Data and Shots fired by player : " .. get_player_name(player) .. " Total shots: " .. player_states[player].shots_fired)
    elseif event_type == "hit" then
        player_states[player].hits = player_states[player].hits + 1
        log_debug("Shots hit by player initialized data: " .. get_player_name(player) .. " Total hits: " .. player_states[player].hits)
    elseif event_type == "miss" then
        player_states[player].misses = player_states[player].misses + 1
        log_debug("Shot missed by player initialized data: " .. get_player_name(player) .. " Total misses: " .. player_states[player].misses)
    end
end






-- Watermark settings
local watermark_text = "ResolveX - Last update 8/9/2024"
local watermark_color = {255, 255, 255, 255} -- RGBA format (White color)
local watermark_padding = 10 -- Padding from the screen edges

-- Function to draw the watermark
local function draw_watermark()
    local screen_width, screen_height = client.screen_size()
    local text_width, text_height = renderer.measure_text(nil, watermark_text)
    
    -- Position the watermark at the top right corner
    local x = screen_width - text_width - watermark_padding
    local y = watermark_padding
    
    -- Draw the background box
    renderer.rectangle(x - 5, y - 5, text_width + 10, text_height + 10, 0, 0, 0, 150)
    
    -- Draw the watermark text
    renderer.text(x, y, watermark_color[1], watermark_color[2], watermark_color[3], watermark_color[4], nil, 0, watermark_text)
end

-- Event callback to draw the watermark every frame
client.set_event_callback("paint", draw_watermark)

-- Log initialization
client.log("ResolveX - 2024")

-- Event callbacks for tracking shots, hits, and misses
client.set_event_callback("weapon_fire", function(event)
    local player = client.userid_to_entindex(event.userid)
    if player then
        track_shots(player, "fire")
    end
end)

client.set_event_callback("player_hurt", function(event)
    local player = client.userid_to_entindex(event.userid)
    if player then
        track_shots(player, "hit")
    end
end)

client.set_event_callback("player_death", function(event)
    local player = client.userid_to_entindex(event.userid)
    if player then
        track_shots(player, "miss")
    end
end)

-- End of script
