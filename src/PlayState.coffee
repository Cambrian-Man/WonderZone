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