function define_player()
	player = {}
	player.x = 0
	player.y = 550
	player.bullets = {}
	player.cooldown = 20 -- bullet cooldown time 20 tics
	player.speed = 10
	player.fire = function()
		if player.cooldown <= 0 then
			player.cooldown = 20
			bullet = {}
			bullet.x = player.x + 35
			bullet.y = player.y
			table.insert(player.bullets , bullet)
		end
	end
end
function love.load()
	define_player()
end

function love.update(dt)
	player.cooldown = player.cooldown -1

	-- move players left and right
	if love.keyboard.isDown("right") then 
		player.x = player.x + player.speed
	elseif love.keyboard.isDown("left") then 
		player.x = player.x - player.speed
	end

	-- fire
	if love.keyboard.isDown("space") then
		player.fire()
	end

	-- clean up bullets to release memory
	for i,b in pairs(player.bullets) do
		if b.y < -10 then
			table.remove(player.bullets, i)
		end

		-- bullets move up
		b.y = b.y - 10
	end
end

function love.draw() -- called each time by update
	-- draw player
	love.graphics.setColor(0,0,255)
	love.graphics.rectangle("fill", player.x, player.y, 80, 20)

	-- draw bullets
	for _,v in pairs(player.bullets) do
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle("fill", v.x, v.y, 10, 10)
	end
end


