class Player extends Phaser.Sprite
  Player.Facing =
    LEFT: -1
    RIGHT: 1

  constructor: (game, x, y) ->
    super game, x, y, 'player'
    
    # Set base physics. This will be replaced with item-based physics.
    @flySpeed = 150
    @acceleration = 900

    @body = new Phaser.Physics.Arcade.Body @
    @body.maxVelocity.setTo @flySpeed, @flySpeed
    @body.drag.setTo 600, 600

    @facing = Player.Facing.RIGHT

    @cursors = game.input.keyboard.createCursorKeys()
    # @scale.setTo 2, 2
    @anchor.setTo .5, 1

    @keys =
      c: game.input.keyboard.addKey Phaser.Keyboard.C

  update: ->
    # If we're moving in a direction and press the opposite one, stop immediately.
    if @cursors.left.justPressed() and @body.velocity.x > 0
      @body.velocity.x = 0
    else if @cursors.right.justPressed() and @body.velocity.x < 0
      @body.velocity.x = 0

    if @cursors.up.justPressed() and @body.velocity.y > 0
      @body.velocity.y = 0
    else if @cursors.down.justPressed() and @body.velocity.y < 0
      @body.velocity.y = 0

    # Set the acceleration depending on keys pressed.
    if @cursors.right.isDown
      @body.acceleration.x = @acceleration
    else if @cursors.left.isDown
      @body.acceleration.x = 0 - @acceleration
    else
      @body.acceleration.x = 0

    if @cursors.down.isDown
      @body.acceleration.y = @acceleration
    else if @cursors.up.isDown
      @body.acceleration.y = 0 - @acceleration
    else
      @body.acceleration.y = 0

    # Flip the sprite if we've turned.
    if !@keys.c.isDown
      if @body.velocity.x > 0
        @facing = Player.Facing.RIGHT
      else if @body.velocity.x < 0
        @facing = Player.Facing.LEFT

    @scale.x = @facing
