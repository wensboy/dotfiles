-- [[
-- @Author: wendisx
-- @Date: 2026-11-01
-- @Description: hyprland monitor configuration
-- ]]

-- See https://wiki.hypr.land/configuring/core/monitors/
-- `hyprctl monitors` to show monitors info

for _, mon in ipairs(hl.get_monitors()) do
    hl.monitor({
        output = mon.name,
        mode = "preferred",
        position = "auto",
        scale = 1,
        bitdepth = 8,
    })
end
