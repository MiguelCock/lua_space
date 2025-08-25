Shader = {
  crtShader = love.graphics.newShader("shaders/crt_2.glsl"),
  time = 0,
  sceneCanvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
}

Shader.crtShader:send("curvature", 0.5)
--Shader.crtShader:send("vignette", 0.9)
Shader.crtShader:send("scanline", 1)
--Shader.crtShader:send("mask", 0)
--Shader.crtShader:send("noise", 0.03)

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
  --self.crtShader:send("iTime", self.time)

  --[[
  love.graphics.draw(self.sceneCanvas, -love.graphics.getWidth()*0.1, -love.graphics.getHeight()*0.1, 0, 1.2, 1.2)
  love.graphics.setShader()
  love.graphics.pop()
  ]]--
  local y = love.graphics.getHeight() / 800
  local x = love.graphics.getWidth() / 1400

  love.graphics.draw(self.sceneCanvas, -love.graphics.getWidth()*x*0.099, -love.graphics.getHeight()*y*0.099, 0, x*1.2, y*1.2)
  love.graphics.setShader()
  love.graphics.pop()
end

return Shader