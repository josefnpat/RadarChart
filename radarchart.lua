--- RadarChart is a radar/spider chart generator module for LÖVE.
-- @module RadarChart
-- @author Josef N Patoprsty <seppi@josefnpat.com>
-- @copyright 2014
-- @license <a href="http://www.opensource.org/licenses/zlib-license.php">zlib/libpng</a>

local RadarChart = {}

--- Instansiate a new instance of a radar chart.
-- @param data <i>Required</i> The data set that the radar chart should operate on. See <a href="#RadarChart:setData">RadarChart.setData</a> for information on the structure of this object.
-- @param x <i>Required</i> The X position of the center of the radar chart.
-- @param y <i>Required</i> The Y position of the center of the radar chart.
-- @param radius <i>Required</i> The radius of the radar chart from the center defined from X and Y.
function RadarChart.new(data,x,y,radius)
  local r = {}

  r.draw = RadarChart.draw

  -- Public getters and setters along with intial data being set.
  r.setData = RadarChart.setData
  r.getData = RadarChart.getData
  r:setData(data)

  r.setPosition = RadarChart.setPosition
  r.getPosition = RadarChart.getPosition
  r:setPosition(x,y)

  r.setRadius = RadarChart.setRadius
  r.getRadius = RadarChart.getRadius
  r:setRadius(radius)

  r.setTicks = RadarChart.setTicks
  r.getTicks = RadarChart.getTicks
  r:setTicks(1)

  r.setRadianOffset = RadarChart.setRadianOffset
  r.getRadianOffset = RadarChart.getRadianOffset
  r:setRadianOffset(-math.pi/2)

  r.setFont = RadarChart.setFont
  r.getFont = RadarChart.getFont
  r:setFont(love.graphics.newFont(12))

  r.setColor = RadarChart.setColor
  r.getColor = RadarChart.getColor

  r._colors = {
    htick = {63,63,63},
    vtick = {31,31,31},
    integral = {255,0,0,127},
    font = {255,255,255}
  }

  r.setDrawMode = RadarChart.setDrawMode
  r.getDrawMode = RadarChart.getDrawMode

  r._drawmodes = {
    ticks = "line",
    integral = "fill"
  }

  -- Internal functions
  r._point = RadarChart._point

  return r
end

--- Main draw function.
-- This is the main draw function that is required to be run in <code>love.draw()</code>.
function RadarChart:draw()
  -- back up the font and color
  local oc,of = {love.graphics.getColor()},love.graphics.getFont()
  love.graphics.setFont(self._font)

  for tick = 1,self._ticks do
    love.graphics.setColor(self._colors.vtick)
    local points = {}
    for i,v in pairs(self._data) do
      local radius = self._radius * tick/self._ticks
      local ax,ay = self:_point(i,radius)
      love.graphics.line(self._x,self._y,ax,ay)
      table.insert(points,ax)
      table.insert(points,ay)
    end
    love.graphics.setColor(self._colors.htick)
    love.graphics.polygon(self._drawmodes.ticks,points)
  end

  local prevx,prevy = self:_point(-1,
    self._radius*self._data[#self._data].value)
  for i,v in pairs(self._data) do
    love.graphics.setColor(self._colors.integral)
    local vrad = self._radius * v.value
    local vx,vy = self:_point(i-1,vrad)
    local vpoints = {prevx,prevy,vx,vy,self._x,self._y}
    love.graphics.polygon(self._drawmodes.integral,vpoints)
    prevx,prevy = vx,vy
    local tx,ty = self:_point(i,self._radius+self._font:getHeight())
    local tx_offset = tx < self._x and -self._font:getWidth(v.label) or 0
    love.graphics.setColor(self._colors.font)
    love.graphics.print(v.label,tx+tx_offset,ty-self._font:getHeight()/2)
  end

  -- Reset the color and font
  love.graphics.setColor(oc)
  love.graphics.setFont(of)
end

--- Set the data set.
-- @param data <i>Required</i> The data set that the radar chart should operate on.<br/>
-- Data is expected to be a table of tables with:<br/>
-- <ul>
-- <li>A string indexed as <i>label</i> (The label of the data point).
-- <li>A number indexed as <i>value</i> (The value of the data point).
-- </ul>
-- Example:<br/>
-- <code>data = {{label="HP",value=45},
-- {label="Attack",value=49},
-- {label="Defense",value=49},
-- {label="Sp. Atk",value=65},
-- {label="Sp. Def",value=65},
-- {label="Speed",value=45}}</code>

function RadarChart:setData(data)
  assert(type(data)=="table",
    "setData: `data` expects a table, got "..type(data)..".")
  assert(#data>=3,
    "setData: `data` expects a table of length 3 or more, got "..#data..".")
  for _,v in pairs(data) do
    assert(type(v)=="table",
      "setData: `data` table expects elements to have tables,"..
      " got "..type(v)..".")
    assert(type(v.label)=="string",
      "setData: `data` table expects elements to have `label` as string,"..
      " got "..type(v.label)..".")
    assert(type(v.value)=="number",
      "setData: `data` table expects elements to have `value` as string,"..
      " got "..type(v.value)..".")
    assert(v.value>=0,
      "setData: `data` table expects elements to have `value` gte to 0,"..
      " got"..v.value..".")
  end
  self._data = data
end

--- Return the data set.
-- @return dataset
function RadarChart:getData()
  return self._data
end

--- Set the X and Y position of the center.
-- @param x <i>Required</i> The X position of the center of the radar chart.
-- @param y <i>Required</i> The Y position of the center of the radar chart.
function RadarChart:setPosition(x,y)
  assert(type(x)=="number",
    "setPosition: `x` expects a number, got "..type(x)..".")
  assert(type(y)=="number",
    "setPosition: `y` expects a number, got "..type(y)..".")
  self._x,self._y = x,y
end

--- Return the X and Y position of the center.
-- @return number,number
function RadarChart:getPosition()
  return self._x,self._y
end

--- Set the radius.
-- This will be drawn at the outmost horizontal tick. Keep in mind, the text will be drawn outside of this radius.
-- @param radius The radius that the radar chart should draw at.
function RadarChart:setRadius(radius)
  assert(type(radius)=="number",
    "setRadius: `radius` expects a number, got "..type(radius)..".")
  self._radius = radius
end

--- Return the radius.
-- @return number
function RadarChart:getRadius()
  return self._rad
end

--- Set the number of ticks.
-- This is the number of horizontal ticks that will be drawn on the chart.
-- Defaults to 1
-- @param ticks A number greater than or equal to 1
function RadarChart:setTicks(ticks)
  assert(type(ticks)=="number",
    "setTicks: `ticks` expects a number, got "..type(ticks)..".")
  assert(ticks>=1,
    "setTicks: `ticks` expects a number larger or equal to 1, got "..ticks..".")
  self._ticks = ticks
end

--- Return the number of ticks.
-- @return number
function RadarChart:getTicks()
  return self._ticks
end

--- Set the radian offset.
-- Defaults to -pi/2 (first element on top)
-- @param radian_offset The offset that the radar chart should draw at.
function RadarChart:setRadianOffset(radian_offset)
  assert(type(radian_offset)=="number",
    "setRadianOffset: `radian_offset` expects a number,"..
    " got "..type(radian_offset)..".")
  self._radian_offset = radian_offset
end

--- Returns the radian offset.
-- @return number
function RadarChart:getRadianOffset()
  return self._radian_offset
end

--- Sets the color of an element.
-- @param name The element in which you want to change.<br/>
-- The available elements are:<br/>
-- <ul>
-- <li><code>htick</code> The horizontal tick color. (Defaults to {63,63,63})
-- <li><code>vtick</code> The vertical tick color. (Defaults to {31,31,31})
-- <li><code>integral</code> The integral (area under the dataset) color (Defaults {255,0,0,127})
-- <li><code>font</code> The font color (Defaults to {255,255,255})
-- </ul>
-- @param color The color as a table in which you want to change the element to. This should be {R,G,B} or {R,G,B,A}.
function RadarChart:setColor(name,color)
  assert(type(name)=="string",
    "setColor: `name` expects a string, got "..type(name)..".")
  assert(self._colors[name],
    "setColor: `name` does not exist, got "..name..".")
  assert(type(color)=="table",
    "setColor: `color` expects a table, got "..type(color)..".")
  assert(#color>=3,
    "setColor: `color` expects a table of length 3 or more,"..
    " got "..#color..".")
  for _,v in pairs(color) do
    assert(type(v)=="number",
      "setColor: `color` table expects elements to be numbers,"..
      " got "..type(v)..".")
  end
  self._colors[name] = color
end

--- Return the color for an element.
-- @param name The element in which you want to return.
-- @return color object
function RadarChart:getColor(name)
  assert(type(name)=="string","getColor: `name` expects a string,"..
  " got "..type(name)..".")
  assert(self._colors[name],"getColor: `name` does not exist,"..
  " got "..name..".")
  return self._colors[name]
end

--- Sets the drawmode of an element.
-- @param name The element in which you want to change.<br/>
-- The available elements are:<br/>
-- <ul>
-- <li><code>ticks</code> The drawmode type for the ticks. (Defaults to "line")
-- <li><code>integral</code> The integral (area under the dataset) drawmode type (Defaults "fill")
-- </ul>
-- @param drawmode The drawmode in which you want to change the element to.
function RadarChart:setDrawMode(name,drawmode)
  assert(type(name)=="string",
    "setDrawMode: `name` expects a string, got "..type(name)..".")
  assert(self._drawmodes[name],
    "setDrawMode: `name` does not exist, got "..name..".")
  assert(type(drawmode)=="string",
    "setDrawMode: `drawmode` expects a string, got "..type(name)..".")
  self._drawmodes[name] = drawmode
end

--- Return the DrawMode for an element.
-- @param name The element in which you want to return.
-- @return DrawMode string
function RadarChart:getDrawMode(name)
  assert(type(name)=="string","getDrawMode: `name` expects a string,"..
  " got "..type(name)..".")
  assert(self._drawmodes[name],"getDrawMode: `name` does not exist,"..
  " got "..name..".")
  return self._drawmodes[name]
end

--- Set the font.
-- Set the font that the labels will be drawn with.<br/>
-- Default is the default LÖVE font.
-- @param font The font you want the labels of the chart to be drawn as.
function RadarChart:setFont(font)
  assert(font:type()=="Font",
    "setFont: `font` expects a font, got "..font:type()..".")
  self._font = font
end

--- Return the font.
-- Returns the font that is currently set.
-- @return Font
function RadarChart:getFont()
  return self._font
end

--- Determine the point at a specific radius from the objects internals.
-- This is an internal function.
-- @param index The index of the data set to be used.
-- @param rad The radius for the calculation.
-- @return number,number
function RadarChart:_point(index,rad)
  local r = rad or self._radius
  local step = 2*math.pi/#self._data
  local x = self._x + r * math.cos(index*step+self._radian_offset)
  local y = self._y + r * math.sin(index*step+self._radian_offset)
  return x,y
end

return RadarChart
