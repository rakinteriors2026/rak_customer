import 'dart:async';

import 'package:rak_customer/core/domain/repositories/cart_count_repository.dart';
import 'package:rak_customer/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:rak_customer/features/cart/domain/repositories/cart_repository.dart';

class CartCountRepositoryImpl implements CartCountRepository {
  CartCountRepositoryImpl(this._cart, this._local);

  final CartRepository _cart;
  final CartLocalDatasource _local;
  final Map<String, _CartCountFeed> _feeds = {};

  @override
  Future<int> itemCount({String? accountId}) async {
    final result = await _cart.getCart(accountId: accountId);
    final cart = result.valueOrNull;
    if (cart == null) return 0;
    var count = 0;
    for (final line in cart.lines) {
      count += line.quantity;
    }
    return count;
  }

  @override
  Stream<int> watch({String? accountId}) {
    final key = accountId ?? '';
    final feed = _feeds.putIfAbsent(
      key,
      () => _CartCountFeed(_local, accountId),
    );
    return feed.stream;
  }

  Future<void> close() async {
    final feeds = _feeds.values.toList();
    _feeds.clear();
    for (final feed in feeds) {
      await feed.close();
    }
  }
}

class _CartCountFeed {
  _CartCountFeed(CartLocalDatasource local, String? accountId) {
    _subscription = local.watchItemCount(accountId: accountId).listen((count) {
      _latest = count;
      if (!_controller.isClosed) _controller.add(count);
    });
  }

  final StreamController<int> _controller = StreamController<int>.broadcast();
  late final StreamSubscription<int> _subscription;
  int? _latest;

  Stream<int> get stream {
    return Stream<int>.multi((listener) {
      final latest = _latest;
      if (latest != null) listener.add(latest);
      final subscription = _controller.stream.listen(
        listener.add,
        onError: listener.addError,
      );
      listener.onCancel = () {
        subscription.cancel();
      };
    });
  }

  Future<void> close() async {
    await _subscription.cancel();
    await _controller.close();
  }
}
