-- [[
-- @Author: wendisx
-- @Date: 2026-11-01
-- @Description: hyprland monitor configuration
-- ]]

-- See https://wiki.hypr.land/configuring/core/monitors/
-- `hyprctl monitors` to show monitors info

local function setup_monitors()
    local monitors = hl.get_monitors()
    if not monitors or #monitors == 0 then
        hl.exec_cmd("hyprctl reload")
        return
    end

    for _, mon in ipairs(monitors) do
        hl.monitor({
            output = mon.name,
            mode = "preferred",
            position = "auto",
            scale = 1
        })
    end
end

hl.on("monitor.added", setup_monitors)

setup_monitors()
