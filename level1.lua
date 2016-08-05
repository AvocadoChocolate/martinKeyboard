-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

require "sqlite3"

--local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local path = system.pathForFile( "SpellingDatabase")
local db = sqlite3.open( path )

local keyboard
local myText
local textField
local tospell = {}
local sceneGroup
--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

function scene:create( event )
require("onScreenKeyboard") -- include the onScreenKeyboard.lua file

        --create a textfield for the content created with the keyoard
        textField = display.newText("",  200, 50, native.systemFont, 50)
        textField:setTextColor(255,255,255)
        
        w = { ENABLEONLY = {"a", "b"}
              }

        keyboard = onScreenKeyboard:new(w)

        --create a listener function that receives the events of the keyboard
        local listener = function(event)
            if(event.phase == "ended")  then
                textField.text=keyboard:getText() --update the textfield with the current text of the keyboard

                --check whether the user finished writing with the keyboard. The inputCompleted
                --flag of  the keyboard is set to true when the user touched its "OK" button
                if(event.target.inputCompleted == true) then
                    print("Input of data complete...")
                    --keyboard:destroy()
                    
                    processKeyboard()
                    
                    --[[if (textField.text:upper() == tospell:upper()) then
                    --keyboard:destroy()
                    showKeyboard()
                    end --]]
                end
            end
        end

        --let the onScreenKeyboard know about the listener
        keyboard:setListener(  listener  )

        --show a keyboard with small printed letters as default. Read more about the possible values for keyboard types in the section "possible keyboard types"
        keyboard:drawKeyBoard(keyboard.keyBoardMode.letters_large)

local chosenword = chooseWord()

tospell = chosenword.spelling
wordsoundr = chosenword.wordS
definitionsoundr = chosenword.defS
examplesoundr = chosenword.exampleS
POSnumb = chosenword.POS

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	sceneGroup = self.view
	
	myText = display.newText(tospell, 100, 200, native.systemFont, 16 )	
	
	local wordSound = audio.loadSound(wordsoundr)
	local definitionSound = audio.loadSound(definitionsoundr)
	local exampleSound = audio.loadSound(examplesoundr) 
	local wordChannel = audio.play( wordSound )
	 
	-- all display objects must be inserted into group
	--sceneGroup:insert( background )
	--sceneGroup:insert( grass)
	--sceneGroup:insert( crate )
	sceneGroup:insert( myText )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function processKeyboard()
if (textField.text:upper() == tospell:upper()) then
                    --keyboard:destroy()
                    --showKeyboard()
                    local chosenword = chooseWord()
textField.text = ""
keyboard.text = ""
tospell = chosenword.spelling
	sceneGroup:remove(myText)
	myText = display.newText(tospell, 100, 200, native.systemFont, 16 )	
	sceneGroup:insert(myText)
                    end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function chooseWord()
	local n = {}

	for row in db:nrows("SELECT COUNT(*) AS count FROM Word") do
		n = math.random(row.count)
	end

	for row in db:nrows("SELECT * FROM 'Word' where id='" ..  tostring(n) .. "'") do
 		return row
	end
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene