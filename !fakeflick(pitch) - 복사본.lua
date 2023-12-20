-- ##### VARIABLE #####
local script_name = "FakeFlick(pitch).lua"
local player_name = cheat.GetUserName()
local font_watermark = draw.CreateFont("Verdana", 13, 900)
local size_x, size_y = draw.GetScreenSize()
local vertical, horizontal = 30, 70
local font_indicator = draw.CreateFont("Tahoma", 15, 1300)

-- ##### REFERENCE #####
local ct2_reference = gui.Reference("SETTINGS")
local ct2_tab = gui.Tab(ct2_reference, "pasteware", "FakeFlick(pitch).lua")
local ct2_box = gui.Groupbox(ct2_tab, "Welcome to PASTEWARE, " .. player_name .. " !", 10, 5, 300, 1)
local ct2_enable = gui.Checkbox(ct2_box, "enable", "Enable Master", true)

-- ##### TAB KEYBINDS AND SLIDER #####
local ct2_keybind = gui.Groupbox(ct2_tab, "fake flick control", 320, 5, 300, 1)
ct2_keybind:SetDescription("Toggle/hold key")

-- ##### 추가: FAKE FLICK PITCH CHECKBOXES 및 슬라이더 #####
local ct2_fake_flick_pitch = gui.Checkbox(ct2_keybind, "fake_flick_pitch", "Fake Flick Pitch", false)
local ct2_flick_period_pitch = gui.Slider(ct2_keybind, "flick_period_pitch", "Flick Period Pitch", 2, 1, 128)
local ct2_invert_pitch = gui.Checkbox(ct2_keybind, "invert_pitch", "Invert Pitch", false)

local last_fake_flick_tick = 0

-- ##### MANUAL ANTI-AIM FUNCTIONALITY WITH USER-ADJUSTABLE FAKE FLICK PITCH #####
local function manual_aa_pitch_func()
    if ct2_enable:GetValue() then
        -- 기본 Pitch 값 설정
        local pitch_value = 1

        -- 사용자 조절 가능한 Fake Flick Pitch 로직
        local g_vars_tick = globals.TickCount()
        local period_pitch = ct2_flick_period_pitch:GetValue()

        if ct2_fake_flick_pitch:GetValue() then
            if g_vars_tick % period_pitch < 1 then
                -- 주기일 때 피치를 1 또는 2로 설정
                local pitch = ct2_invert_pitch:GetValue() and 1 or 2
                if last_fake_flick_tick ~= g_vars_tick then
                    gui.SetValue("rbot.antiaim.advanced.pitch", pitch)
                    last_fake_flick_tick = g_vars_tick
                end
            else
                -- 주기가 아닐 때 피치를 1 또는 2로 설정 (invert 적용)
                local pitch = ct2_invert_pitch:GetValue() and 2 or 1
                if last_fake_flick_tick ~= g_vars_tick then
                    gui.SetValue("rbot.antiaim.advanced.pitch", pitch)
                    last_fake_flick_tick = g_vars_tick
                end
            end
        else
            -- Fake Flick가 비활성화된 경우에는 피치를 건드리지 않습니다.
            last_fake_flick_tick = 0
        end
    end
end
callbacks.Register("Draw", manual_aa_pitch_func)
