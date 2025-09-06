import 'package:cozy/core/constants/widgets/errors/exceptions.dart';
import 'package:cozy/core/constants/widgets/print_util.dart';
import 'package:cozy/core/database/api/api_consumer.dart';
import 'package:cozy/core/database/api/end_points.dart';
import 'package:cozy/features/profile/data/models/address_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/common/logs.dart';

class AddressRepo {
  final ApiConsumer api;

  AddressRepo(this.api);

  //! Fetch all addresses
  Future<Either<String, List<AddressModel>>> getAddresses() async {
    try {
      final response = await api.get(EndPoints.getAddresses);
      if (response.data['success']) {
        final addresses = (response.data['data'] as List)
            .map((json) {
              try {
                return AddressModel.fromJson(json);
              } catch (e) {
                Print.error('Error parsing address: $e, JSON: $json');
                // Return a default address or skip this one
                return AddressModel(
                  id: json['id']?.toString() ?? 'error',
                  phone: json['phone']?.toString() ?? '',
                  street: json['address']?.toString() ?? '',
                  city: json['city']?.toString() ?? '',
                  country: json['country']?.toString() ?? '',
                );
              }
            })
            .where((address) =>
                address.id != 'error') // Filter out error addresses
            .toList();
        return Right(addresses);
      } else {
        return Left('Failed to fetch addresses');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch addresses: $e');
    }
  }

  // Add a new address - use toAddJson()
  Future<Either<String, String>> addAddress(AddressModel address) async {
    try {
      final response = await api.post(
        EndPoints.addAddress,
        data: address.toAddJson(),
        isFormData: true,
      );
      return Right(response.data['message'] ?? 'Address added successfully');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to add address: $e');
    }
  }

  //! Update an existing address - use toUpdateJson()
  Future<Either<String, String>> updateAddress(AddressModel address) async {
    try {
      PrintUtil.debug('Sending update data: ${address.toUpdateJson()}');

      final response = await api.post(
        "${EndPoints.updateAddress}/${address.id}",
        data: address.toUpdateJson(), // Use update-specific JSON
        isFormData: true,
      );

      PrintUtil.debug('Update response: ${response.data}');

      final message =
          response.data['message'] ?? 'Address updated successfully';
      return Right(message);
    } on ServerException catch (e) {
      PrintUtil.debug('Server exception: ${e.errorModel.detail}');
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      PrintUtil.debug('No internet exception: ${e.errorModel.detail}');
      return Left(e.errorModel.detail);
    } catch (e, stackTrace) {
      PrintUtil.debug('Error updating address: $e');
      PrintUtil.debug('Stack trace: $stackTrace');
      return Left('Failed to update address: $e');
    }
  }

  //! Delete an address
  Future<Either<String, String>> deleteAddress(String addressId) async {
    try {
      final response =
          await api.delete("${EndPoints.deleteAddress}/$addressId");
      return Right(response.data['message']);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to delete address: $e');
    }
  }

  //! Set an address as default
  Future<Either<String, String>> setDefaultAddress(String addressId) async {
    try {
      final response = await api.post(
        "${EndPoints.setDefaultAddress}/$addressId/make-default",
        data: {'id': addressId},
      );
      return Right(response.data['message']);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to set default address: $e');
    }
  }
}
