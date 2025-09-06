import '../../data/models/address_model.dart';

class AddressState {
  const AddressState();
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<AddressModel> addresses;

  const AddressLoaded(this.addresses);
}

class AddressSuccess extends AddressState {
  final String message;

  const AddressSuccess(this.message);
}

class AddressError extends AddressState {
  final String error;

  const AddressError(this.error);
}

class AddressFormUpdated extends AddressState {
  final bool isDefault;

  const AddressFormUpdated({required this.isDefault});
}

class AddressFormInvalid extends AddressState {}

class AddressFormInitialized extends AddressState {
  final bool isEditing;
  final bool isDefault;

  const AddressFormInitialized(
      {required this.isEditing, required this.isDefault});
}
