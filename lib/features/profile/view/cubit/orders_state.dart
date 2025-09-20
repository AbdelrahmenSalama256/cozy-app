import '../../data/models/order_model.dart';
import '../../data/models/order_tracking_response.dart';

class OrdersState {
  const OrdersState();
}

class OrderInitial extends OrdersState {}

class OrderLoading extends OrdersState {}

class OrderLoaded extends OrdersState {
  final List<OrderModel> orders;

  const OrderLoaded(this.orders);
}

class OrderDetailsLoading extends OrdersState {}

class OrderDetailsLoaded extends OrdersState {
  final OrderModel order;

  const OrderDetailsLoaded(this.order);
}

class OrderSuccess extends OrdersState {
  final String message;

  const OrderSuccess(this.message);
}

class OrderError extends OrdersState {
  final String error;

  const OrderError(this.error);
}

class OrderDetailsError extends OrdersState {
  final String error;

  const OrderDetailsError(this.error);
}

class OrderTrackingLoading extends OrdersState {}

class OrderTrackingLoaded extends OrdersState {
  final OrderTrackResponse tracking;
  const OrderTrackingLoaded(this.tracking);
}

class OrderTrackingError extends OrdersState {
  final String error;

  const OrderTrackingError(this.error);
}
