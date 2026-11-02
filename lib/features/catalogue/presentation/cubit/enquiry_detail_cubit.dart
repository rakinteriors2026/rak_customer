import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/catalogue/domain/entities/product_enquiry.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/get_product_enquiry.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/update_enquiry_status.dart';

sealed class EnquiryDetailState {
  const EnquiryDetailState();
}

class EnquiryDetailLoading extends EnquiryDetailState {
  const EnquiryDetailLoading();
}

class EnquiryDetailLoaded extends EnquiryDetailState {
  const EnquiryDetailLoaded(this.enquiry);
  final ProductEnquiry enquiry;
}

class EnquiryDetailError extends EnquiryDetailState {
  const EnquiryDetailError(this.message);
  final String message;
}

class EnquiryDetailCubit extends Cubit<EnquiryDetailState> {
  EnquiryDetailCubit({
    required GetProductEnquiry getProductEnquiry,
    required UpdateEnquiryStatus updateEnquiryStatus,
    required this.enquiryId,
  }) : _getProductEnquiry = getProductEnquiry,
       _updateEnquiryStatus = updateEnquiryStatus,
       super(const EnquiryDetailLoading());

  final GetProductEnquiry _getProductEnquiry;
  final UpdateEnquiryStatus _updateEnquiryStatus;
  final String enquiryId;

  Future<void> load() async {
    emit(const EnquiryDetailLoading());
    final result = await _getProductEnquiry(enquiryId);
    result.fold(
      onSuccess: (enquiry) => emit(EnquiryDetailLoaded(enquiry)),
      onFailure: (failure) => emit(EnquiryDetailError(failure.message)),
    );
  }

  Future<void> advance(String status) async {
    final current = state;
    if (current is! EnquiryDetailLoaded) return;
    final result = await _updateEnquiryStatus(
      enquiryId: enquiryId,
      status: status,
    );
    result.fold(
      onSuccess: (enquiry) => emit(EnquiryDetailLoaded(enquiry)),
      onFailure: (failure) => emit(EnquiryDetailError(failure.message)),
    );
  }
}
