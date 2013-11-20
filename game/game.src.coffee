class Bullet extends Phaser.Sprite
  constructor: (game) ->
    super game, 0, 0
class PlayState extends Phaser.State
  constructor: ->

  create: ->
    # Set up backgrounds
    @farBackground = game.add.tileSprite 0, 0, 800, 600, 'far_background'
    @farBackground.fixedToCamera = true

    @nearBackground = game.add.tileSprite 0, 0, 800, 600, 'near_background'
    @nearBackground.fixedToCamera = true

    @loadMap 'test', 'tiles'

    # Set up player
    @player = new Player game, 100, 140
    game.add.existing @player
    game.camera.follow @player, Phaser.Camera.FOLLOW_TOPDOWN_TIGHT

  preload: ->
    game.stage.backgroundColor = '#6CB5E6'
    game.stage.scaleMode = Phaser.StageScaleMode.SHOW_ALL
    game.stage.scale.scaleFactor.setTo 2, 2
    game.stage.scale.maxWidth = 800
    game.stage.scale.maxHeight = 600
    game.stage.scale.setSize()
    game.stage.scale.refresh()

    # Load Images
    game.load.image 'player', 'assets/gfx/player.png'
    game.load.image 'far_background', 'assets/gfx/far_background.png'
    game.load.image 'near_background', 'assets/gfx/near_background.png'

    # Load Levels and Tilemaps
    game.load.tilemap 'test', 'assets/levels/test.json', null, Phaser.Tilemap.TILED_JSON
    game.load.tileset 'tiles', 'assets/gfx/tiles.png', 32, 32

  render: ->
    @farBackground.tilePosition.x = -(@camera.x / 8)
    @nearBackground.tilePosition.x = -(@camera.x / 6)
    @nearBackground.tilePosition.y = -(@camera.y / 6)

  # Given a key for a map, loads the map.
  loadMap: (map, tiles) ->
    map = game.add.tilemap map
    tileset = game.add.tileset tiles
    tileset.setCollisionRange 1, 36, true, true, true, true,

    @walls = game.add.tilemapLayer 0, 0, 400, 300, tileset, map, 0
    @walls.resizeWorld()

  update: ->
    game.physics.collide @player, @walls 
class Player extends Phaser.Sprite
  Player.Facing =
    LEFT: -1
    RIGHT: 1

  constructor: (game, x, y) ->
    super game, x, y, 'player'
    
    # Set base physics. This will be replaced with item-based physics.
    @flySpeed = 150
    @acceleration = 900

    # Create our physics body
    @body = new Phaser.Physics.Arcade.Body @
    @body.maxVelocity.setTo @flySpeed, @flySpeed
    @body.drag.setTo 600, 600

    @facing = Player.Facing.RIGHT


    @anchor.setTo .5, 1

    @keys = game.input.keyboard.createCursorKeys()
    @keys.noTurn = game.input.keyboard.addKey Phaser.Keyboard.C
    @keys.shoot = game.input.keyboard.addKey Phaser.Keyboard.X

  update: ->
    # If we're moving in a direction and press the opposite one, stop immediately.
    if @keys.left.justPressed() and @body.velocity.x > 0
      @body.velocity.x = 0
    else if @keys.right.justPressed() and @body.velocity.x < 0
      @body.velocity.x = 0

    if @keys.up.justPressed() and @body.velocity.y > 0
      @body.velocity.y = 0
    else if @keys.down.justPressed() and @body.velocity.y < 0
      @body.velocity.y = 0

    # Set the acceleration depending on keys pressed.
    if @keys.right.isDown
      @body.acceleration.x = @acceleration
    else if @keys.left.isDown
      @body.acceleration.x = 0 - @acceleration
    else
      @body.acceleration.x = 0

    if @keys.down.isDown
      @body.acceleration.y = @acceleration
    else if @keys.up.isDown
      @body.acceleration.y = 0 - @acceleration
    else
      @body.acceleration.y = 0

    # Flip the sprite if we've turned.
    if !@keys.noTurn.isDown
      if @body.velocity.x > 0
        @facing = Player.Facing.RIGHT
      else if @body.velocity.x < 0
        @facing = Player.Facing.LEFT

    @scale.x = @facing

game = new Phaser.Game 400, 300, Phaser.CANVAS, 'wonderzone', new PlayState(), false, false
class WZPhysics extends Phaser.Physics.Arcade
  constructor: (game) ->
    super game

  # Returns true if the point p is inside the given tile.
  isInsideSlopeTile: (p, tile) ->
    [p1, p2, p3] = tile.triangle
    det(p, p1, p2) >=0 && det(p, p2, p3) >= 0 && det(p, p3, p1) >= 0

  # Gets the determinant of three points forming a triangle.
  det: (p1, p2, p3) ->
    p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + p3.x * (p1.y - p2.y)
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
Phaser.TilemapParser.tileset = (game, key, tileWidth, tileHeight, tileMax, tileMargin, tileSpacing) ->
      tileproperties =
        18:
          "slope": "TopRight45"
        19:
          "slope": "TopLeft45"
        8:
          "slope": "BottomRight45"
        9:
          "slope":"BottomLeft45"

      #  How big is our image?
      img = game.cache.getTilesetImage(key)

      if (img == null)
        return null

      width = img.width
      height = img.height

      #  If no tile width/height is given, try and figure it out (won't work if the tileset has margin/spacing)
      if (tileWidth <= 0)
        tileWidth = Math.floor(-width / Math.min(-1, tileWidth))

      if (tileHeight <= 0)
        tileHeight = Math.floor(-height / Math.min(-1, tileHeight))

      row = Math.round(width / tileWidth)
      column = Math.round(height / tileHeight)
      total = row * column
      
      if (tileMax != -1)
        total = tileMax

      #  Zero or smaller than tile sizes?
      if (width == 0 || height == 0 || width < tileWidth || height < tileHeight || total == 0)
        console.warn("Phaser.TilemapParser.tileSet: width/height zero or width/height < given tileWidth/tileHeight")
        return null

      #  Let's create some tiles
      x = tileMargin
      y = tileMargin

      tileset = new Phaser.Tileset(img, key, tileWidth, tileHeight, tileMargin, tileSpacing)

      for i in [0 .. total]
        if tileproperties[i]?
          tileset.addTile new WZSlopeTile tileset, i, x, y, tileWidth, tileHeight, tileproperties[i].slope
        else
          tileset.addTile(new Phaser.Tile(tileset, i, x, y, tileWidth, tileHeight))

        x += tileWidth + tileSpacing

        if (x == width)
          x = tileMargin
          y += tileHeight + tileSpacing

      console.log tileset
      return tileset