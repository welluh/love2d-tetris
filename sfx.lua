sfx = {
    currentSound = ""
}

function sfx.load()
	sfx.theme = love.audio.newSource("assets/sfx/theme.mp3", "stream")
	sfx.theme:setLooping(true)
    sfx.theme:play()
	sfx.softDrop = love.audio.newSource("assets/sfx/soft_drop.mp3", "stream")
	sfx.hardDrop = love.audio.newSource("assets/sfx/hard_drop.mp3", "stream")
	sfx.clear = love.audio.newSource("assets/sfx/clear.mp3", "stream")
	sfx.rotate = love.audio.newSource("assets/sfx/rotate.mp3", "stream")
end

function sfx.play(event)
    local sound = sfx[event]

    if sound then
        sfx.stop(sfx.event)
        sound:play()
        sfx.currentSound = event
    end
end

function sfx.stop(event)
    local sound = sfx[event]

    if sound then
        love.audio.stop(sound)
    end
end
