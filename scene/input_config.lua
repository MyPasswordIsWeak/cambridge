local ConfigScene = Scene:extend()

ConfigScene.title = "Input Config"

require 'load.save'

local configurable_inputs = {
	"left",
    "right",
    "up",
    "down",
	"rotate_left",
	"rotate_left2",
    "rotate_right",
    "rotate_right2",
    "rotate_180",
    "hold",
    "retry",
}

function ConfigScene:new()
	-- load current config
	self.config = config.input
	self.input_state = 1

	DiscordRPC:update({
        details = "In menus",
        state = "Changing input config",
    })
end

function ConfigScene:update()
end

function ConfigScene:render()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(
		backgrounds["input_config"],
		0, 0, 0,
		0.5, 0.5
	)

	love.graphics.setFont(font_3x5_2)
	for i, input in pairs(configurable_inputs) do
        love.graphics.printf(input, 40, 50 + i * 20, 200, "left")
		if config.input[input] then
			love.graphics.printf(
				love.keyboard.getKeyFromScancode(config.input[input]) .. " (" .. config.input[input] .. ")",
				240, 50 + i * 20, 200, "left"
			)
		end
	end
	if self.input_state > table.getn(configurable_inputs) then
		love.graphics.print("press enter to confirm, delete to retry")
	else
		love.graphics.print("press key for " .. configurable_inputs[self.input_state])
	end
end

function ConfigScene:onKeyPress(e)
	if self.input_state > table.getn(configurable_inputs) then
		if e.scancode == "return" then
			-- save, then load next scene
			saveConfig()
			scene = TitleScene()
		elseif e.scancode == "delete" or e.scancode == "backspace" then
			self.input_state = 1
		end
	else
        if e.scancode == "escape" then
            loadSave()
			scene = TitleScene()
        else
            config.input[configurable_inputs[self.input_state]] = e.scancode
            self.input_state = self.input_state + 1
        end
	end
end

return ConfigScene
