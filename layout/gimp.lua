--[[

    Author: checkrein
    License: GNU GPL v3

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
local ipairs = ipairs -- Iterator function
local awful = require("awful") -- Client control

-- layout.gimp
local gimp = {}
gimp.name = "gimp"


function gimp.arrange(p)

    -- Local access to clients in current tag
    local clients = p.clients
    -- Local access to workarea - portion of screen where clients are placed
    local workarea = p.workarea

    -- Gimp window widths
    gimp_width_toolbox = 200
    gimp_width_dock = 200
    gimp_width_image = workarea.width - gimp_width_dock - gimp_width_toolbox

    -- Previous client properties
    local client_width_old = 0
    local client_x_old = 0

    -- Current client properties
    local client_width = 0
    local client_height = workarea.height
    local client_x = 0
    local client_y = 0

    -- Determine client lists
    local gimp_clients = {}
    local non_gimp_clients = {}
    for k, client in ipairs(clients) do
        if client.role ~= nil then
            if string.match( client.role, 'gimp' ) then
                table.insert(gimp_clients, client)
            else
                table.insert(non_gimp_clients, client)
            end
        end
    end

    if #gimp_clients == 0 then
        -- No gimp clients then use another layout
        -- Why can't this then be adjusted using the mouse?
        awful.layout.suit.tile.bottom.arrange(p)
    else
        -- Gimp clients are fixed sizes & tiling
        for k, client in ipairs(gimp_clients) do

            -- Unidentified gimp windows are set as floating
            local skip = 0

            -- Current client's border width
            local border = client.border_width

            if client.role == 'gimp-image-window' then
                client_width = gimp_width_image
                client_x = gimp_width_toolbox + gimp_width_dock
            elseif client.role == 'gimp-toolbox' then
                client_width = gimp_width_toolbox
                client_x = gimp_width_dock + border * 2
            elseif client.role == 'gimp-dock' then
                client_width = gimp_width_dock
                client_x = 0
            else
                awful.client.floating.set(client, true)
                skip = 1
            end

            if skip == 0 then
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
            end

        end


        -- Non-gimp clients should float
        for k, client in ipairs(non_gimp_clients) do
            awful.client.floating.set(client, true)
        end

    end
end


return gimp
