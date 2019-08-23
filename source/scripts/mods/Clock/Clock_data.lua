local mod = get_mod("Clock")

return {
	name = "Clock",
	description = mod:localize("mod_description"),
	is_togglable = true,
	is_mutator = false,
	mutator_settings = {},
	options = {
		collapsed_widgets = {},
		widgets = {
			{
			  setting_id      = "fontsize",
			  type          = "numeric",
			  default_value = 24,
			  range           = {12, 64},  
			},		
			{
			  setting_id      = "posx",
			  type          = "numeric",
			  default_value = 100,
			  range           = {0, 100},  
			},	
			{
			  setting_id      = "posy",
			  type          = "numeric",
			  default_value = 100,
			  range           = {0, 100},  
			},	
			{
			  setting_id      = "colorred",
			  type          = "numeric",
			  default_value = 230,
			  range           = {0, 255},  
			},
			{			
			  setting_id      = "colorgreen",
			  type          = "numeric",
			  default_value = 230,
			  range           = {0, 255},  
			},	
			{
			  setting_id      = "colorblue",
			  type          = "numeric",
			  default_value = 230,
			  range           = {0, 255},  
			},
			{
			  setting_id      = "opacity",
			  type          = "numeric",
			  default_value = 255,
			  range           = {0, 255},  
			},
			{				
			  setting_id      = "backgroundopacity",
			  type          = "numeric",
			  default_value = 120,
			  range           = {0, 255},  
			},	
			{				
			  setting_id      = "format",
			  type          = "dropdown",
			  default_value = '%R:%S',
			  options = {
				{text = "24h",   value = '%R:%S', show_widgets = {}},
				{text = "12h",   value = '%r', show_widgets = {}},
			  } 
			},			
		}
	}
}