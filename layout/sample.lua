--[[

    Author: checkrein
    License: GNU GPL v3
    
    Relevant API doc:
     http://new.awesomewm.org/apidoc/classes/screen.html

    Example custom layout file
    Puts all clients in a single row

--]]


-- Environment
local beautiful = require("beautiful") -- Allows setting of gaps etc. in theme
local ipairs = ipairs -- Iterator function
local math = math -- Rounding, etc


-- layout.sample
local sample = {}
sample.name = "sample"


function sample.arrange(p)

    -- Local access to clients in current tag
    local clients = p.clients
    local number_clients = #clients
    -- Local access to workarea - portion of screen where clients are placed
    local workarea = p.workarea

    -- Look at each client in the current tag
    for k, client in ipairs(clients) do

        -- Current client's border width
        local border = client.border_width

        -- Determine geometry for current client
        local geo = {
            -- Borders are outside the client window, so sizes must compensate
            width = 200 - border * 2,
            height = 200 - border * 2,
            x = 200 * k,
            y = 200
        }

        -- Apply geometry to the current client
        client:geometry(geo)

    end
end


return sample
