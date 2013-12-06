# Phaser.TilemapParser.tileset = (game, key, tileWidth, tileHeight, tileMax, tileMargin, tileSpacing) ->
#       tileproperties =
#         18:
#           "slope": "TopRight45"
#         19:
#           "slope": "TopLeft45"
#         8:
#           "slope": "BottomRight45"
#         9:
#           "slope":"BottomLeft45"

#       #  How big is our image?
#       img = game.cache.getTilesetImage(key)

#       if (img == null)
#         return null

#       width = img.width
#       height = img.height

#       #  If no tile width/height is given, try and figure it out (won't work if the tileset has margin/spacing)
#       if (tileWidth <= 0)
#         tileWidth = Math.floor(-width / Math.min(-1, tileWidth))

#       if (tileHeight <= 0)
#         tileHeight = Math.floor(-height / Math.min(-1, tileHeight))

#       row = Math.round(width / tileWidth)
#       column = Math.round(height / tileHeight)
#       total = row * column
      
#       if (tileMax != -1)
#         total = tileMax

#       #  Zero or smaller than tile sizes?
#       if (width == 0 || height == 0 || width < tileWidth || height < tileHeight || total == 0)
#         console.warn("Phaser.TilemapParser.tileSet: width/height zero or width/height < given tileWidth/tileHeight")
#         return null

#       #  Let's create some tiles
#       x = tileMargin
#       y = tileMargin

#       tileset = new Phaser.Tileset(img, key, tileWidth, tileHeight, tileMargin, tileSpacing)

#       for i in [0 .. total]
#         if tileproperties[i]?
#           tileset.addTile new WZSlopeTile tileset, i, x, y, tileWidth, tileHeight, tileproperties[i].slope
#         else
#           tileset.addTile(new Phaser.Tile(tileset, i, x, y, tileWidth, tileHeight))

#         x += tileWidth + tileSpacing

#         if (x == width)
#           x = tileMargin
#           y += tileHeight + tileSpacing

#       console.log tileset
#       return tileset