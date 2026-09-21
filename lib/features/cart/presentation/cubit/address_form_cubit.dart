import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/cart/domain/entities/delivery_address.dart';
import 'package:rak_customer/features/cart/domain/usecases/get_delivery_address.dart';
import 'package:rak_customer/features/cart/domain/usecases/save_delivery_address.dart';

sealed class AddressFormState {
  const AddressFormState();
}

class AddressFormLoading extends AddressFormState {
  const AddressFormLoading();
}

class AddressFormReady extends AddressFormState {
  const AddressFormReady({
    this.address,
    this.submitting = false,
    this.errorMessage,
  });

  final DeliveryAddress? address;
  final bool submitting;
  final String? errorMessage;

  AddressFormReady copyWith({
    DeliveryAddress? address,
    bool? submitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AddressFormReady(
      address: address ?? this.address,
      submitting: submitting ?? this.submitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AddressFormSaved extends AddressFormState {
  const AddressFormSaved(this.address);
  final DeliveryAddress address;
}

class AddressFormError extends AddressFormState {
  const AddressFormError(this.message);
  final String message;
}

class AddressFormCubit extends Cubit<AddressFormState> {
  AddressFormCubit({
    required GetDeliveryAddress getDeliveryAddress,
    required SaveDeliveryAddress saveDeliveryAddress,
    required this.accountId,
  }) : _getDeliveryAddress = getDeliveryAddress,
       _saveDeliveryAddress = saveDeliveryAddress,
       super(const AddressFormLoading());

  final GetDeliveryAddress _getDeliveryAddress;
  final SaveDeliveryAddress _saveDeliveryAddress;
  final String accountId;

  Future<void> load() async {
    emit(const AddressFormLoading());
    final result = await _getDeliveryAddress(accountId: accountId);
    result.fold(
      onSuccess: (address) => emit(AddressFormReady(address: address)),
      onFailure: (failure) => emit(AddressFormError(failure.message)),
    );
  }

  Future<void> save({
    required String fullName,
    required String mobile,
    required String line,
    required String postcode,
  }) async {
    final current = state;
    if (current is! AddressFormReady || current.submitting) return;
    emit(current.copyWith(submitting: true, clearError: true));
    final result = await _saveDeliveryAddress(
      accountId: accountId,
      fullName: fullName,
      mobile: mobile,
      line: line,
      postcode: postcode,
    );
    if (isClosed) return;
    result.fold(
      onSuccess: (address) => emit(AddressFormSaved(address)),
      onFailure: (failure) => emit(
        current.copyWith(submitting: false, errorMessage: failure.message),
      ),
    );
  }
}
