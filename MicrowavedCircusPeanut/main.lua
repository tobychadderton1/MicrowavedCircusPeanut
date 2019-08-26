function love.load()
	nouns = {"Your mother", "Your hair", "Your nan", "Your dog", "Your foot",
	"Your mum's ass", "Keemstar", "Your brother", "Adolf Hitler", "Stephen Hawking"}

	verbs = {"looks like", "is", "smells like", "eats like", "made love with",
	"ate", "defacated on", "murdered", "killed", "was", "is like", "sounds like"}

	adjectives = {"an octopus", "a fat turd", "a dead rodent", "a fish",
	"a frisky cat", "a retard", "foot fungus", "you", "your sister", "an idiot",
	"your father", "a flat moth", "a liberal", "a zombie", "an elephant",
	"mouldy bread", "old vomit"}

	love.window.setMode(1280, 720)

	love.window.setTitle("Microwaved Circus Peanut")

	office = {
		love.graphics.newImage("assets/img/office1.png"),
		love.graphics.newImage("assets/img/office2.png"),
		love.graphics.newImage("assets/img/office3.png")}
	profpic = {
		love.graphics.newImage("assets/img/profpic1.png"),
		love.graphics.newImage("assets/img/profpic2.png"),
		love.graphics.newImage("assets/img/profpic3.png")}

	select = love.audio.newSource("assets/audio/select.wav", "static")

	track1 = love.audio.newSource("assets/audio/track1.wav", "stream")
	track1:setLooping(true)
	love.audio.setVolume(0.2)
	love.audio.play(track1)

	CharacterIndex = 1

	message = ""
	followers = 0
	totalposts = 0
	msgDone = false
	gamestage = "nouns"

	messageFont = love.graphics.newFont(30)
	buttonFont = love.graphics.newFont(30)
	statsFont = love.graphics.newFont(15)

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

	option1 = {}
	option1.text = ""
	option1.x = 440
	option1.y = 500
	option1.width = 350
	option1.height = 50
	option1.isActive = true
	option1.borderradius = 10

	option2 = {}
	option2.text = ""
	option2.x = 910
	option2.y = 570
	option2.width = 350
	option2.height = 50
	option2.isActive = true
	option2.borderradius = 10

	option3 = {}
	option3.text = ""
	option3.x = 440
	option3.y = 640
	option3.width = 350
	option3.height = 50
	option3.isActive = true
	option3.borderradius = 10

	-- Get initial phrases
	getValues(nouns)
end

function getValues(typev)
	love.math.setRandomSeed(love.math.getRandomSeed() + 7)
	option1.text = typev[ love.math.random( #typev ) ]
	love.math.setRandomSeed(love.math.getRandomSeed() + 7)
	option2.text = typev[ love.math.random( #typev ) ]
	love.math.setRandomSeed(love.math.getRandomSeed() + 7)
	option3.text = typev[ love.math.random( #typev ) ]
end

function isMouseHovering(buttonToCheck)
	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()
	if mouseX > buttonToCheck.x and mouseX < buttonToCheck.x + buttonToCheck.width and mouseY > buttonToCheck.y and mouseY < buttonToCheck.y + buttonToCheck.height then
		return true
	end
end

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

function love.mousepressed(x, y, button, istouch)
	if button == 1 then
		if isMouseHovering(sendButton) and sendButton.isActive then
			love.audio.play(select)
			totalposts = totalposts + 1
			followers = math.floor(followers + #message / 1.5)
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
		optionButton(option1)
		optionButton(option2)
		optionButton(option3)
	end
end

function drawButton(buttonTD)
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("fill", buttonTD.x, buttonTD.y, buttonTD.width, buttonTD.height, buttonTD.borderradius)
	love.graphics.setFont(buttonFont)
	-- Set color based of activeness
	if not buttonTD.isActive then
		love.graphics.setColor(0.6, 0.6, 0.6)
	else
		love.graphics.setColor(0, 0, 0)
	end
	love.graphics.print(buttonTD.text, buttonTD.x + 38, buttonTD.y + 8)
end

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
	love.graphics.print("Followers: " .. followers, 695, 144)

	-- Draw post count
	love.graphics.setFont(statsFont)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("Posts: " .. totalposts, 695, 119)

	-- Draw Message text
	love.graphics.setFont(messageFont)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(message, 640, 200)

	-- Draw Send Button
	drawButton(sendButton)

	-- Draw option1 button
	drawButton(option1)

	-- Draw option2 button
	drawButton(option2)

	-- Draw option3 button
	drawButton(option3)

	-- Draw character select button
	drawButton(charButton)
end

function love.update(dt)
	sendButton.isActive = msgDone
	option1.isActive = not msgDone
	option2.isActive = not msgDone
	option3.isActive = not msgDone
end
