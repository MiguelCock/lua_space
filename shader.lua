local Shader = {}

function Shader.load()
  Shader.crtShader = love.graphics.newShader("assets/shaders/crt_2.glsl")
  Shader.time = 0
  Shader.crtShader:send("curvature", 0.5)
  Shader.crtShader:send("scanline", 1)
  Shader.sceneCanvas = love.graphics.newCanvas(1400, 800)
end

function Shader.update(dt)
  Shader.time = Shader.time + dt
end

function Shader.draw(self, drawScene)
  -- 1) Draw the scene to a low-res canvas
  love.graphics.push("all")
  love.graphics.setCanvas(self.sceneCanvas)
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.clear(0,0,0,0)
  drawScene()
  love.graphics.setCanvas()
  love.graphics.pop()

  -- 2) Draw the canvas to the screen with the CRT shader
  love.graphics.push("all")
  love.graphics.clear(0,0,0,1)
  love.graphics.setShader(self.crtShader)

  -- Get canvas dimensions
  local canvas_width = self.sceneCanvas:getWidth()
  local canvas_height = self.sceneCanvas:getHeight()

  local val = 1.2
  
  -- Calculate scale factors
  local scale_x = (love.graphics.getWidth() / 1400) * val
  local scale_y = (love.graphics.getHeight() / 800) * val
  
  -- Calculate the actual scaled dimensions of the canvas
  local scaled_canvas_width = canvas_width * scale_x
  local scaled_canvas_height = canvas_height * scale_y
  
  -- Calculate displacement to center the scaled canvas
  local displacement_x = (love.graphics.getWidth() - scaled_canvas_width) / 2
  local displacement_y = (love.graphics.getHeight() - scaled_canvas_height) / 2

  love.graphics.draw(self.sceneCanvas, displacement_x, displacement_y, 0, scale_x, scale_y)

  love.graphics.setShader()
  love.graphics.pop()
end

return Shader