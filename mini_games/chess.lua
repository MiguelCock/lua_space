-- LÖVE2D Chess Clone - single file (main.lua)
-- Features: legal moves (no self-check), check/checkmate/stalemate detection,
-- pawn promotion to queen, basic highlights, restart with 'R'.
-- Missing (for brevity): castling, en passant, underpromotion, draw clocks.

local sqSize = 80
local boardOffsetX, boardOffsetY = 40, 40
local lightColor = {0.93, 0.93, 0.85}
local darkColor  = {0.46, 0.62, 0.46}
local selectColor = {0.95, 0.86, 0.45}
local moveColor = {0.2, 0.2, 0.2, 0.25}
local captureColor = {0.7, 0.15, 0.15, 0.35}

local pieceGlyph = {
  wK = "♔", wQ = "♕", wR = "♖", wB = "♗", wN = "♘", wP = "♙",
  bK = "♚", bQ = "♛", bR = "♜", bB = "♝", bN = "♞", bP = "♟"
}

local startFEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1"

local board = {}
local turn = 'w'
local selected = nil
local legalMoves = {}
local gameOver = false
local statusText = ""
local font

-- Utilities
local function inBounds(x, y)
  return x >= 1 and x <= 8 and y >= 1 and y <= 8
end

local function cloneBoard(b)
  local nb = {}
  for r=1,8 do
    nb[r] = {}
    for c=1,8 do nb[r][c] = b[r][c] end
  end
  return nb
end

local function isWhite(p) return p and p:sub(1,1) == 'w' end
local function isBlack(p) return p and p:sub(1,1) == 'b' end

local function other(color) return color == 'w' and 'b' or 'w' end

local dirPawn = { w = -1, b = 1 }
local startRank = { w = 7, b = 2 }
local promoRank = { w = 1, b = 8 }

local function parseFEN(fen)
  local parts = {}
  for part in fen:gmatch("%S+") do table.insert(parts, part) end
  local rows = {}
  for row in parts[1]:gmatch("[^/]+") do table.insert(rows, row) end
  for r=1,8 do
    board[r] = {}
    local row = rows[r]
    local c = 1
    for i=1,#row do
      local ch = row:sub(i,i)
      if ch:match('%d') then
        local n = tonumber(ch)
        for k=1,n do board[r][c] = nil; c = c + 1 end
      else
        local color = ch:lower() == ch and 'b' or 'w'
        local pt = ch:lower()
        local map = {k='K', q='Q', r='R', b='B', n='N', p='P'}
        local code = color .. map[pt]
        board[r][c] = code
        c = c + 1
      end
    end
  end
  turn = parts[2] or 'w'
end

local function toAlgebra(x, y)
  return string.char(96 + x) .. (9 - y)
end

-- Attack detection helpers
local function squareAttackedBy(b, x, y, color)
  -- Knights
  local nMoves = {{1,2},{2,1},{-1,2},{-2,1},{1,-2},{2,-1},{-1,-2},{-2,-1}}
  for _,d in ipairs(nMoves) do
    local nx, ny = x + d[1], y + d[2]
    if inBounds(nx,ny) then
      local p = b[ny][nx]
      if p and p:sub(1,1)==color and p:sub(2,2)=='N' then return true end
    end
  end
  -- King
  for dx=-1,1 do for dy=-1,1 do if not (dx==0 and dy==0) then
    local nx, ny = x+dx, y+dy
    if inBounds(nx,ny) then
      local p = b[ny][nx]
      if p and p:sub(1,1)==color and p:sub(2,2)=='K' then return true end
    end
  end end
  -- Pawns
  local pd = dirPawn[color]
  for _,dx in ipairs({-1,1}) do
    local nx, ny = x+dx, y-pd
    if inBounds(nx,ny) then
      local p = b[ny][nx]
      if p and p:sub(1,1)==color and p:sub(2,2)=='P' then return true end
    end
  end
  -- Sliding (R/Q) orthogonal
  local function slide(dirx, diry, allowed)
    local nx, ny = x+dirx, y+diry
    while inBounds(nx,ny) do
      local p = b[ny][nx]
      if p then
        if p:sub(1,1)==color then
          local t = p:sub(2,2)
          if allowed[t] then return true end
        end
        break
      end
      nx = nx + dirx; ny = ny + diry
    end
  end
  if slide(1,0,{R=true,Q=true}) then return true end
  if slide(-1,0,{R=true,Q=true}) then return true end
  if slide(0,1,{R=true,Q=true}) then return true end
  if slide(0,-1,{R=true,Q=true}) then return true end
  -- Sliding (B/Q) diagonal
  if slide(1,1,{B=true,Q=true}) then return true end
  if slide(-1,1,{B=true,Q=true}) then return true end
  if slide(1,-1,{B=true,Q=true}) then return true end
  if slide(-1,-1,{B=true,Q=true}) then return true end
  return false
end

local function findKing(b, color)
  for y=1,8 do for x=1,8 do
    if b[y][x]==color..'K' then return x,y end
  end end
end

local function isInCheck(b, color)
  local kx, ky = findKing(b, color)
  if not kx then return false end
  return squareAttackedBy(b, kx, ky, other(color))
end

--  Move generation per piece (pseudo-legal)
local function addMove(moves, x1,y1,x2,y2, capture)
  table.insert(moves, {fromX=x1,fromY=y1,toX=x2,toY=y2,capture=capture})
end

local function genPawn(b, x,y,color, moves)
  local dy = dirPawn[color]
  -- one step
  local ny = y + dy
  if inBounds(x,ny) and not b[ny][x] then
    addMove(moves,x,y,x,ny,false)
    -- two steps from start
    if y==startRank[color] and not b[ny+dy][x] then
      addMove(moves,x,y,x,ny+dy,false)
    end
  end
  -- captures
  for _,dx in ipairs({-1,1}) do
    local nx = x + dx
    if inBounds(nx,ny) and b[ny][nx] and b[ny][nx]:sub(1,1)~=color then
      addMove(moves,x,y,nx,ny,true)
    end
  end
end

local function genKnight(b,x,y,color,moves)
  local deltas = {{1,2},{2,1},{-1,2},{-2,1},{1,-2},{2,-1},{-1,-2},{-2,-1}}
  for _,d in ipairs(deltas) do
    local nx, ny = x+d[1], y+d[2]
    if inBounds(nx,ny) then
      local p = b[ny][nx]
      if not p or p:sub(1,1)~=color then addMove(moves,x,y,nx,ny,p~=nil) end
    end
  end
end

local function slideGen(b,x,y,color,moves,dirs)
  for _,d in ipairs(dirs) do
    local nx, ny = x+d[1], y+d[2]
    while inBounds(nx,ny) do
      local p = b[ny][nx]
      if not p then
        addMove(moves,x,y,nx,ny,false)
      else
        if p:sub(1,1)~=color then addMove(moves,x,y,nx,ny,true) end
        break
      end
      nx = nx + d[1]; ny = ny + d[2]
    end
  end
end

local function genBishop(b,x,y,color,moves)
  slideGen(b,x,y,color,moves,{{1,1},{1,-1},{-1,1},{-1,-1}})
end
local function genRook(b,x,y,color,moves)
  slideGen(b,x,y,color,moves,{{1,0},{-1,0},{0,1},{0,-1}})
end
local function genQueen(b,x,y,color,moves)
  slideGen(b,x,y,color,moves,{{1,0},{-1,0},{0,1},{0,-1},{1,1},{1,-1},{-1,1},{-1,-1}})
end
local function genKing(b,x,y,color,moves)
  for dx=-1,1 do for dy=-1,1 do if not(dx==0 and dy==0) then
    local nx, ny = x+dx, y+dy
    if inBounds(nx,ny) then
      local p = b[ny][nx]
      if (not p or p:sub(1,1)~=color) then
        addMove(moves,x,y,nx,ny,p~=nil)
      end
    end
  end end
end

local dispatch = {P=genPawn, N=genKnight, B=genBishop, R=genRook, Q=genQueen, K=genKing}

local function generateMovesFor(b, x,y)
  local p = b[y][x]
  if not p then return {} end
  local color = p:sub(1,1)
  local t = p:sub(2,2)
  local moves = {}
  dispatch[t](b, x, y, color, moves)
  -- filter illegal moves that leave king in check
  local legal = {}
  for _,m in ipairs(moves) do
    local nb = cloneBoard(b)
    -- perform move
    nb[m.toY][m.toX] = nb[y][x]
    nb[y][x] = nil
    -- promotion
    if nb[m.toY][m.toX]:sub(2,2)=='P' and m.toY==promoRank[color] then
      nb[m.toY][m.toX] = color..'Q'
    end
    if not isInCheck(nb, color) then table.insert(legal, m) end
  end
  return legal
end

local function allLegalMoves(b, color)
  local all = {}
  for y=1,8 do for x=1,8 do
    local p = b[y][x]
    if p and p:sub(1,1)==color then
      local ms = generateMovesFor(b,x,y)
      for _,m in ipairs(ms) do table.insert(all, m) end
    end
  end end
  return all
end

local function makeMove(m)
  local p = board[m.fromY][m.fromX]
  board[m.toY][m.toX] = p
  board[m.fromY][m.fromX] = nil
  -- promotion to queen
  local color = p:sub(1,1)
  if p:sub(2,2)=='P' and m.toY==promoRank[color] then
    board[m.toY][m.toX] = color..'Q'
  end
  -- switch turn
  turn = other(turn)
  selected = nil
  legalMoves = {}
  -- update status
  local inCheck = isInCheck(board, turn)
  local moves = allLegalMoves(board, turn)
  if #moves==0 then
    gameOver = true
    if inCheck then statusText = (turn=='w' and 'White' or 'Black') .. ' is checkmated.'
    else statusText = 'Stalemate.' end
  else
    if inCheck then statusText = 'Check!' else statusText = '' end
  end
end

local function findMoveFromLegal(x,y)
  for _,m in ipairs(legalMoves) do
    if m.toX==x and m.toY==y then return m end
  end
end

-- Rendering
local function drawBoard()
  for y=1,8 do
    for x=1,8 do
      local isLight = (x + y) % 2 == 0
      love.graphics.setColor(isLight and lightColor or darkColor)
      love.graphics.rectangle('fill', boardOffsetX + (x-1)*sqSize, boardOffsetY + (y-1)*sqSize, sqSize, sqSize, 4, 4)
    end
  end
  -- coordinates
  love.graphics.setColor(0,0,0,0.5)
  for x=1,8 do
    love.graphics.print(string.char(96+x), boardOffsetX + (x-1)*sqSize + 4, boardOffsetY + 8*sqSize + 6)
  end
  for y=1,8 do
    love.graphics.print(tostring(9-y), boardOffsetX - 18, boardOffsetY + (y-1)*sqSize + 6)
  end
end

local function drawHighlights()
  if selected then
    love.graphics.setColor(selectColor)
    love.graphics.rectangle('line', boardOffsetX + (selected.x-1)*sqSize, boardOffsetY + (selected.y-1)*sqSize, sqSize, sqSize, 6, 6)
    love.graphics.setLineWidth(3)
    -- legal moves
    for _,m in ipairs(legalMoves) do
      local cx = boardOffsetX + (m.toX-1)*sqSize + sqSize/2
      local cy = boardOffsetY + (m.toY-1)*sqSize + sqSize/2
      if m.capture then love.graphics.setColor(captureColor) else love.graphics.setColor(moveColor) end
      love.graphics.circle('fill', cx, cy, 12)
    end
    love.graphics.setLineWidth(1)
  end
end

local function drawPieces()
  love.graphics.setColor(0,0,0)
  for y=1,8 do
    for x=1,8 do
      local p = board[y][x]
      if p then
        local g = pieceGlyph[p]
        if g then
          local px = boardOffsetX + (x-1)*sqSize + sqSize/2
          local py = boardOffsetY + (y-1)*sqSize + sqSize/2 - 6
          local tw = font:getWidth(g)
          local th = font:getHeight()
          love.graphics.print(g, px - tw/2, py - th/2)
        else
          -- fallback single-letter
          local label = p:sub(2,2)
          love.graphics.print(label, boardOffsetX + (x-1)*sqSize + 10, boardOffsetY + (y-1)*sqSize + 10)
        end
      end
    end
  end
end

local function screenToBoard(mx, my)
  local x = math.floor((mx - boardOffsetX) / sqSize) + 1
  local y = math.floor((my - boardOffsetY) / sqSize) + 1
  if inBounds(x,y) then return x,y end
  return nil
end

-- LÖVE callbacks
function love.load()
  love.window.setTitle("LÖVE Chess")
  love.window.setMode(8*sqSize + boardOffsetX*2, 8*sqSize + boardOffsetY*2 + 60)
  font = love.graphics.newFont(48)
  love.graphics.setFont(font)
  parseFEN(startFEN)
  statusText = ''
end

function love.draw()
  love.graphics.clear(0.95,0.95,0.97)
  drawBoard()
  drawHighlights()
  drawPieces()
  -- HUD
  love.graphics.setColor(0,0,0)
  local turnText = gameOver and "Game Over" or ((turn=='w' and 'White' or 'Black') .. " to move")
  love.graphics.print(turnText .. (statusText ~= '' and ("  -  "..statusText) or ''), boardOffsetX, boardOffsetY + 8*sqSize + 24)
  love.graphics.print("R = restart", boardOffsetX, boardOffsetY + 8*sqSize + 24 + 30)
end

function love.mousepressed(mx, my, button)
  if button ~= 1 or gameOver then return end
  local x,y = screenToBoard(mx,my)
  if not x then return end
  if selected then
    local mv = findMoveFromLegal(x,y)
    if mv then
      makeMove(mv)
      return
    end
  end
  local p = board[y][x]
  if p and p:sub(1,1)==turn then
    selected = {x=x,y=y}
    legalMoves = generateMovesFor(board, x, y)
  else
    selected = nil
    legalMoves = {}
  end
end

function love.keypressed(key)
  if key=='r' then
    parseFEN(startFEN)
    turn='w'
    selected=nil
    legalMoves={}
    gameOver=false
    statusText=''
  end
end
