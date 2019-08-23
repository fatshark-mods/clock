local mod = get_mod("Clock")
local lastDT = 0 --Track timestamps so we only update text once a second.
local IsTuesday = false --Track time of day so we can warn user about maintenance on Tuesdays.

DebugTextManager.output_screen_text_clock = function (self, text, text_size, time, color) --Slightly modified variant of original function.
	if script_data and script_data.disable_debug_draw then
		return
	end

	text_size = text_size or self._screen_text_size
	color = color or Vector3(255, 255, 255)
	local gui = self._gui
	local resolution = Vector2(RESOLUTION_LOOKUP.res_w, RESOLUTION_LOOKUP.res_h)
	
	local posx = math.round( (resolution.x / 100) * mod:get("posx"))
	local posy = math.round( (resolution.y / 100) * mod:get("posy"))
	
	local material = "gw_body_64"
	local font = "materials/fonts/" .. material
	local text_extent_min, text_extent_max = Gui.text_extents(gui, text, font, text_size)
	local text_w = text_extent_max[1] - text_extent_min[1]
	local text_h = text_extent_max[3] - text_extent_min[3]
	local bgr_margin = 10

	if posx < (text_w + bgr_margin * 4) then posx = (text_w + bgr_margin * 4)  end
	if posy < (text_h + bgr_margin * 4) then posy = (text_h + bgr_margin * 4)  end

	local text_position = Vector3(posx - (text_w + bgr_margin * 2), posy - (text_h + bgr_margin * 2), 11)
	local bgr_x = text_position.x - bgr_margin
	local bgr_y = text_position.y - bgr_margin
	local bgr_w = text_w + bgr_margin * 2
	local bgr_h = text_h + bgr_margin * 2
	local bgr_position = Vector3(bgr_x, bgr_y, 10)
	local bgr_size = Vector2(bgr_w, bgr_h)
	
	local bgcolor = Color(mod:get("backgroundopacity"), 0, 0, 0)
	
	if IsTuesday == true then bgcolor = Color(mod:get("backgroundopacity"), 230, 0, 0) end

	if self._screen_text_clock then
		Gui.update_text(gui, self._screen_text_clock.text_id, text, font, text_size, material, text_position, Color(mod:get("opacity"), color.x, color.y, color.z))
		Gui.update_rect(gui, self._screen_text_clock.bgr_id, bgr_position, bgr_size, bgcolor)

		self._screen_text_clock.time = self._time + (time or self._screen_text_time)
	else
		local screen_text = {
			text_id = Gui.text(gui, text, font, text_size, material, text_position, Color(color.x, color.y, color.z)),
			bgr_id = Gui.rect(gui, bgr_position, bgr_size, bgcolor),
			time = self._time + (time or self._screen_text_time)
		}
		self._screen_text_clock = screen_text
	end
end

--[[
	Callbacks
--]]

mod.update = function(dt) --Draw/update clock once a second IF the hud is visible.
	if mod:is_enabled() and Managers.time:time("game") ~= nil and Managers.time:time("game") > lastDT + 1 then
		local hudvisible = Managers.player:local_player().network_manager.matchmaking_manager._ingame_ui.ingame_hud._currently_visible_components ~= {}	
		if hudvisible == true then 
			Managers.state.debug_text:output_screen_text_clock( os.date(mod:get("format")), mod:get("fontsize"), nil, Vector3(mod:get("colorred"),mod:get("colorgreen"),mod:get("colorblue")), mod:get("opacity")) 
		end
		lastDT = Managers.time:time("game")				
	end
end

mod.on_game_state_changed = function(status, state) --Hack to make sure clock restarts correctly after map change.
	if (state == "StateIngame") then IsTuesday = tonumber(os.date('%w')) == 2 lastDT = 0 end
end

mod.on_disabled = function(is_first_call) --Hack to instantly disable clock.
	if Managers.state.debug_text._screen_text_clock ~= nil then
		Gui.destroy_text(Managers.state.debug_text._gui, Managers.state.debug_text._screen_text_clock.text_id)
		Gui.destroy_bitmap(Managers.state.debug_text._gui, Managers.state.debug_text._screen_text_clock.bgr_id)
		Managers.state.debug_text._screen_text_clock = nil
	end	
	script_data.disable_debug_draw = true
	lastDT = 0 
end

mod.on_setting_changed = function(setting_name) --Hack to instantly apply changes.
	if mod:is_enabled() then
		if Managers.state.debug_text._screen_text_clock ~= nil then
			Gui.destroy_text(Managers.state.debug_text._gui, Managers.state.debug_text._screen_text_clock.text_id)
			Gui.destroy_bitmap(Managers.state.debug_text._gui, Managers.state.debug_text._screen_text_clock.bgr_id)
			Managers.state.debug_text._screen_text_clock = nil
		end
		lastDT = 0
	end
end

mod.on_enabled = function(is_first_call) --Make sure everything we need is set.
	script_data.disable_debug_draw = false
	lastDT = 0 
end