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
