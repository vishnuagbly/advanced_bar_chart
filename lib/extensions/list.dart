extension ListExt<T> on List<T> {
  T? get(int index) {
    try {
      return this[index];
    } catch (err) {
      return null;
    }
  }
}
