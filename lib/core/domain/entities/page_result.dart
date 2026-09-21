class PageResult<T> {
  const PageResult({required this.items, this.nextCursor});

  final List<T> items;
  final String? nextCursor;

  bool get isEmpty => items.isEmpty;
  bool get hasMore => nextCursor != null;
}
