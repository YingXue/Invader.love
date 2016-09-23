love.graphics.setDefaultFilter('nearest', 'nearest')

enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image = love.graphics.newImage('invader.png')

particle_systems = {}
particle_systems.list = {}
particle_systems.img = love.graphics.newImage('particle.png')

-- spawn partcile system
function particle_systems:spawn(x, y)
  local ps = {}
  ps.x = x
  ps.y = y
  ps.ps = love.graphics.newParticleSystem(particle_systems.img, 32)
  ps.ps:setParticleLifetime(2, 4)
  ps.ps:setEmissionRate(5)
  ps.ps:setSizeVariation(1)
  ps.ps:setLinearAcceleration(-20, -20, 20, 20)
  ps.ps:setColors(100, 255, 100, 255, 0, 255, 0, 255)
  table.insert(particle_systems.list, ps)
end

-- draw particles
function particle_systems:draw()
  	for _, v in pairs(particle_systems.list) do
    	love.graphics.draw(v.ps, v.x, v.y)
  	end
end

-- update particles
function particle_systems:update(dt)
  for _, v in pairs(particle_systems.list) do
    v.ps:update(dt)
  end
end

-- define player and spawn enemies
function define_player()
	player = {}
	player.x = 0
	player.y = 550
	player.bullets = {}
	player.cooldown = 20 -- bullet cooldown time 20 tics
	player.speed = 5
	player.fire_sound = love.audio.newSource('shoot.wav')
	player.collision_sound = love.audio.newSource('invaderkilled.wav')
	player.fire = function()		
		if player.cooldown <= 0 then
			love.audio.play(player.fire_sound)
			player.cooldown = 20
			bullet = {}
			bullet.x = player.x + 35
			bullet.y = player.y
			table.insert(player.bullets , bullet)
		end
	end
	player.image = love.graphics.newImage('defender.png')	
end

function define_enemy()
	for i = 0, 5 do
		enemies_controller:spawnEnemy(i * 80, i , 1)
	end
end

-- check player and enemy collision
function checkCollisions(enemies, bullets)
	for i,e in ipairs(enemies) do
		for _,b in pairs(bullets) do
			if b.y <= e.y + e.height and b.x > e.x and b.x < e.x + e.width then
				love.audio.play(player.collision_sound) -- play collsion sound
				particle_systems:spawn(e.x + e.width/2, e.y + e.height/2) -- spawn particles
				table.remove(enemies,i) -- remove enemy
			end
		end
	end
end

-- load, update and draw
function love.load()
	background_image = love.graphics.newImage('background.jpeg')
	local music = love.audio.newSource('Wrecking Ball.mp3')
	music:setLooping(true)
	love.audio.play(music)
	
	-- define player and enemies
	define_player()
	define_enemy()

	game_over = false
	game_win = false
end

-- spawn enemy -- parameter ommit: being self (enemies controller)
function enemies_controller:spawnEnemy(x, y, speed)
	enemy = {}
	enemy.x = x
	enemy.y = y
	enemy.bullets = {}
	enemy.width = 50
	enemy.height = 30
	enemy.cooldown = 20 -- enemy cooldown time 20 tics
	enemy.speed = speed
	table.insert(self.enemies, enemy)
end

-- update, load, and draw
function love.update(dt)
	particle_systems:update(dt)
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
		-- check win state
	if #enemies_controller.enemies == 0 then
		game_win = true
	end

	for _,e in pairs(enemies_controller.enemies) do 
		if e.y >= love.graphics.getHeight() then
			game_over = true
		end
		e.y = e.y + e.speed

		math.randomseed(os.time())
		random_number = math.random();
		if (random_number - math.floor(random_number / 2) * 2 == 1) then
			e.x = e.x + e.speed
		else
			e.x = e.x - e.speed
		end

	end

	-- clean up bullets to release memory
	for i,b in pairs(player.bullets) do
		if b.y < -10 then
			table.remove(player.bullets, i)
		end

		-- bullets move up
		b.y = b.y - 10
	end

	-- check collision
	checkCollisions(enemies_controller.enemies, player.bullets)
end

function love.draw() -- called each time by update
	love.graphics.setColor(255,255,255)	

	-- draw background
	love.graphics.draw(background_image)

	-- check game over
	if game_over then
		love.graphics.print("Game Over")
		return
	elseif game_win then
		love.graphics.print("You win")
	end

	-- draw particle system
	particle_systems:draw()

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


