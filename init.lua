--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

print('minimap_gui loading')

local localplayer
local mod_storage  = minetest .get_mod_storage()

if mod_storage :get_string('show') == '' then
	mod_storage :set_string('show', 'true')
end  -- if show()

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

minetest .register_on_connect(
  function()

	  minetest .after( 1,  -- delay a moment for Minetest to initialize player
	    function()

        localplayer  = minetest .localplayer
        local M1  = minetest .colorize('#BBBBBB', 'minimap_gui loaded, type ')
        local M2  = minetest .colorize('#FFFFFF', '.m ')
        local M3  = minetest .colorize('#BBBBBB', 'or ')
        local M4  = minetest .colorize('#FFFFFF', '.map ')
        local M5  = minetest .colorize('#BBBBBB', 'to view.')
        minetest .display_chat_message( M1..M2..M3..M4..M5 )
      
		    if mod_storage :get_string('show') == 'true' then  -- show minimap
			    minetest .ui .minimap :show()
			    minetest .ui .minimap :set_mode( mod_storage :get_int('mode'))
			    minetest .ui .minimap :set_shape( mod_storage :get_int('shape'))
          print('minimap_gui enabled')
		    end  -- if show

	    end  -- function()
	  )  -- .after()

  end  -- function()
)  -- .register_on_connect()

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

minetest .register_chatcommand( 'm',
  {
	  description  = 'Minimap GUI',
	  func  = function()
		  show_minimap_formspec()
    end  -- function()

  }  -- specifications
)  -- register_chatcommand

minetest .register_chatcommand( 'map',
  {
	  description  = 'Minimap GUI',
	  func  = function()
		  show_minimap_formspec()
    end  -- function()

  }  -- specifications
)  -- register_chatcommand

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function show_minimap_formspec()  -- Note: don't use spacing in formspec parameters...
	minetest .show_formspec( 'map_gui', 
		'size[6,4]'..  'bgcolor[#030015]'..

		'label[1,0;Minimap GUI]'..
		'button_exit[5.2,-0.15;1.0,0.7;close;×]'..

		-- visible?
		'label[0.1,1.1;Map_Visible]'..
		'dropdown[2.5,1;2.0;Map_Visible;true,false;1]'..

		-- mode - surface or radar
		'label[0.1,2.1;Map_Mode]'..
		'dropdown[2.5,2;3.0;Map_Mode;Surface X1,Surface X2,Surface X4,Radar X1,Radar X2,Radar X4;3]'..

		-- map shape
		'label[0.1,3.1;Map_Shape]'..
		'dropdown[2.5,3;2.0;Map_Shape;Square,Round;2]'

	)  -- show_formspec()
end  -- function show_minimap_formspec()

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

minetest .register_on_formspec_input(
  function(formname, fields)
	  if formname == 'map_gui' and not fields .quit then
      --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		  if fields .Map_Visible then
		    if fields .Map_Visible == 'true' then
			    mod_storage :set_string('show', 'true')
			    minetest .ui .minimap :show()
			    minetest .ui .minimap :set_mode( mod_storage :get_int('mode'))
			    minetest .ui .minimap :set_shape( mod_storage :get_int('shape'))

		    elseif fields .Map_Visible == 'false' then
			    mod_storage :set_string( 'show', 'false' )
			    minetest .ui .minimap :hide()
		    end  -- .Map_Visible == 'true'
      --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		  elseif fields .Map_Mode then

		    local mode
			  if     fields .Map_Mode == 'Surface X1' then  mode = 1
			  elseif fields .Map_Mode == 'Surface X2' then  mode = 2
			  elseif fields .Map_Mode == 'Surface X4' then  mode = 3
			  elseif fields .Map_Mode == 'Radar X1' then  mode = 4
			  elseif fields .Map_Mode == 'Radar X2' then  mode = 5
			  else                                        mode = 6  -- Radar X4
			  end  -- mode

				mod_storage :set_int( 'mode', mode )
				minetest .ui .minimap :set_mode( mode )
      --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		  elseif fields .Map_Shape then

		    local shape
		    if     fields .Map_Shape == 'Square' then  shape = 0
		    elseif fields .Map_Shape == 'Round' then  shape = 1
		    end  -- .Map_Shape

			  mod_storage :set_int( 'shape', shape )
			  minetest .ui .minimap :set_shape( shape )
		  end  -- if fields...

	  end  -- formname
  end  -- function(formname, fields)
)  -- register_on_formspec_input

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
