-- Loading Modules
require("phrases")
require("encryptdecrypt")

-- Save Game Function
function save(score)
	score = encrypt(score)
	love.filesystem.write("SAVE.sav", score)
end

-- Load game function
function load()
	local score = love.filesystem.read("SAVE.sav")
	score = decrypt(score)
	followers = math.ceil(score)
end

-- Main Startup Function
function love.load()

	-- Constants
	WINDOW_WIDTH = 1280
	WINDOW_HEIGHT = 720
	INIT_VOLUME = 0.1

	-- Setting up the Window
	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {msaa = 12})
	love.window.setTitle("Microwaved Circus Peanut")

	office = {
		love.graphics.newImage("assets/img/office1.png"),
		love.graphics.newImage("assets/img/office2.png"),
		love.graphics.newImage("assets/img/office3.png")
	}

	profpic = {
		love.graphics.newImage("assets/img/profpic1.png"),
		love.graphics.newImage("assets/img/profpic2.png"),
		love.graphics.newImage("assets/img/profpic3.png")
	}

	soundimg1 = love.graphics.newImage("assets/img/sound1.png")
	soundimg2 = love.graphics.newImage("assets/img/sound2.png")

	select = love.audio.newSource("assets/audio/select.wav", "static")

	tracks = {
		love.audio.newSource("assets/audio/track1.wav", "stream"),
		love.audio.newSource("assets/audio/track2.wav", "stream"),
		love.audio.newSource("assets/audio/track3.wav", "stream")
	}

	delay = love.audio.newSource("assets/audio/delay.wav", "stream")

	currentTrack = "track1"

	volume = INIT_VOLUME
	love.audio.setVolume(volume)
	love.audio.play(tracks[1])

	CharacterIndex = 1

	message = ""
	followers = 0
	totalposts = 0
	msgDone = false
	muted = false
	gamestage = "nouns"

	messageFont = love.graphics.newFont("assets/font/manjaribold.ttf", 35)
	buttonFont = love.graphics.newFont("assets/font/manjaribold.ttf", 35)
	statsFont = love.graphics.newFont("assets/font/manjaribold.ttf", 15)

	sendButton = {}
	sendButton.text = "Post"
	sendButton.x = 970
	sendButton.y = 420
	sendButton.width = 140
	sendButton.height = 50
	sendButton.isActive = false
	sendButton.borderradius = 20

	charButton = {}
	charButton.text = "Change Liar"
	charButton.x = 610
	charButton.y = 420
	charButton.width = 340
	charButton.height = 50
	charButton.isActive = true
	charButton.borderradius = 20

	muteButton = {}
	muteButton.text = ""
	muteButton.x = WINDOW_WIDTH - 10 - 50
	muteButton.y = 10
	muteButton.width = 50
	muteButton.height = 50
	muteButton.isActive = true
	muteButton.borderradius = 10

	option1 = {}
	option1.text = ""
	option1.x = 440
	option1.y = 500
	option1.width = 350
	option1.height = 50
	option1.isActive = true
	option1.borderradius = 15

	option2 = {}
	option2.text = ""
	option2.x = 910
	option2.y = 570
	option2.width = 350
	option2.height = 50
	option2.isActive = true
	option2.borderradius = 15

	option3 = {}
	option3.text = ""
	option3.x = 440
	option3.y = 640
	option3.width = 350
	option3.height = 50
	option3.isActive = true
	option3.borderradius = 15

	-- Get initial phrases
	getValues(nouns)

	-- Load save data
	if love.filesystem.getInfo("SAVE.sav") then
		load()
	end
end

-- Function to set the text for the
-- three option buttons
function getValues(typev)
	love.math.setRandomSeed(love.math.getRandomSeed() + 7)
	option1.text = typev[ love.math.random( #typev ) ]
	love.math.setRandomSeed(love.math.getRandomSeed() + 7)
	option2.text = typev[ love.math.random( #typev ) ]
	love.math.setRandomSeed(love.math.getRandomSeed() + 7)
	option3.text = typev[ love.math.random( #typev ) ]
end

-- Check if the mouse is touching a button
function isMouseHovering(buttonToCheck)
	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()
	if mouseX > buttonToCheck.x and mouseX < buttonToCheck.x + buttonToCheck.width and mouseY > buttonToCheck.y and mouseY < buttonToCheck.y + buttonToCheck.height then
		return true
	end
end

-- Function called when the Option Buttons are pressed
function optionButton(optionBtn)
	if isMouseHovering(optionBtn) and optionBtn.isActive then
		if gamestage == "nouns" then
			message = message .. optionBtn.text
			getValues(verbs)
			gamestage = "verbs"
		elseif gamestage == "verbs" then
			message = message .. "\n" .. optionBtn.text
			getValues(adjectives)
			gamestage = "adjectives"
		else
			message = message .. "\n" .. optionBtn.text
			msgDone = true
		end
		love.audio.play(select)
	end
end

-- Function called when the mouse is pressed
function love.mousepressed(x, y, button, istouch)
	if button == 1 then
		if isMouseHovering(sendButton) and sendButton.isActive then
			love.audio.play(select)
			totalposts = totalposts + 1
			followers = math.floor(followers + #message / 1.5)
			save(followers)
			getValues(nouns)
			gamestage = "nouns"
			message = ""
			msgDone = false
		end
		if isMouseHovering(charButton) and charButton.isActive then
			love.audio.play(select)
			CharacterIndex = CharacterIndex + 1
			if CharacterIndex > #office then
				CharacterIndex = 1
			end
		end
		if isMouseHovering(muteButton) and muteButton.isActive then
			if muted then
				volume = INIT_VOLUME
				muted = false
			else
				volume = 0
				muted = true
			end
		end
		optionButton(option1)
		optionButton(option2)
		optionButton(option3)
	end
end

-- Draws a button from table
function drawButton(buttonTD, indent)
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("fill", buttonTD.x, buttonTD.y, buttonTD.width, buttonTD.height, buttonTD.borderradius)
	love.graphics.setFont(buttonFont)
	-- Set color based of activeness
	if not buttonTD.isActive then
		love.graphics.setColor(0.6, 0.6, 0.6)
	else
		love.graphics.setColor(0, 0, 0)
	end
	love.graphics.print(buttonTD.text, buttonTD.x + indent, buttonTD.y + 11)
end

-- Main draw function
function love.draw()
	-- Draw Background
	love.graphics.setColor(0.5, 1, 1)
	love.graphics.rectangle("fill", 0, 0, 1280, 720)

	-- Draw Character Image
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(office[CharacterIndex], 0, 0)

	-- Draw Message Box
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("fill", 610, 100, 500, 300, 15)

	-- Draw profile pic
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(profpic[CharacterIndex], 635, 115, 0, 0.1)

	-- Draw follower count
	love.graphics.setFont(statsFont)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("Followers: " .. followers, 695, 148)

	-- Draw post count
	love.graphics.setFont(statsFont)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("Posts: " .. totalposts, 695, 122)

	-- Draw Message text
	love.graphics.setFont(messageFont)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(message, 640, 200)

	-- Draw Send Button
	drawButton(sendButton, 35)

	-- Draw option1 button
	drawButton(option1, 26)

	-- Draw option2 button
	drawButton(option2, 26)

	-- Draw option3 button
	drawButton(option3, 26)

	-- Draw character select button
	drawButton(charButton, 65)

	-- Draw mute button
	drawButton(muteButton, 38)
	if muted then
		love.graphics.draw(soundimg2, muteButton.x, muteButton.y, 0, 0.1)
	else
		love.graphics.draw(soundimg1, muteButton.x, muteButton.y, 0, 0.1)
	end
end

-- Called every frame
function love.update(dt)
	love.audio.setVolume(volume)

	if not tracks[1]:isPlaying() and currentTrack == "track1" then
		currentTrack = "delay1"
		love.audio.play(delay)
	elseif not delay:isPlaying() and currentTrack == "delay1" then
		currentTrack = "track2"
		love.audio.play(tracks[2])

	elseif not tracks[2]:isPlaying() and currentTrack == "track2" then
		currentTrack = "delay2"
		love.audio.play(delay)
	elseif not delay:isPlaying() and currentTrack == "delay2" then
		currentTrack = "track3"
		love.audio.play(tracks[3])

	elseif not tracks[3]:isPlaying() and currentTrack == "track3" then
		currentTrack = "delay3"
		love.audio.play(delay)
	elseif not delay:isPlaying() and currentTrack == "delay3" then
		currentTrack = "track1"
		love.audio.play(tracks[1])
	end

	sendButton.isActive = msgDone
	option1.isActive = not msgDone
	option2.isActive = not msgDone
	option3.isActive = not msgDone
end
