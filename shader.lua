local Shader = {
  crtShader = love.graphics.newShader("shaders/crt_2.glsl"),
  time = 0,
  sceneCanvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
}

Shader.crtShader:send("curvature", 0.5)
Shader.crtShader:send("scanline", 1)

function Shader.update(dt)
  Shader.time = Shader.time + dt
end

function Shader.draw(self, drawScene)
  -- 1) Draw the scene to a low-res canvas
  love.graphics.push("all")
  love.graphics.setCanvas(self.sceneCanvas)
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.clear(0,0,0,1)
  drawScene()
  love.graphics.setCanvas()
  love.graphics.pop()

  -- 2) Draw the canvas to the screen with the CRT shader
  love.graphics.push("all")
  love.graphics.setShader(self.crtShader)

  local y = love.graphics.getHeight() / 800
  local x = love.graphics.getWidth() / 1400

  love.graphics.draw(self.sceneCanvas, -love.graphics.getWidth()*x*0.099, -love.graphics.getHeight()*y*0.099, 0, x*1.2, y*1.2)
  love.graphics.setShader()
  love.graphics.pop()
end

return Shader