local physics = require("physics")
physics.start()
local velocityX,velocityY = 8, -8
display.setStatusBar( display.HiddenStatusBar )
display.setDefault('background',16/255,48/255,85/255)

local hero = display.newImageRect("images/paddle.png",150,30)
hero.x = display.contentCenterX
hero.y = display.contentHeight  - 100
physics.addBody(hero,"static")

local ball = display.newImageRect("images/ball.png",30,30)
ball.x = display.contentCenterX
ball.y = display.contentHeight  - 200
physics.addBody(ball,"dynamic")
ball.gravityScale = 0
function collisionHandler( event )
	if (event.phase == "began" ) then
		if (event.other.type == "brick") then
			-- remove brick
			event.other:removeSelf()
			-- change the direction
			if(velocityY < 0) then
				velocityY = -velocityY;
			end
		else
			-- if collided with paddle
			-- flip the direction
			if (velocityY > 0) then
				velocityY = -velocityY;
			end
		end
	end

end
ball:addEventListener("collision",collisionHandler)

function addBricks(  )
	local x,y = 0,0
	for i=1,5 do
		x,y = 0, y + 50
		for i=1,7 do
			x = x + 110
			local brick = display.newImageRect("images/block"..math.random(1,6)..".png", 100,30 )
			brick.x, brick.y = x , y
			brick.type = "brick"
			physics.addBody(brick,"static")
		end
	end
end

addBricks()

function gameLoop(  )
	-- body
	ball.x = ball.x + velocityX;
	ball.y = ball.y + velocityY;
	if ball.x < 0 or ball.x + ball.width > display.contentWidth then  
		velocityX = -velocityX;
	end
	if ball.y < 0  then 
		velocityY = -velocityY;
	end
	if ball.y + ball.height > hero.y + hero.height then 
		print("game over")
	end

	if (hero.direction == "left") then
		hero.x = hero.x - 10
	elseif (hero.direction == "right") then
		hero.x = hero.x + 10
	end
end
Runtime:addEventListener("enterFrame",gameLoop)
function controls( event )
	-- body
	if (event.phase == "began") then
		if (event.x < display.contentCenterX) then
			hero.direction = "left"
		else	
			hero.direction = "right"
		end
	elseif (event.phase == "ended") then
		hero.direction = "idle"
	end
end
Runtime:addEventListener("touch",controls)
