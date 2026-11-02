import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/catalogue/domain/entities/product_enquiry.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/list_product_enquiries.dart';

sealed class EnquiryListState {
  const EnquiryListState();
}

class EnquiryListLoading extends EnquiryListState {
  const EnquiryListLoading();
}

class EnquiryListEmpty extends EnquiryListState {
  const EnquiryListEmpty();
}

class EnquiryListLoaded extends EnquiryListState {
  const EnquiryListLoaded(this.enquiries);
  final List<ProductEnquiry> enquiries;
}

class EnquiryListError extends EnquiryListState {
  const EnquiryListError(this.message);
  final String message;
}

class EnquiryListCubit extends Cubit<EnquiryListState> {
  EnquiryListCubit({
    required ListProductEnquiries listProductEnquiries,
    this.accountId,
  }) : _listProductEnquiries = listProductEnquiries,
       super(const EnquiryListLoading());

  final ListProductEnquiries _listProductEnquiries;
  final String? accountId;

  Future<void> load() async {
    emit(const EnquiryListLoading());
    final result = await _listProductEnquiries(accountId: accountId);
    result.fold(
      onSuccess: (enquiries) {
        if (enquiries.isEmpty) {
          emit(const EnquiryListEmpty());
        } else {
          emit(EnquiryListLoaded(enquiries));
        }
      },
      onFailure: (failure) => emit(EnquiryListError(failure.message)),
    );
  }
}
