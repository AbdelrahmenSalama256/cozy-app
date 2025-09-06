abstract class CheckoutState {
  const CheckoutState();
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  final String orderId;

  const CheckoutSuccess(this.orderId);
}

class CheckoutError extends CheckoutState {
  final String error;

  const CheckoutError(this.error);
}
