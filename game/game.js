(function() {
  var Bullet, PlayState, Player, WZPhysics, WZSlopeTile, game,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Bullet = (function(_super) {
    __extends(Bullet, _super);

    function Bullet(game) {
      Bullet.__super__.constructor.call(this, game, 0, 0);
    }

    return Bullet;

  })(Phaser.Sprite);

  PlayState = (function(_super) {
    __extends(PlayState, _super);

    function PlayState() {}

    PlayState.prototype.create = function() {
      this.farBackground = game.add.tileSprite(0, 0, 800, 600, 'far_background');
      this.farBackground.fixedToCamera = true;
      this.nearBackground = game.add.tileSprite(0, 0, 800, 600, 'near_background');
      this.nearBackground.fixedToCamera = true;
      this.loadMap('test', 'tiles');
      this.mapData = game.cache.getTilemapData('test');
      this.player = new Player(game, 100, 140);
      game.add.existing(this.player);
      return game.camera.follow(this.player, Phaser.Camera.FOLLOW_TOPDOWN_TIGHT);
    };

    PlayState.prototype.preload = function() {
      game.stage.backgroundColor = '#6CB5E6';
      game.stage.scaleMode = Phaser.StageScaleMode.SHOW_ALL;
      game.stage.scale.scaleFactor.setTo(2, 2);
      game.stage.scale.maxWidth = 800;
      game.stage.scale.maxHeight = 600;
      game.stage.scale.setSize();
      game.stage.scale.refresh();
      game.load.image('player', 'assets/gfx/player.png');
      game.load.image('far_background', 'assets/gfx/far_background.png');
      game.load.image('near_background', 'assets/gfx/near_background.png');
      game.load.tilemap('test', 'assets/levels/test.json', null, Phaser.Tilemap.TILED_JSON);
      return game.load.tileset('tiles', 'assets/gfx/tiles.png', 32, 32);
    };

    PlayState.prototype.render = function() {
      this.farBackground.tilePosition.x = -(this.camera.x / 8);
      this.nearBackground.tilePosition.x = -(this.camera.x / 6);
      return this.nearBackground.tilePosition.y = -(this.camera.y / 6);
    };

    PlayState.prototype.loadMap = function(map, tiles) {
      var tileset;
      map = game.add.tilemap(map);
      tileset = game.add.tileset(tiles);
      tileset.setCollisionRange(1, 36, true, true, true, true, this.walls = game.add.tilemapLayer(0, 0, 400, 300, tileset, map, 0));
      return this.walls.resizeWorld();
    };

    PlayState.prototype.update = function() {
      return game.physics.collide(this.player, this.walls);
    };

    return PlayState;

  })(Phaser.State);

  Player = (function(_super) {
    __extends(Player, _super);

    Player.Facing = {
      LEFT: -1,
      RIGHT: 1
    };

    function Player(game, x, y) {
      Player.__super__.constructor.call(this, game, x, y, 'player');
      this.flySpeed = 150;
      this.acceleration = 900;
      this.body = new Phaser.Physics.Arcade.Body(this);
      this.body.maxVelocity.setTo(this.flySpeed, this.flySpeed);
      this.body.drag.setTo(600, 600);
      this.facing = Player.Facing.RIGHT;
      this.anchor.setTo(.5, 1);
      this.keys = game.input.keyboard.createCursorKeys();
      this.keys.noTurn = game.input.keyboard.addKey(Phaser.Keyboard.C);
      this.keys.shoot = game.input.keyboard.addKey(Phaser.Keyboard.X);
    }

    Player.prototype.update = function() {
      if (this.keys.left.justPressed() && this.body.velocity.x > 0) {
        this.body.velocity.x = 0;
      } else if (this.keys.right.justPressed() && this.body.velocity.x < 0) {
        this.body.velocity.x = 0;
      }
      if (this.keys.up.justPressed() && this.body.velocity.y > 0) {
        this.body.velocity.y = 0;
      } else if (this.keys.down.justPressed() && this.body.velocity.y < 0) {
        this.body.velocity.y = 0;
      }
      if (this.keys.right.isDown) {
        this.body.acceleration.x = this.acceleration;
      } else if (this.keys.left.isDown) {
        this.body.acceleration.x = 0 - this.acceleration;
      } else {
        this.body.acceleration.x = 0;
      }
      if (this.keys.down.isDown) {
        this.body.acceleration.y = this.acceleration;
      } else if (this.keys.up.isDown) {
        this.body.acceleration.y = 0 - this.acceleration;
      } else {
        this.body.acceleration.y = 0;
      }
      if (!this.keys.noTurn.isDown) {
        if (this.body.velocity.x > 0) {
          this.facing = Player.Facing.RIGHT;
        } else if (this.body.velocity.x < 0) {
          this.facing = Player.Facing.LEFT;
        }
      }
      return this.scale.x = this.facing;
    };

    return Player;

  })(Phaser.Sprite);

  game = new Phaser.Game(400, 300, Phaser.CANVAS, 'wonderzone', new PlayState(), false, false);

  WZPhysics = (function(_super) {
    __extends(WZPhysics, _super);

    function WZPhysics(game) {
      WZPhysics.__super__.constructor.call(this, game);
    }

    WZPhysics.prototype.isInsideSlopeTile = function(p, tile) {
      var p1, p2, p3, _ref;
      _ref = tile.triangle, p1 = _ref[0], p2 = _ref[1], p3 = _ref[2];
      return det(p, p1, p2) >= 0 && det(p, p2, p3) >= 0 && det(p, p3, p1) >= 0;
    };

    WZPhysics.prototype.det = function(p1, p2, p3) {
      return p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + p3.x * (p1.y - p2.y);
    };

    return WZPhysics;

  })(Phaser.Physics.Arcade);

  WZSlopeTile = (function() {
    function WZSlopeTile(tileset, index, x, y, width, height, slope) {
      this.tile = new Phaser.Tile(tileset, index, x, y, width, height);
      this.triangle = WZSlopeTile.slopes[slope].call(this, x, y, width, height);
    }

    return WZSlopeTile;

  })();

  WZSlopeTile.slopes = {
    TopRight45: function() {
      return [new Phaser.Point(0, 0), new Phaser.Point(this.x + this.width, this.y + this.height), new Phaser.Point(this.x, this.y + this.height)];
    },
    TopLeft45: function() {
      return [new Phaser.Point(this.x + this.width, this.y), new Phaser.Point(this.x + this.width, this.y + this.height), new Phaser.Point(this.x, this.y + this.height)];
    },
    BottomRight45: function() {
      return [new Phaser.Point(this.x, this.y), new Phaser.Point(this.x + this.width, this.y), new Phaser.Point(this.x + this.width, this.y + this.height)];
    },
    BottomLeft45: function() {
      return [new Phaser.Point(this.x, this.y), new Phaser.Point(this.x + this.width, this.y), new Phaser.Point(this.x, this.y + this.height)];
    }
  };

}).call(this);

/*
//@ sourceMappingURL=game.js.map
*/