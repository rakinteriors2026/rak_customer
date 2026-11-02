/// How many pieces are currently in the shopper's cart.
abstract class CartCountRepository {
  Future<int> itemCount({String? accountId});

  /// Emits the current count, then again whenever the cart changes.
  Stream<int> watch({String? accountId});
}
