class PlayState extends Phaser.State
  constructor: ->
    console.log 'Construct'

  preload: ->
    game.stage.backgroundColor = '#000000'
    console.log game.stage
game = new Phaser.Game 800, 600, Phaser.CANVAS, 'wonderzone', new PlayState(), false, false