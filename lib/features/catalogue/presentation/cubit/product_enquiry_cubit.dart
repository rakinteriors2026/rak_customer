import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/submit_product_enquiry.dart';

sealed class ProductEnquiryState {
  const ProductEnquiryState();
}

class ProductEnquiryReady extends ProductEnquiryState {
  const ProductEnquiryReady({this.submitting = false, this.errorMessage});

  final bool submitting;
  final String? errorMessage;
}

class ProductEnquirySuccess extends ProductEnquiryState {
  const ProductEnquirySuccess();
}

class ProductEnquiryCubit extends Cubit<ProductEnquiryState> {
  ProductEnquiryCubit({
    required SubmitProductEnquiry submitProductEnquiry,
    this.productId,
    this.accountId,
  }) : _submitProductEnquiry = submitProductEnquiry,
       super(const ProductEnquiryReady());

  final SubmitProductEnquiry _submitProductEnquiry;
  final String? productId;
  final String? accountId;

  Future<void> submit(String message) async {
    final current = state;
    if (current is! ProductEnquiryReady || current.submitting) return;
    emit(const ProductEnquiryReady(submitting: true));
    final result = await _submitProductEnquiry(
      message: message,
      productId: productId,
      accountId: accountId,
    );
    if (isClosed) return;
    result.fold(
      onSuccess: (_) => emit(const ProductEnquirySuccess()),
      onFailure: (failure) =>
          emit(ProductEnquiryReady(errorMessage: failure.message)),
    );
  }
}
