import 'package:bloc/bloc.dart';
import 'package:cozy/core/common/logs.dart';
import 'package:cozy/features/profile/data/models/order_model.dart';
import 'package:cozy/features/profile/data/models/tracking_event_model.dart';

import '../../data/models/order_status.dart';
import '../../data/repo/orders_repo.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrderRepo orderRepo;

  OrdersCubit(this.orderRepo) : super(OrderInitial());

  List<OrderModel> orders = [];
  List<TrackingEvent> trackingOrders = [];

  //! Fetch all orders
  Future<void> getOrders() async {
    emit(OrderLoading());
    final result = await orderRepo.getOrders();
    result.fold(
      (error) {
        Print.error(error);
        emit(OrderError(error));
      },
      (fetchedOrders) {
        orders = fetchedOrders;
        emit(OrderLoaded(orders));
      },
    );
  }

  //! Get order details
  Future<void> getOrderDetails(String orderId) async {
    emit(OrderDetailsLoading());
    final result = await orderRepo.getOrderDetails(orderId);
    result.fold(
      (error) {
        Print.error(error);
        emit(OrderDetailsError(error));
      },
      (order) {
        orders = orders.map((o) => o.id == order.id ? order : o).toList();
        emit(OrderDetailsLoaded(order));
      },
    );
  }

  //! Cancel order
  Future<void> cancelOrder(String orderId) async {
    emit(OrderLoading());
    final result = await orderRepo.cancelOrder(orderId);
    result.fold(
      (error) {
        Print.error(error);
        emit(OrderError(error));
        // Refresh orders after cancellation attempt
        getOrders();
      },
      (message) {
        // Update local order status
        final index = orders.indexWhere((order) => order.id == orderId);
        if (index != -1) {
          orders[index] = OrderModel(
            id: orders[index].id,
            businessId: orders[index].businessId,
            locationId: orders[index].locationId,
            contactId: orders[index].contactId,
            invoiceNo: orders[index].invoiceNo,
            transactionDate: orders[index].transactionDate,
            createdAt: orders[index].createdAt,
            updatedAt: DateTime.now(),
            totalBeforeTax: orders[index].totalBeforeTax,
            taxAmount: orders[index].taxAmount,
            finalTotal: orders[index].finalTotal,
            status: OrderStatus.cancelled,
            paymentStatus: orders[index].paymentStatus,
            additionalNotes: orders[index].additionalNotes,
            shippingAddress: orders[index].shippingAddress,
            shippingStatus: orders[index].shippingStatus,
            items: orders[index].items,
          );
        }
        emit(OrderSuccess(message));
        emit(OrderLoaded(orders));
      },
    );
  }

  //! Filter orders by status
  List<OrderModel> filterOrders(OrderStatus status) {
    return orders.where((order) => order.status == status).toList();
  }

//! Track order
  Future<void> trackOrder(String orderId) async {
    emit(OrderTrackingLoading());
    final result = await orderRepo.trackOrder(orderId);
    result.fold(
      (error) {
        Print.error(error);
        emit(OrderTrackingError(error));
      },
      (trackingEvents) {
        // final index = orders.indexWhere((order) => order.id == orderId);
        // if (index != -1) {
        //   orders[index] = OrderModel(
        //     id: orders[index].id,
        //     businessId: orders[index].businessId,
        //     locationId: orders[index].locationId,
        //     contactId: orders[index].contactId,
        //     invoiceNo: orders[index].invoiceNo,
        //     transactionDate: orders[index].transactionDate,
        //     createdAt: orders[index].createdAt,
        //     updatedAt: orders[index].updatedAt,
        //     totalBeforeTax: orders[index].totalBeforeTax,
        //     taxAmount: orders[index].taxAmount,
        //     finalTotal: orders[index].finalTotal,
        //     status: orders[index].status,
        //     paymentStatus: orders[index].paymentStatus,
        //     additionalNotes: orders[index].additionalNotes,
        //     shippingAddress: orders[index].shippingAddress,
        //     shippingStatus: orders[index].shippingStatus,
        //     shippingDetails: orders[index].shippingDetails,
        //     deliveredTo: orders[index].deliveredTo,
        //     deliveryPerson: orders[index].deliveryPerson,
        //     shippingCharges: orders[index].shippingCharges,
        //     items: orders[index].items,
        //     trackingEvents: trackingEvents,
        //   );
        // }
        trackingOrders = trackingEvents;
        emit(OrderTrackingLoaded(trackingEvents));
      },
    );
  }

  //! Get order by ID
  OrderModel? getOrderById(String orderId) {
    try {
      return orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null; // Return null if no order is found
    }
  }
}
