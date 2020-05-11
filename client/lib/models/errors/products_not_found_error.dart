class ProductsNotFoundError implements Exception {
  ProductsNotFoundError(this.notFoundIds);

  final List<String> notFoundIds;

  @override
  String toString() {
    return 'The following ids weren\'t found $notFoundIds';
  }
}
