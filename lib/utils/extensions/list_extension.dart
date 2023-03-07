extension BetterList<T> on List<T> {
  List<T> padRight(int count, T fill) {
    while (length < count) {
      add(fill);
    }

    return this;
  }

  List<T> padLeft(int count, T fill) {
    while (length < count) {
      insert(0, fill);
    }

    return this;
  }
}
