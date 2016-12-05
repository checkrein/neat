--[[

    Author: checkrein
    License: GNU GPL v2
    
    Relevant API doc:
     http://new.awesomewm.org/apidoc/classes/screen.html

    Layout for specific GIMP setup
    Puts all gimp clients in a single row, additional items floating
    If no gimp clients falls back to another layout

    -----------------
    |   |   |       |
    |   |   |       |
    | X | X |   X   |
    |   |   |       |
    |   |   |       |
    -----------------


--]]


-- Environment
local beautiful = require("beautiful") -- Allows setting of gaps etc. in theme
local ipairs = ipairs -- Iterator function
local math = math -- Rounding, etc

local awful = require("awful")

-- layout.gimp
local gimp = {}
gimp.name = "gimp"


function gimp.arrange(p)

    -- Local access to clients in current tag
    local clients = p.clients
    local number_clients = #clients
    -- Local access to workarea - portion of screen where clients are placed
    local workarea = p.workarea

    -- Previous client properties
    local client_width_old = 0
    local client_x_old = 0

    -- Current client properties
    local client_width = 0
    local client_height = workarea.height
    local client_x = 0
    local client_y = 0

    local is_gimp = 0

    -- Determine number of gimp clients
    local gimp_count = 0
    for k, client in ipairs(clients) do
        if client.role ~= nil then
            if string.match( client.role, 'gimp' ) then
                gimp_count = gimp_count + 1
            end
        end
    end

    if gimp_count == 0 then
        -- No gimp clients then use another layout
        awful.layout.suit.tile.arrange(p)
    else
        -- Gimp clients are fixed size, all others floating

        -- Look at each client in the current tag
        for k, client in ipairs(clients) do
    
            -- Current client's border width
            local border = client.border_width
    
            is_gimp = 0
            if client.role ~= nil then
                if string.match( client.role, 'gimp' ) ~= '' then
                    is_gimp = 1
                end
            end
    
            if is_gimp == 1 then
                if client.role == 'gimp-image-window' then
                    client_width = workarea.width - 165 - 200
                elseif client.role == 'gimp-toolbox' then
                    client_width = 165
                elseif client.role == 'gimp-dock' then
                    client_width = 201
                end
    
                -- As are all next to each other
                client_x = client_x_old + client_width_old
    
                -- Determine geometry for current client
                local geo = {
                    -- Borders are outside the client window, so sizes must compensate
                    width = client_width - border * 2,
                    height = client_height - border * 2,
                    x = client_x,
                    y = client_y
                }
        
                -- Apply geometry to the current client
                client:geometry(geo)
        
                -- Store client properties for next loop
                client_width_old = client_width
                client_x_old = client_x
            else
                awful.client.floating.set(client, true)
            end
        end
    end
end


return gimp
