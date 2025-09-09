import 'package:cozy/core/constants/widgets/errors/exceptions.dart';
import 'package:cozy/core/constants/widgets/print_util.dart';
import 'package:cozy/core/database/api/api_consumer.dart';
import 'package:cozy/core/database/api/end_points.dart';
import 'package:cozy/features/profile/data/models/order_model.dart';
import 'package:dartz/dartz.dart';

import '../models/order_status.dart';
import '../models/tracking_event_model.dart';

class OrderRepo {
  final ApiConsumer api;

  OrderRepo(this.api);

  //! Fetch all orders
  Future<Either<String, List<OrderModel>>> getOrders() async {
    try {
      final response = await api.get(EndPoints.getOrders);
      if (response.data['success']) {
        final orders = (response.data['data'] as List)
            .map((json) {
              try {
                return OrderModel.fromJson(json);
              } catch (e) {
                PrintUtil.error('Error parsing order: $e, JSON: $json');
                // Return a default order for failed parsing
                return OrderModel(
                  id: json['id']?.toString() ?? 'error',
                  businessId: json['business_id']?.toString() ?? '',
                  locationId: json['location_id']?.toString() ?? '',
                  contactId: json['contact_id']?.toString() ?? '',
                  invoiceNo: json['invoice_no']?.toString() ?? '',
                  transactionDate: DateTime.now(),
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  totalBeforeTax: 0,
                  taxAmount: 0,
                  finalTotal: 0,
                  status:
                      OrderStatus.pending, // Updated to use pending as default
                  items: [],
                );
              }
            })
            .where((order) => order.id != 'error') // Filter out error orders
            .toList();
        return Right(orders);
      } else {
        return Left(
            'Failed to fetch orders: ${response.data['message'] ?? 'Unknown error'}');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch orders: $e');
    }
  }

  //! Get order details by ID
  Future<Either<String, OrderModel>> getOrderDetails(String orderId) async {
    try {
      final response = await api.get("${EndPoints.getOrdersDetails}/$orderId");
      if (response.data['success']) {
        try {
          final order = OrderModel.fromJson(response.data);
          return Right(order);
        } catch (e) {
          PrintUtil.error('Error parsing order details: $e');
          return Left('Failed to parse order details');
        }
      } else {
        return Left('Failed to fetch order details');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch order details: $e');
    }
  }

  //! Cancel an order
  Future<Either<String, String>> cancelOrder(String orderId) async {
    try {
      final response = await api.get(
        "${EndPoints.cancelOrder}/$orderId",
      );

      return Right(response.data['message'] ?? 'Order cancelled successfully');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to cancel order: $e');
    }
  }

  //! Track order
  Future<Either<String, List<TrackingEvent>>> trackOrder(String orderId) async {
    try {
      final response = await api.get("${EndPoints.trackOrder}/$orderId");
      if (response.data['success']) {
        final trackingEvents = (response.data['data'] as List)
            .map((event) => TrackingEvent.fromJson(event))
            .toList();
        return Right(trackingEvents);
      } else {
        return Left(
            'Failed to track order: ${response.data['message'] ?? 'Unknown error'}');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to track order: $e');
    }
  }
}
