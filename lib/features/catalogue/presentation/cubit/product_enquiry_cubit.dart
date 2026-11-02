import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/catalogue/domain/entities/product_enquiry.dart';
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
  const ProductEnquirySuccess(this.enquiry);
  final ProductEnquiry enquiry;
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

  Future<void> submit(EnquiryDraft draft) async {
    final current = state;
    if (current is! ProductEnquiryReady || current.submitting) return;
    final message = draft.composedMessage;
    if (message.isEmpty) {
      emit(
        const ProductEnquiryReady(
          errorMessage: 'Tell us what you need quoted.',
        ),
      );
      return;
    }
    emit(const ProductEnquiryReady(submitting: true));
    final result = await _submitProductEnquiry(
      message: message,
      productId: productId,
      accountId: accountId,
    );
    if (isClosed) return;
    result.fold(
      onSuccess: (enquiry) => emit(ProductEnquirySuccess(enquiry)),
      onFailure: (failure) =>
          emit(ProductEnquiryReady(errorMessage: failure.message)),
    );
  }
}

class EnquiryDraft {
  const EnquiryDraft({
    required this.furnitureType,
    required this.dimensions,
    required this.room,
    required this.contact,
    required this.notes,
  });

  final String furnitureType;
  final String dimensions;
  final String room;
  final String contact;
  final String notes;

  String get composedMessage {
    final lines = <String>[];
    void add(String label, String value) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) lines.add('$label: $trimmed');
    }

    add('Furniture', furnitureType);
    add('Dimensions', dimensions);
    add('Room', room);
    add('Contact', contact);
    final note = notes.trim();
    if (note.isNotEmpty) lines.add(note);
    return lines.join('\n');
  }
}
