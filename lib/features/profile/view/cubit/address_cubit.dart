import 'package:bloc/bloc.dart';
import 'package:cozy/core/common/logs.dart';
import 'package:cozy/features/profile/data/models/address_model.dart';
import 'package:flutter/material.dart';

import '../../data/repo/address_repo.dart';
import 'address_state.dart';

//! AddressCubit
class AddressCubit extends Cubit<AddressState> {
  final AddressRepo addressRepo;

  AddressCubit(this.addressRepo) : super(AddressInitial());

  List<AddressModel> addresses = [];


  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final countryController = TextEditingController();
  bool isDefault = false;
  bool isEditing = false;
  String? editingAddressId;


  void initializeForm({AddressModel? address}) {
    if (address != null) {
      isEditing = true;
      editingAddressId = address.id;
      titleController.text = address.title;
      nameController.text = address.name;
      phoneController.text = address.phone;
      streetController.text = address.street;
      cityController.text = address.city;
      stateController.text = address.state;
      zipController.text = address.zipCode;
      countryController.text = address.country;
      isDefault = address.isDefault;
    } else {
      isEditing = false;
      editingAddressId = null;
      titleController.text = '';
      nameController.clear();
      phoneController.clear();
      streetController.clear();
      cityController.clear();
      stateController.clear();
      zipController.clear();
      countryController.text = 'United States';
      isDefault = false;
    }
    emit(AddressFormInitialized(isEditing: isEditing, isDefault: isDefault));
  }


  void toggleDefault(bool value) {
    isDefault = value;
    emit(AddressFormUpdated(isDefault: isDefault));
  }


  Future<void> saveAddress() async {
    if (!formKey.currentState!.validate()) {
      emit(AddressFormInvalid());
      return;
    }

    final address = AddressModel(
      id: isEditing ? editingAddressId! : '',
      title: titleController.text.isEmpty ? 'Address' : titleController.text,
      name: nameController.text,
      phone: phoneController.text,
      street: streetController.text,
      city: cityController.text,
      state: stateController.text,
      zipCode: zipController.text,
      country: countryController.text,
      isDefault: isDefault,
    );

    emit(AddressLoading());
    final result = isEditing
        ? await addressRepo.updateAddress(address)
        : await addressRepo.addAddress(address);

    result.fold(
      (error) {
        Print.error(error);
        emit(AddressError(error));
      },
      (savedAddress) {
        emit(AddressSuccess(savedAddress));
      },
    );
  }


  Future<void> fetchAddresses() async {
    emit(AddressLoading());
    final result = await addressRepo.getAddresses();
    result.fold(
      (error) {
        Print.error(error);
        emit(AddressError(error));
      },
      (fetchedAddresses) {
        addresses = fetchedAddresses;
        emit(AddressLoaded(addresses));
      },
    );
  }


  Future<void> deleteAddress(String addressId) async {
    emit(AddressLoading());
    final result = await addressRepo.deleteAddress(addressId);
    result.fold(
      (error) {
        Print.error(error);
        emit(AddressError(error));
      },
      (message) {
        addresses.removeWhere((address) => address.id == addressId);
        emit(AddressSuccess(message));
        fetchAddresses();
      },
    );
  }


  Future<void> setDefaultAddress(String addressId) async {
    emit(AddressLoading());
    final result = await addressRepo.setDefaultAddress(addressId);
    result.fold(
      (error) {
        Print.error(error);
        emit(AddressError(error));
      },
      (message) {
        for (var address in addresses) {
          address.isDefault = address.id == addressId;
        }
        emit(AddressSuccess(message));
        fetchAddresses();
      },
    );
  }

  @override
  Future<void> close() {
    titleController.dispose();
    nameController.dispose();
    phoneController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    countryController.dispose();
    return super.close();
  }
}
