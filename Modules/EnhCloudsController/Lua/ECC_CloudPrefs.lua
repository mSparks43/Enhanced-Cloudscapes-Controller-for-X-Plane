--[[

Lua module, required by AircraftHelper.lua
Licensed under the EUPL v1.2: https://eupl.eu/

]]
--[[

VARIABLES (local to this module)

]]
local ECC_Cld_DRefs = { }
local ECC_Cld_PluginInstalled = false   -- Check if cloud plugin is installed
local ECC_Cld_SubPages = {"Global Scalars","Clouds: Height","Clouds: Coverage","Clouds: Base Noise Ratios","Clouds: Detail Noise Ratios","Clouds: Density Multipliers","Atmospherics"}
local ECC_Cld_Subpage = 1
local ECC_Cld_AdvMode = false
--[[

MODULE INITIALIZATION

]]
-- Check if plugin is installed
if XPLMFindDataRef("enhanced_cloudscapes/cirrus/height") and XPLMFindDataRef("enhanced_cloudscapes/scattered/height")
and XPLMFindDataRef("enhanced_cloudscapes/broken/height") and XPLMFindDataRef("enhanced_cloudscapes/overcast/height")
and XPLMFindDataRef("enhanced_cloudscapes/stratus/height") then ECC_Cld_PluginInstalled = true end

--[[

DATAREFS (local to this module)

]]
-- Dataref table content: "1: dref name",2: Dref size",{3: Dref value(s)},"4: Dref title",{5: Dref default values},{6: Dref value range},{7: Copy of dref value range}
local ECC_Cld_DRefs = {
        {"enhanced_cloudscapes/cloud_map_scale",1,{},"Cloud Map Scale",{},{0,0.00001},{}},          -- #1 ,Default 0.000005
        {"enhanced_cloudscapes/base_noise_scale",1,{},"Base Noise Scale",{},{0,0.0001},{}},         -- #2 ,Default 0.000025
        {"enhanced_cloudscapes/detail_noise_scale",1,{},"Detail Noise Scale",{},{0,0.001},{}},      -- #3 ,Default 0.0002
        {"enhanced_cloudscapes/blue_noise_scale",1,{},"Blue Noise Scale",{},{0,0.1},{}},            -- #4 ,Default 0.01
        {"enhanced_cloudscapes/cirrus/height",1,{},"Cirrus Layer Height",{},{0,10000},{}},          -- #5 ,Default 2500.0
        {"enhanced_cloudscapes/scattered/height",1,{},"Scattered Layer Height",{},{0,10000},{}},    -- #6 ,Default 4000.0
        {"enhanced_cloudscapes/broken/height",1,{},"Broken Layer Height",{},{0,10000},{}},          -- #7 ,Default 5000.0
        {"enhanced_cloudscapes/overcast/height",1,{},"Overcast Layer Height",{},{0,10000},{}},      -- #8 ,Default 5000.0
        {"enhanced_cloudscapes/stratus/height",1,{},"Stratus Layer Height",{},{0,10000},{}},        -- #9 ,Default 6000.0
        {"enhanced_cloudscapes/cirrus/coverage",1,{},"Cirrus Layer Coverage",{},{0,1.0},{}},        -- #10,Default 0.375
        {"enhanced_cloudscapes/scattered/coverage",1,{},"Scattered Layer Coverage",{},{0,1.0},{}},  -- #11,Default 0.75
        {"enhanced_cloudscapes/broken/coverage",1,{},"Broken Layer Coverage",{},{0,1.0},{}},        -- #12,Default 0.85
        {"enhanced_cloudscapes/overcast/coverage",1,{},"Overcast Layer Coverage",{},{0,1.0},{}},    -- #13,Default 0.95
        {"enhanced_cloudscapes/stratus/coverage",1,{},"Stratus Layer Coverage",{},{0,1.0},{}},      -- #14,Default 1.0
        {"enhanced_cloudscapes/cirrus/base_noise_ratios",3,{},"Cirrus Base Noise Ratios",{},{0,1.0},{}},         -- #15,Defaults 0.625, 0.25, 0.125
        {"enhanced_cloudscapes/scattered/base_noise_ratios",3,{},"Scattered Base Noise Ratios",{},{0,1.0},{}},   -- #16,Defaults 0.625, 0.25, 0.125
        {"enhanced_cloudscapes/broken/base_noise_ratios",3,{},"Broken Base Noise Ratios",{},{0,1.0},{}},         -- #17,Defaults 0.625, 0.25, 0.125
        {"enhanced_cloudscapes/overcast/base_noise_ratios",3,{},"Overcast Base Noise Ratios",{},{0,1.0},{}},     -- #18,Defaults 0.625, 0.25, 0.125
        {"enhanced_cloudscapes/stratus/base_noise_ratios",3,{},"Stratus Base Noise Ratios",{},{0,1.0},{}},       -- #19,Defaults 0.625, 0.25, 0.125
        {"enhanced_cloudscapes/cirrus/detail_noise_ratios",3,{},"Cirrus Detail Noise Ratios",{},{0,1.0},{}},        -- #20,Defaults 0.25, 0.125, 0.0625
        {"enhanced_cloudscapes/scattered/detail_noise_ratios",3,{},"Scattered Detail Noise Ratios",{},{0,1.0},{}},  -- #21,Defaults 0.625, 0.25, 0.125
        {"enhanced_cloudscapes/broken/detail_noise_ratios",3,{},"Broken Detail Noise Ratios",{},{0,1.0},{}},        -- #22,Defaults 0.625, 0.25, 0.125
        {"enhanced_cloudscapes/overcast/detail_noise_ratios",3,{},"Overcast Detail Noise Ratios",{},{0,1.0},{}},    -- #23,Defaults 0.625, 0.25, 0.125
        {"enhanced_cloudscapes/stratus/detail_noise_ratios",3,{},"Stratus Detail Noise Ratios",{},{0,1.0},{}},      -- #24,Defaults 0.625, 0.25, 0.125
        {"enhanced_cloudscapes/cirrus/density_multiplier",1,{},"Cirrus Density Multiplier",{},{0,0.01},{}},             -- #25,Default 0.0015
        {"enhanced_cloudscapes/scattered/density_multiplier",1,{},"Scattered Density Multiplier",{},{0,0.01},{}},       -- #26,Default 0.0035
        {"enhanced_cloudscapes/broken/density_multiplier",1,{},"Broken Density Multiplier",{},{0,0.01},{}},             -- #27,Default 0.004
        {"enhanced_cloudscapes/overcast/density_multiplier",1,{},"Overcast Density Multiplier",{},{0,0.01},{}},         -- #28,Default 0.004
        {"enhanced_cloudscapes/stratus/density_multiplier",1,{},"Stratus Density Multiplier",{},{0,0.01},{}},           -- #29,Default 0.0045
        {"enhanced_cloudscapes/sun_gain",1,{},"Sun Gain",{},{0,10.0},{}},                                  -- #30,Default 3.25
        {"enhanced_cloudscapes/ambient_tint",3,{},"Ambient Tint",{},{0,10.0},{}},                          -- #31,Defaults 1.0, 1.0, 1.0
        {"enhanced_cloudscapes/ambient_gain",1,{},"Ambient Gain",{},{0,10.0},{}},                          -- #32,Default 1.5
        {"enhanced_cloudscapes/forward_mie_scattering",1,{},"Forward Mie Scattering",{},{0,1.0},{}},       -- #33,Default 0.85
        {"enhanced_cloudscapes/backward_mie_scattering",1,{},"Backward Mie Scattering",{},{0,1.0},{}},     -- #34,Default 0.25
        {"enhanced_cloudscapes/atmosphere_bottom_tint",3,{},"Atmosphere Bottom Tint",{},{0,1.0},{}},       -- #35,Defaults 0.55, 0.775, 1.0
        {"enhanced_cloudscapes/atmosphere_top_tint",3,{},"Atmosphere Top Tint",{},{0,1.0},{}},             -- #36,Defaults 0.45, 0.675, 1.0
        {"enhanced_cloudscapes/atmospheric_blending",1,{},"Atmospheric Blending",{},{0,1.0},{}},           -- #37,Default 0.675    
    }
--[[

FUNCTIONS

]]
--[[ Dataref accessor ]]
function ECC_AccessDref(intable,mode)
    for i=1,#intable do
        local dref = XPLMFindDataRef(intable[i][1])
        if intable[i][2] == 1 then
            if mode == "read" then intable[i][3][0] = XPLMGetDataf(dref) end
            --print(i.." : "..intable[i][3][0]) 
            if mode == "write" then XPLMSetDataf(dref,intable[i][3][0]) end
        else
            if mode == "read" then intable[i][3] = XPLMGetDatavf(dref,0,intable[i][2]) end
            --print(i.." : "..table.concat(intable[i][3],", ",0))
            if mode == "write" then XPLMSetDatavf(dref, intable[i][3],0,intable[i][2]) end
       end
    end
end
--[[ Copy default values ]]
function ECC_CopyDefaults(intable)
    for i=1,#intable do
        -- Dataref values
        for j=0,#intable[i][3] do
            intable[i][5][j] = intable[i][3][j] 
        end
        --print(i.." : "..table.concat(intable[i][5],", ",0))
        -- Value range
        for k=1,#intable[i][6] do
            intable[i][7][k] = intable[i][6][k] 
        end
        --print(i.." : "..table.concat(intable[i][7],", ",1))
    end
end


--[[ Display a notification (and log it) if the EC plugin was found or not ]]
function ECC_PluginStatusNotification()
    if ECC_Cld_PluginInstalled then
        ECC_Notification("PLUGIN FIND SUCCESS: Enhanced Cloudscapes plugin found!","Success","log")
    else
        ECC_Notification("PLUGIN FIND ERROR: Enhanced Cloudscapes plugin not installed!","Error","log")
    end
end
--[[ Convert a floating number to a percentage ]]
function ECC_FloatToPercent(input,limitlow,limithigh)
    local output_pct = 0
    output_pct = (input / (limithigh - limitlow)) * 100
    return output_pct
end
--[[ Convert a percentage to a floating number ]]
function ECC_PercentToFloat(input,limitlow,limithigh)
    output_float = (input * (limithigh - limitlow)) / 100
    return output_float
end
-- 
function ECC_InputElements(index,subindex,mode,unit,displayformat)
    imgui.PushItemWidth(ECC_Preferences.AAA_Window_W - 165)
    if mode == "percent" then
        -- Slider in percentage
        local changed,buffer = imgui.SliderFloat(unit.."##"..index..subindex,ECC_FloatToPercent(ECC_Cld_DRefs[index][3][subindex],ECC_Cld_DRefs[index][6][1],ECC_Cld_DRefs[index][6][2]),0,100,displayformat)
        if changed then ECC_Cld_DRefs[index][3][subindex] = ECC_PercentToFloat(buffer,ECC_Cld_DRefs[index][6][1],ECC_Cld_DRefs[index][6][2]) buffer = nil end
    elseif mode == "numeric" then
        local changed,buffer = imgui.SliderFloat(unit.."##"..index..subindex,ECC_Cld_DRefs[index][3][subindex],ECC_Cld_DRefs[index][6][1],ECC_Cld_DRefs[index][6][2],displayformat)
        if changed then ECC_Cld_DRefs[index][3][subindex] = buffer buffer = nil end
    end
    imgui.PopItemWidth() imgui.SameLine()
    --
    imgui.PushItemWidth(50)
    if mode == "percent" then
        local changed,buffer = imgui.InputText("##"..index..subindex, ECC_FloatToPercent(ECC_Cld_DRefs[index][3][subindex],ECC_Cld_DRefs[index][6][1],ECC_Cld_DRefs[index][6][2]),9)  
        if changed and buffer ~= "" and tonumber(buffer) then
            if tonumber(buffer) < 0 then ECC_Cld_DRefs[index][3][subindex] = ECC_PercentToFloat(0,ECC_Cld_DRefs[index][6][1],ECC_Cld_DRefs[index][6][2])
            elseif tonumber(buffer) > 100 then ECC_Cld_DRefs[index][3][subindex] = ECC_PercentToFloat(100,ECC_Cld_DRefs[index][6][1],ECC_Cld_DRefs[index][6][2])
            else ECC_Cld_DRefs[index][3][subindex] = ECC_PercentToFloat(tonumber(buffer),ECC_Cld_DRefs[index][6][1],ECC_Cld_DRefs[index][6][2]) end
            buffer = nil 
        end
    elseif mode == "numeric" then
       local changed,buffer = imgui.InputText("##"..index..subindex, ECC_Cld_DRefs[index][3][subindex],9)
        if changed and buffer ~= "" and tonumber(buffer) then
            if tonumber(buffer) < ECC_Cld_DRefs[index][6][1] then ECC_Cld_DRefs[index][3][subindex] = ECC_Cld_DRefs[index][6][1]
            elseif tonumber(buffer) > ECC_Cld_DRefs[index][6][2] then ECC_Cld_DRefs[index][3][subindex] = ECC_Cld_DRefs[index][6][2]
            else ECC_Cld_DRefs[index][3][subindex] = tonumber(buffer) end
            buffer = nil 
        end
    end
    imgui.SameLine() imgui.TextUnformatted(unit) imgui.SameLine()
    imgui.PopItemWidth()
    if imgui.Button("Reset ##"..index..subindex,50,20) then ECC_Cld_DRefs[index][3][subindex] = ECC_Cld_DRefs[index][5][subindex] end
end
--[[ 

INITIALIZATION

]]
if ECC_Cld_PluginInstalled then
    --[[ Read dataref values ]]
    ECC_AccessDref(ECC_Cld_DRefs,"read")
    --[[ Note default dataref values ]]
    ECC_CopyDefaults(ECC_Cld_DRefs)
end

--[[

IMGUI WINDOW ELEMENT

]]
function ECC_Win_CloudPrefs()
    --[[ Obtain and store window information ]]
    ECC_GetWindowInfo()
    --[["Plugin not installed" warning ]]
    if not ECC_Cld_PluginInstalled then
        imgui.PushStyleColor(imgui.constant.Col.Text, ECC_ImguiColors[4]) imgui.TextUnformatted("\"Enchanced Cloudscapes\" plugin is not installed!") imgui.PopStyleColor()       
    else
        --[[ Read datarefs ]]
        ECC_AccessDref(ECC_Cld_DRefs,"read")
        --[[ Begin subwindow ]]
        if ECC_Preferences.Window_Page == 0 then
            --[[Parameter subpage dropdown selector]]
            imgui.TextUnformatted("Select a parameter group:")
            imgui.Dummy((ECC_Preferences.AAA_Window_W-15),5)
            imgui.PushItemWidth(ECC_Preferences.AAA_Window_W - 15)
            if imgui.BeginCombo("##1",ECC_Cld_SubPages[ECC_Cld_Subpage]) then
                for i = 1, #ECC_Cld_SubPages do
                    if imgui.Selectable(ECC_Cld_SubPages[i], ECC_Cld_Subpage == i) then
                        ECC_Cld_Subpage = i
                    end
                end
                imgui.EndCombo()
            end
            imgui.PopItemWidth()
            -- Parameters for the displayed dref section: start index, end index, mode
            local ECC_SectionParams = {0,0,nil,nil,nil}
            if ECC_Cld_Subpage == 1 then ECC_SectionParams = {1,4,"percent","%","%.1f"} end
            if ECC_Cld_Subpage == 2 then ECC_SectionParams = {5,9,"numeric","m","%.1f"} end
            if ECC_Cld_Subpage == 3 then ECC_SectionParams = {10,14,"percent","%","%.1f"} end
            if ECC_Cld_Subpage == 4 then ECC_SectionParams = {15,19,"numeric"," ","%.4f"} end
            if ECC_Cld_Subpage == 5 then ECC_SectionParams = {20,24,"numeric"," ","%.4f"} end
            if ECC_Cld_Subpage == 6 then ECC_SectionParams = {25,29,"percent","%","%.1f"} end
            if ECC_Cld_Subpage == 7 then ECC_SectionParams = {30,37,"percent","%","%.1f"} end
            -- Loop thorugh the selected section of the dataref table
            for j=ECC_SectionParams[1],ECC_SectionParams[2] do
                --imgui.PushID(j)
                imgui.Dummy((ECC_Preferences.AAA_Window_W-15),15)
                -- Caption
                imgui.TextUnformatted(ECC_Cld_DRefs[j][4]..":")
                --
                for k=0,#ECC_Cld_DRefs[j][3] do
                    ECC_InputElements(j,k,ECC_SectionParams[3],ECC_SectionParams[4],ECC_SectionParams[5])
                end       
                --Advanced: Text input for value range limit
                if ECC_Cld_AdvMode then
                    imgui.TextUnformatted("Lower Raw Value Limit: ") imgui.SameLine()
                    imgui.PushItemWidth(100)
                    local changed,buffer = imgui.InputText("##Lo"..j, ECC_Cld_DRefs[j][6][1], 20) imgui.SameLine()
                    if changed and buffer ~= "" and tonumber(buffer) then ECC_Cld_DRefs[j][6][1] = tonumber(buffer) buffer = nil end
                    imgui.PopItemWidth()
                    if imgui.Button("Reset ##Lo"..j,50,20) then ECC_Cld_DRefs[j][6][1] = ECC_Cld_DRefs[j][7][1] end
                    imgui.TextUnformatted("Upper Raw Value Limit: ") imgui.SameLine()
                    imgui.PushItemWidth(100)
                    local changed,buffer = imgui.InputText("##Hi"..j, ECC_Cld_DRefs[j][6][2], 20) imgui.SameLine()
                    if changed and buffer ~= "" and tonumber(buffer) then ECC_Cld_DRefs[j][6][2] = tonumber(buffer) buffer = nil end
                    imgui.PopItemWidth()
                    if imgui.Button("Reset ##Hi"..j,50,20) then ECC_Cld_DRefs[j][6][2] = ECC_Cld_DRefs[j][7][2] end
                end
                --imgui.PopID()
            -- End loop
            end
        --[[ End subwindow ]]
        end
        imgui.Dummy((ECC_Preferences.AAA_Window_W-15),20)
        --"Advanced" button
        local changed, newECC_Cld_AdvMode = imgui.Checkbox("Adjust value ranges", ECC_Cld_AdvMode)
        if changed then ECC_Cld_AdvMode = newECC_Cld_AdvMode end
        --if imgui.Button("Advanced Settings",(ECC_Preferences.AAA_Window_W-15),20) then if not ECC_Cld_AdvMode then ECC_Cld_AdvMode = true else ECC_Cld_AdvMode = false end end
        --[[ Write datarefs ]]
        ECC_AccessDref(ECC_Cld_DRefs,"write")
    end
    imgui.Dummy((ECC_Preferences.AAA_Window_W-15),20)
end
