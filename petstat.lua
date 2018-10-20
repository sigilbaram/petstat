local packets = require('packets')
local settings = require('settings')
local string = require('string')
local ui = require('ui')
local windower = require('windower')

local defaults = {
    text_color = ui.color.rgb(255,255,255,185),
    tp_full_color = ui.color.rgb(0,255,0,185),
    stroke_color = ui.color.rgb(0,0,0,185),
    mp_bar_color = ui.color.rgb(0xdd,0xf4,0x96)
}

local config = settings.load(defaults)

local pet_tp = 0
local pet_hp_percent = 0
local pet_mp_percent = 0

function packet_handler (packet)
    if not packet then
        return
    end

    if packet.pet_tp then
        pet_tp = packet.pet_tp
    end

    if packet.current_hp_percent then
        pet_hp_percent = packet.current_hp_percent
    end

    if packet.current_mp_percent then
        pet_mp_percent = packet.current_mp_percent
    end
end

--packets.incoming[0x067]:register(packet_handler)
packets.incoming[0x068]:register(packet_handler)

ui.display(function ()
    if pet_hp_percent > 0 then
        ui.size(54,5)
        ui.location(windower.settings.ui_size.width-191,
            windower.settings.ui_size.height-23)
        ui.progress(pet_mp_percent/100, {color=config.mp_bar_color})

        ui.location(windower.settings.ui_size.width-175,
            windower.settings.ui_size.height-41)
        ui.text(string.format(
            '[%s]{10pt Arial bold italic stroke:"1px %s" color:%s}',            tostring(pet_hp_percent),
            ui.color.tohex(config.stroke_color),
            ui.color.tohex(config.text_color)
        ))

        ui.location(windower.settings.ui_size.width-156,
            windower.settings.ui_size.height-31)
        ui.text(string.format(
            '[%s]{10pt Arial bold italic stroke:"1px %s" color:%s}',            tostring(pet_mp_percent),
            ui.color.tohex(config.stroke_color),
            ui.color.tohex(config.text_color)
        ))

        local color = config.text_color
        if pet_tp>=1000 then
            color = config.tp_full_color
        end
        ui.location(windower.settings.ui_size.width-240,
            windower.settings.ui_size.height-28)
        ui.text(string.format(
            '[%s]{8pt Arial bold italic stroke:"1px %s" color:%s}',            tostring(pet_tp),
            ui.color.tohex(config.stroke_color),
            ui.color.tohex(color)
        ))
    end
end)
