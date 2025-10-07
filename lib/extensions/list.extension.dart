extension ListExtension<T> on List<T> {
  void assignAll(final Iterable<T> items) {
    clear();
    addAll(items);
  }
}
