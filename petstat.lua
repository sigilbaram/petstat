local memory = require('memory')
local pet = require('pet')
local settings = require('settings')
local string = require('string')
local struct = require('struct')
local ui = require('ui')
local windower = require('windower')
local player = require('player')

local defaults = {
    text_color = ui.color.rgb(255,255,255,185),
    tp_full_color = ui.color.rgb(0,255,0,185),
    stroke_color = ui.color.rgb(0,0,0,185),
    mp_bar_color = ui.color.rgb(0xdd,0xf4,0x96),
    hp_bar_color = ui.color.rgb(0xff,0x9b,0x9b),
    name_color = ui.color.rgb(0xbf,0xfd,0xfd)
}

local config = settings.load(defaults)

-- This structure should be the the coordinates of the vanilla pet window or some piece of it anyway.
memory.pet_window = struct.struct({signature = '8B4F??6A016A01518B0D', static_offsets = {0x00}}, {
    x = {0x5C, struct.uint16},
    y = {0x5E, struct.uint16},
})

local window_state = {
    title = 'Pet Stat',
    style = 'normal',
    movable = true,
    resizable = false,
    width = 110,
    height = 30,
}

ui.display(function ()
    --[[
    local x = memory.pet_window.x
    local y = memory.pet_window.y
    window_state.x = x
    window_state.y = y-2
    ]]

    if pet.active and player.state.id ~= 4 then
        window_state = ui.window('petstat_window', window_state, function()
            
            ui.size(74,5)
            ui.location(24,10)            
            ui.progress(pet.hp_percent/100, {color=config.hp_bar_color})
            
            
            ui.location(0,0)
            ui.text(string.format(
                '[%s]{10pt Arial bold italic stroke:"1px %s" color:%s}',
                pet.name,
                ui.color.tohex(config.stroke_color),
                ui.color.tohex(config.name_color)
            ))
            
            ui.size(54,5)
            ui.location(49,17)
            ui.progress(pet.mp_percent/100, {color=config.mp_bar_color})

            ui.location(65,0)
            ui.text(string.format(
                '[%s]{10pt Arial bold italic stroke:"1px %s" color:%s}',
                tostring(pet.hp_percent),
                ui.color.tohex(config.stroke_color),
                ui.color.tohex(config.text_color)
            ))

            ui.location(84,10)
            ui.text(string.format(
                '[%s]{10pt Arial bold italic stroke:"1px %s" color:%s}',
                tostring(pet.mp_percent),
                ui.color.tohex(config.stroke_color),
                ui.color.tohex(config.text_color)
            ))

            local color = config.text_color
            if pet.tp>=1000 then
                color = config.tp_full_color
            end
            ui.location(0,13)
            ui.text(string.format(
                '[%s]{8pt Arial bold italic stroke:"1px %s" color:%s}',
                tostring(pet.tp),
                ui.color.tohex(config.stroke_color),
                ui.color.tohex(color)
            ))
        end)
    end
end)
