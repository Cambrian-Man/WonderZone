class SlopeTile extends Phaser.Tile
  constructor: (tileset, index, x, y, width, height, slope) ->
    super tileset, index, x, y, width, height

    @triangle = call @, SlopeTile.slopes[slope]

SlopeTile.slopes =
  TopRight45: -> 
    return [
      new Phaser.Point @x, @y
      new Phaser.Point @x + @width, @y + @height
      new Phaser.Point @x, @y + @height
    ]
  TopLeft45: ->
    return [
      new Phaser.Point @x + @width, @y
      new Phaser.Point @x + @width, @y + @height
      new Phaser.Point @x, @y + @height
    ]
  BottomRight45: ->
    return [
      new Phaser.Point @x, @y
      new Phaser.Point @x + @width, @y
      new Phaser.Point @x + @width, @y + @height
    ]
  BottomLeft45: ->
    return [
      new Phaser.Point @x, @y
      new Phaser.Point @x + @width, @y
      new Phaser.Point @x, @y + @height
    ]