love.graphics.setDefaultFilter('nearest', 'nearest')
enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image = love.graphics.newImage('invader.png')

function define_playerAndEnemy()
	player = {}
	player.x = 0
	player.y = 550
	player.bullets = {}
	player.cooldown = 20 -- bullet cooldown time 20 tics
	player.speed = 5
	player.fire = function()
		if player.cooldown <= 0 then
			player.cooldown = 20
			bullet = {}
			bullet.x = player.x + 35
			bullet.y = player.y
			table.insert(player.bullets , bullet)
		end
	end
	player.image = love.graphics.newImage('defender.png')

	enemies_controller:spawnEnemy(0, 0, 1)
	enemies_controller:spawnEnemy(100, 0, 2)
end

function enemies_controller:spawnEnemy(x, y, speed)
	enemy = {}
	enemy.x = x
	enemy.y = y
	enemy.bullets = {}
	enemy.cooldown = 20 -- enemy cooldown time 20 tics
	enemy.speed = speed
	table.insert(self.enemies, enemy)
end

function enemy:fire() -- parameter ommit: being self (enemy)
	if self.cooldown <= 0 then
			self.cooldown = 20
			bullet = {}
			bullet.x = self.x 
			bullet.y = self.y
			table.insert(self.bullets , bullet)
		end
end


-- load, update and draw
function love.load()
	-- define player and enemies
	define_playerAndEnemy()
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

	-- move enemies
	for _,e in pairs(enemies_controller.enemies) do 
		e.y = e.y + e.speed
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
	love.graphics.setColor(255,255,255)

	-- draw player
	love.graphics.draw(player.image, player.x, player.y)

	-- draw enemies
	for _,e in pairs(enemies_controller.enemies) do
		love.graphics.draw(enemies_controller.image, e.x, e.y)
	
	end
	-- draw bullets
	for _,v in pairs(player.bullets) do
		love.graphics.rectangle("fill", v.x, v.y, 10, 10)
	end
end


