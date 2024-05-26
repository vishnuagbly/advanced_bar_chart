class Direction {
  final int x, y;

  const Direction(this.x, this.y);

  static const Direction up = Direction(0, -1);
  static const Direction down = Direction(0, 1);
  static const Direction left = Direction(-1, 0);
  static const Direction right = Direction(1, 0);

  @override
  bool operator ==(Object other) =>
      other is Direction && other.x == x && other.y == y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
