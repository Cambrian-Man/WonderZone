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