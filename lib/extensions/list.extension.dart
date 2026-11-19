extension ListExtension<T> on List<T> {
  void assignAll(Iterable<T> items) {
    clear();
    addAll(items);
  }
}
