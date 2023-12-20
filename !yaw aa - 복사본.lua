-- ##### VARIABLES #####
local player_name = cheat.GetUserName(); 
local font_watermark = draw.CreateFont("Verdana", 13, 900);
local size_x, size_y = draw.GetScreenSize();
local vertical, horizontal = 30, 70;
local font_indicator = draw.CreateFont("Tahoma", 15, 1300); 

-- ##### REFERENCES #####
local ct2_reference = gui.Reference("SETTINGS"); 
local ct2_tab = gui.Tab(ct2_reference, "pasteware", "yaw aa.lua"); 
local ct2_box = gui.Groupbox(ct2_tab, "Welcome to PASTEWARE, ".. player_name .." !" , 10, 5, 300, 1);  
local ct2_enable = gui.Checkbox(ct2_box, "enable", "Enable Master", true); 

-- ##### YAW JITTER AND RANDOM YAW CONTROL #####
local ct2_yaw_random_control = gui.Groupbox(ct2_tab, "Yaw Jitter and Random Yaw Control", 320, 5, 300, 1); 
local ct2_yaw_jitter_enable = gui.Checkbox(ct2_yaw_random_control, "yaw_jitter_enable", "Yaw Jitter Enable", false)
local ct2_yaw_jitter_left = gui.Slider(ct2_yaw_random_control, "yaw_jitter_left", "Yaw Jitter Left", 45, 0, 90)
local ct2_yaw_jitter_right = gui.Slider(ct2_yaw_random_control, "yaw_jitter_right", "Yaw Jitter Right", 45, 0, 90)
local ct2_yaw_jitter_backward = gui.Checkbox(ct2_yaw_random_control, "yaw_jitter_backward", "Yaw Jitter Backward", false)
local ct2_yaw_jitter_speed = gui.Slider(ct2_yaw_random_control, "yaw_jitter_speed", "Yaw Jitter Speed (Ticks)", 1, 1, 32)
local ct2_random_yaw_enable = gui.Checkbox(ct2_yaw_random_control, "random_yaw_enable", "Random Yaw Enable", false)
local ct2_random_yaw_min = gui.Slider(ct2_yaw_random_control, "random_yaw_min", "Random Yaw Range", 90, 0, 180)
local ct2_random_yaw_backward = gui.Checkbox(ct2_yaw_random_control, "random_yaw_backward", "Random Yaw Backward", false)
local ct2_random_yaw_speed = gui.Slider(ct2_yaw_random_control, "random_yaw_speed", "Random Yaw Speed (Ticks)", 1, 1, 32)

-- ... [PREVIOUS VARIABLES AND REFERENCES] ...

-- ##### YAW JITTER AND RANDOM YAW FUNCTIONALITY #####
local last_jitter_change = 0
local jitter_direction = true

local function handleYawJitter()
    if ct2_enable:GetValue() and ct2_yaw_jitter_enable:GetValue() then
        local current_time = globals.TickCount()
        if current_time - last_jitter_change > ct2_yaw_jitter_speed:GetValue() then
            local left_value = ct2_yaw_jitter_backward:GetValue() and -(180 - ct2_yaw_jitter_left:GetValue()) or -ct2_yaw_jitter_left:GetValue()
            local right_value = ct2_yaw_jitter_backward:GetValue() and (180 - ct2_yaw_jitter_right:GetValue()) or ct2_yaw_jitter_right:GetValue()
            local yaw_value = jitter_direction and right_value or left_value
            gui.SetValue("rbot.antiaim.base", yaw_value)
            jitter_direction = not jitter_direction
            last_jitter_change = current_time
        end
    end
end

callbacks.Register("Draw", handleYawJitter)

-- ##### RANDOM YAW FUNCTIONALITY #####
local function handleRandomYaw()
    if ct2_enable:GetValue() and ct2_random_yaw_enable:GetValue() then
        local current_time = globals.TickCount()
        if current_time - last_jitter_change > ct2_random_yaw_speed:GetValue() then
            local yaw_range = ct2_random_yaw_min:GetValue()
            local yaw_min, yaw_max

            if ct2_random_yaw_backward:GetValue() then
                yaw_min = 180 - yaw_range
                yaw_max = 180 + yaw_range
                local random_yaw = math.random(yaw_min, yaw_max)
                if random_yaw > 180 then
                    random_yaw = random_yaw - 360
                elseif random_yaw < -179 then
                    random_yaw = random_yaw + 360
                end
                gui.SetValue("rbot.antiaim.base", random_yaw)
            else
                yaw_min = -yaw_range
                yaw_max = yaw_range
                local random_yaw = math.random(yaw_min, yaw_max)
                gui.SetValue("rbot.antiaim.base", random_yaw)
            end

            last_jitter_change = current_time
        end
    end
end

callbacks.Register("Draw", handleRandomYaw)

-- ##### SPIN ANTI-AIM FUNCTIONALITY #####
local last_spin_change = 0
local current_yaw = 0

local function handleSpinAntiAim()
    if ct2_enable:GetValue() and ct2_spin_enable:GetValue() then
        local current_time = globals.TickCount()
        if current_time - last_spin_change > ct2_spin_speed:GetValue() then
            current_yaw = (current_yaw + 10) % 360  -- Adjust 10 as per need for smoother or faster rotation
            if current_yaw > 180 then
                current_yaw = current_yaw - 360
            end
            gui.SetValue("rbot.antiaim.base", current_yaw)
            last_spin_change = current_time
        end
    end
end

callbacks.Register("Draw", handleSpinAntiAim)

-- ... [REST OF THE SCRIPT CODE] ...
