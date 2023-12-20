--##### VARIABLE #####
local player_name = cheat.GetUserName(); 
local font_watermark = draw.CreateFont("Verdana", 13, 900);
local size_x, size_y = draw.GetScreenSize();
local vertical, horizontal = 30, 70;
local font_indicator = draw.CreateFont("Tahoma", 15, 1300); 

--##### REFERENCE #####
local ct2_reference = gui.Reference("SETTINGS"); 
local ct2_tab = gui.Tab(ct2_reference, "pasteware", "pitch jitter.lua"); 
local ct2_box = gui.Groupbox(ct2_tab, "Welcome to PASTEWARE, ".. player_name .." !" , 10, 5, 300, 1);  
local ct2_enable = gui.Checkbox(ct2_box, "enable", "Master Enable", true); 

--##### PITCH JITTER CONTROL #####
local ct2_pitch_jitter_control = gui.Groupbox(ct2_tab, "Pitch Jitter Control", 320, 5, 300, 1); 
local ct2_pitch_jitter_enable = gui.Checkbox(ct2_pitch_jitter_control, "pitch_jitter_enable", "Enable Pitch Jitter", false)
local ct2_pitch_jitter_speed = gui.Slider(ct2_pitch_jitter_control, "pitch_jitter_speed", "Pitch Jitter Speed (Ticks)", 1, 1, 32)

--##### PITCH JITTER FUNCTIONALITY #####
local last_pitch_change = 0
local pitch_state = false

local function handlePitchJitter()
    if ct2_enable:GetValue() and ct2_pitch_jitter_enable:GetValue() then
        local current_time = globals.TickCount()

        if current_time - last_pitch_change > ct2_pitch_jitter_speed:GetValue() then
            local pitch_value = pitch_state and 1 or 2
            gui.SetValue("rbot.antiaim.advanced.pitch", pitch_value)
            pitch_state = not pitch_state
            last_pitch_change = current_time
        end
    end
end

callbacks.Register("Draw", handlePitchJitter)

-- ... [Other script code] ...
