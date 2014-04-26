canvas = document.createElement("canvas")
canvas.width = innerWidth
canvas.height = innerHeight
ctx = canvas.getContext("2d")
zctx = new ZoomContext(ctx)

squares = []

class Square

  constructor: (@x, @y) ->
    color = Spectra.random()
    while color.isDark()
      color = Spectra.random()
    @color = color.hex()

  placeAdjacent: ->

    up = yes
    down = yes
    left = yes
    right = yes

    for square in squares

      continue if this is square

      if (square.x - 1 is @x) and (square.y is @y)
        right = no
      else if (square.x + 1 is @x) and (square.y is @y)
        left = no
      else if (square.y - 1 is @y) and (square.x is @x)
        down = no
      else if (square.y + 1 is @y) and (square.x is @x)
        up = no

    if up
      squares.push new Square(@x, @y - 1)
    else if down
      squares.push new Square(@x, @y + 1)
    else if left
      squares.push new Square(@x - 1, @y)
    else if right
      squares.push new Square(@x + 1, @y)

    return up or down or left or right

  draw: (zctx) ->
    zctx.fillStyle = @color
    zctx.fillRect(@x - 0.5, @y - 0.5, 1, 1)

squares.push new Square(0, 0)

second = -1

tick = (t) ->

  zctx.clear()

  zctx.keepInView
    coordinates: squares
    padding: 1

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
