import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritesCubit extends Cubit<Set<String>> {
  FavouritesCubit() : super(const {});

  void toggle(String productId) {
    final next = {...state};
    if (!next.add(productId)) {
      next.remove(productId);
    }
    emit(next);
  }
}
