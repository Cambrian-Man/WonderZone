class Bullet extends Phaser.Sprite
  constructor: (game) ->
    super game, 0, 0
class Physics extends Phaser.Physics.Arcade
  constructor: (game) ->
    super game
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
    @player = new Player game, 100, 100
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

    layer = game.add.tilemapLayer 0, 0, 400, 300, tileset, map, 0
    layer.resizeWorld()
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

    @facing = WZ.Player.Facing.RIGHT


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

class SlopeTile extends Phaser.Tile
  constructor: (tileset, index, x, y, width, height, slope) ->
    super tileset, index, x, y, width, height

    @triangle = call @, SlopeTile.slopes[slope]

SlopeTile.slopes =
  TopRight45: -> 
    return [
      new Phaser.Point(@x, @y)
      new Phaser.Point(@x + @width, @y + @height)
      new Phaser.Point(@x, @y + @height)
    ]
  TopLeft45: ->
    return [
      new Phaser.Point(@x + @width, @y)
      new Phaser.Point(@x + @width, @y + @height)
      new Phaser.Point(@x, @y + @height)
    ]
game = new Phaser.Game 400, 300, Phaser.CANVAS, 'wonderzone', new PlayState(), false, false