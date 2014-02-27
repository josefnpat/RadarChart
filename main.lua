math.randomseed(os.time())

c = require("radarchart")

function love.load()

  -- Evidence to show that the current color and font are internal
  love.graphics.setColor(0,255,255)
  love.graphics.setFont(love.graphics.newFont(24))

  local pokedata = {} -- init the data set
  for i = 1,math.random(3,10) do -- add 3 to 10 random data points
    -- Add data point into data set
    table.insert(pokedata,{
      label="Test "..i, -- A basic string
      value=math.random()}) -- A random number 0..1
  end

  poke = c.new(
    pokedata, -- The data set object
    love.graphics.getWidth()/2, -- X position
    love.graphics.getHeight()/2, -- Y position
    math.random(200,280) -- The radius of the object
  )
  poke:setTicks(math.random(1,10)) -- The number of horizontal ticks
  -- Instead of starting at the top (default) we will start at the right
  poke:setRadianOffset(0)

  local rcolor
  rcolor = random_color()
  rcolor[4] = 127 -- alpha
  -- Set the area inside the data to a random color
  poke:setColor("integral",rcolor)

  if math.random(0,1) ==1 then -- 50% of the time
    -- Here we make the graph pretty
    rcolor = random_color()
    rcolor[4] = 62 -- alpha
     -- Change the draw mode of the ticks to fill
    poke:setDrawMode("ticks","fill")
    poke:setColor("htick",rcolor) -- Set the color of the ticks
  end

end

-- This function returns a random color
function random_color()
  local n,x = 63,255
  return {math.random(n,x),math.random(n,x),math.random(n,x)}-- RGB
end

function love.draw()
  poke:draw() -- Draw the chart
  -- evidence that the color and font is reset
  love.graphics.print(love.timer.getFPS(),16,16)
end

function love.update(dt)

  -- for each data point
  for i,v in pairs( poke:getData() ) do
    -- increase and clamp the data for a cool growing effect
    v.value = v.value + 0.1*dt
    if v.value > 1 then
      v.value = v.value - 1
    end
  end

  -- Slowly rotate the entire chart by 0.25 rad/s
  poke:setRadianOffset( poke:getRadianOffset() + dt*0.25 )

end

function love.keypressed()
  -- rebuild the object
  love.load()
end
