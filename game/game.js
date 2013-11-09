(function() {
  var PlayState, game,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  PlayState = (function(_super) {
    __extends(PlayState, _super);

    function PlayState() {
      console.log('Construct');
    }

    PlayState.prototype.preload = function() {
      game.stage.backgroundColor = '#000000';
      return console.log(game.stage);
    };

    return PlayState;

  })(Phaser.State);

  game = new Phaser.Game(800, 600, Phaser.CANVAS, 'wonderzone', new PlayState(), false, false);

}).call(this);

/*
//@ sourceMappingURL=game.js.map
*/