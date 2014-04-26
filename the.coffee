canvas = document.createElement("canvas")
canvas.width = innerWidth
canvas.height = innerHeight
ctx = canvas.getContext("2d")
zctx = new ZoomContext(ctx)

grid = {}
squares = []
lowest = { x: 0, y: 0 }
highest = { x: 0, y: 0 }

at = (x, y) -> grid["#{x},#{y}"]

addSquare = (square) ->

  x = square.x
  y = square.y

  squares.push square
  grid["#{x},#{y}"] = square

  if lowest.x > x
    lowest.x = x
  if lowest.y > y
    lowest.y = y
  if highest.x < x
    highest.x = x
  if highest.y < y
    highest.y = y

class Square

  constructor: (@x, @y) ->
    color = Spectra.random()
    while color.isDark()
      color = Spectra.random()
    @color = color.hex()

  placeAdjacent: ->

    added = no

    if not at(@x - 1, @y)
      addSquare new Square(@x - 1, @y)
      added = yes
    if not at(@x + 1, @y)
      addSquare new Square(@x + 1, @y)
      added = yes
    if not at(@x, @y - 1)
      addSquare new Square(@x, @y - 1)
      added = yes
    if not at(@x, @y + 1)
      addSquare new Square(@x, @y + 1)
      added = yes

    return added

  draw: (zctx) ->
    zctx.fillStyle = @color
    zctx.fillRect(@x - 0.5, @y - 0.5, 1, 1)

addSquare new Square(0, 0)
zctx.keepInView
  coordinates: [lowest, highest]
  padding: 1

second = -1

tick = (t) ->

  onSecond = no
  if Math.floor(t / 1000) > second
    onSecond = yes
    second += 1

  zctx.clear()

  if onSecond
    zctx.keepInView
      coordinates: [lowest, highest]
      forceCenter: { x: 0, y: 0 }
      padding: 3
      tween:
        time: 1000

  appendTo = Math.floor(Math.random() * squares.length)
  for square, index in squares
    square.draw(zctx)
    if index is appendTo
      square.placeAdjacent()

  requestAnimationFrame tick

tick()

loadingEl = document.querySelector(".loading")
loadingEl.style.display = "none"

document.body.appendChild canvas
