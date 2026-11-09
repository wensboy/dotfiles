-- [[
-- @Author: wendisx
-- @Date: 2026-11-01
-- @Description: hyprland monitor configuration
-- ]]

-- See https://wiki.hypr.land/configuring/core/monitors/
-- `hyprctl monitors` to show monitors info

local monitors = hl.get_monitors()

for _, mon in ipairs(monitors) do
    hl.monitor({
        output = mon.name,
        mode = "preferred",
        position = "auto",
        scale = 1
    })
    
    if mon.name:match("^eDP") then
        hl.monitor({
            output = mon.name,
            mode = "preferred",
            position = "auto",
            scale = 1.2,
			bitdepth = 8,
        })
    end
end
