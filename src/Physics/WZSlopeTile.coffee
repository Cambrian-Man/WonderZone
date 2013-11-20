class WZSlopeTile extends Phaser.Tile
  constructor: (tileset, index, x, y, width, height, slope) ->
    __super__ = new Phaser.Tile tileset, index, x, y, width, height
    console.log @

    @triangle = WZSlopeTile.slopes[slope].call @, x, y, width, height

WZSlopeTile.slopes =
  TopRight45: -> 
    return [
      new Phaser.Point 0, 0
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