import 'package:flutter/material.dart';

enum OrderStatus {
  processing,
  shipped,
  delivered,
  cancelled,
  returned,
}

class OrderModel {
  final String id;
  final DateTime date;
  final OrderStatus status;
  final double total;
  final int items;
  final String? trackingNumber;
  final List<OrderItem>? orderItems;

  OrderModel({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    required this.items,
    this.trackingNumber,
    this.orderItems,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
      case OrderStatus.returned:
        return 'returned';
    }
  }

  Color get statusColor {
    switch (status) {
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.shipped:
        return Colors.blue;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.returned:
        return Colors.grey;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'status': status.toString(),
      'total': total,
      'items': items,
      'trackingNumber': trackingNumber,
      'orderItems': orderItems?.map((item) => item.toJson()).toList(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      total: json['total'].toDouble(),
      items: json['items'],
      trackingNumber: json['trackingNumber'],
      orderItems: json['orderItems'] != null
          ? (json['orderItems'] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList()
          : null,
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String? size;
  final String? color;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    this.size,
    this.color,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'size': size,
      'color': color,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      productName: json['productName'],
      productImage: json['productImage'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      size: json['size'],
      color: json['color'],
    );
  }
}
