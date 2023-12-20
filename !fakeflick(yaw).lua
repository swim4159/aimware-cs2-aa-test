-- ##### VARIABLE #####
local player_name = cheat.GetUserName(); 
local font_watermark = draw.CreateFont("Verdana", 13, 900);
local size_x, size_y = draw.GetScreenSize();
local vertical, horizontal = 30, 70;
local font_indicator = draw.CreateFont("Tahoma", 15, 1300); 

-- ##### REFERENCE #####
local ct2_reference = gui.Reference("SETTINGS"); 
local ct2_tab = gui.Tab(ct2_reference, "paste ware", "FakeFlick(yaw).lua"); 
local ct2_box = gui.Groupbox(ct2_tab, "Welcome to PASTEWARE, ".. player_name .." !" , 10, 5, 300, 1);  
local ct2_enable = gui.Checkbox(ct2_box, "enable", "Enable Master", true); 

-- ##### TAB KEYBINDS AND SLIDER #####
local ct2_keybind = gui.Groupbox(ct2_tab, "Bindkeys", 320, 5, 300, 1); 
ct2_keybind:SetDescription("Toggle/hold key"); 
local ct2_manual_right = gui.Checkbox(ct2_keybind, "manual_right", "Manual Right AA", false);
local ct2_manual_left = gui.Checkbox(ct2_keybind, "manual_left", "Manual Left AA", false);
local ct2_default_yaw = gui.Slider(ct2_keybind, "default_yaw", "Default Yaw", 0, -180, 180)

-- ##### 추가: FAKE FLICK YAW CHECKBOXES 및 슬라이더 #####
local ct2_fake_flick = gui.Checkbox(ct2_keybind, "fake_flick", "Fake Flick Yaw", false)
local ct2_invert_flick = gui.Checkbox(ct2_keybind, "invert_flick", "Invert Flick Yaw", false)
local ct2_flick_period = gui.Slider(ct2_keybind, "flick_period", "Flick Period Yaw", 64, 1, 128)

--##### MANUAL ANTI-AIM FUNCTIONALITY WITH USER-ADJUSTABLE FAKE FLICK YAW #####
local function manual_aa_yaw_func()
    if ct2_enable:GetValue() then
        local current_right_value = ct2_manual_right:GetValue()
        local current_left_value = ct2_manual_left:GetValue()

        -- Right AA 및 Left AA 체크박스 로직
        if current_right_value then
            ct2_manual_left:SetValue(false)
        elseif current_left_value then
            ct2_manual_right:SetValue(false)
        end

        -- 기본 Yaw 값 설정
        local yaw_value = ct2_default_yaw:GetValue()
        if current_right_value then
            yaw_value = -90
        elseif current_left_value then
            yaw_value = 90
        end

        -- 사용자 조절 가능한 Fake Flick Yaw 로직
        local g_vars_tick = globals.TickCount()
        local period = ct2_flick_period:GetValue()
        if ct2_fake_flick:GetValue() and g_vars_tick % period < 1 then
            local flick_angle = ct2_invert_flick:GetValue() and -90 or 90
            gui.SetValue("rbot.antiaim.base", flick_angle)
        else
            gui.SetValue("rbot.antiaim.base", yaw_value)
        end
    end
end
callbacks.Register("Draw", manual_aa_yaw_func)

-- ... [기타 스크립트 코드] ...
