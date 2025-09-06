import 'package:flutter/material.dart';

import 'order_status.dart';

class OrderModel {
  final String id;
  final String businessId;
  final String locationId;
  final String contactId;
  final String invoiceNo;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double totalBeforeTax;
  final double taxAmount;
  final double finalTotal;
  final OrderStatus status;
  final String? paymentStatus;
  final String? additionalNotes;
  final String? shippingAddress;
  final String? shippingStatus;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.businessId,
    required this.locationId,
    required this.contactId,
    required this.invoiceNo,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
    required this.totalBeforeTax,
    required this.taxAmount,
    required this.finalTotal,
    required this.status,
    this.paymentStatus,
    this.additionalNotes,
    this.shippingAddress,
    this.shippingStatus,
    required this.items,
  });

  // Getters for compatibility with OrderCard
  DateTime get date => transactionDate;
  double get total => finalTotal;

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.ordered:
        return 'ordered';
      case OrderStatus.packed:
        return 'packed';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  Color get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return Colors.grey; // Grey for pending
      case OrderStatus.ordered:
        return Colors.blue; // Blue for ordered
      case OrderStatus.packed:
        return Colors.orange; // Orange for packed
      case OrderStatus.shipped:
        return Colors.blueAccent; // Blue accent for shipped
      case OrderStatus.delivered:
        return Colors.green; // Green for delivered
      case OrderStatus.cancelled:
        return Colors.red; // Red for cancelled
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_id': businessId,
      'location_id': locationId,
      'contact_id': contactId,
      'invoice_no': invoiceNo,
      'transaction_date': transactionDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'total_before_tax': totalBeforeTax,
      'tax_amount': taxAmount,
      'final_total': finalTotal,
      'shipping_status': status
          .toString()
          .split('.')
          .last, // e.g., 'pending' instead of 'OrderStatus.pending'
      'payment_status': paymentStatus,
      'additional_notes': additionalNotes,
      'shipping_address': shippingAddress,
      // 'shipping_status': shippingStatus,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    OrderStatus parseStatus(String? status) {
      switch (status?.toLowerCase()) {
        case 'ordered':
          return OrderStatus.ordered;
        case 'packed':
          return OrderStatus.packed;
        case 'shipped':
          return OrderStatus.shipped;
        case 'delivered':
          return OrderStatus.delivered;
        case 'cancelled':
          return OrderStatus.cancelled;
        case 'final': // Handle the API's 'final' status
          return OrderStatus.delivered; // Map 'final' to 'delivered'
        default:
          return OrderStatus.pending; // Default to pending
      }
    }

    return OrderModel(
      id: json['id']?.toString() ?? '',
      businessId: json['business_id']?.toString() ?? '',
      locationId: json['location_id']?.toString() ?? '',
      contactId: json['contact_id']?.toString() ?? '',
      invoiceNo: json['invoice_no']?.toString() ?? '',
      transactionDate:
          DateTime.parse(json['transaction_date'] ?? DateTime.now().toString()),
      createdAt:
          DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt:
          DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
      totalBeforeTax:
          double.tryParse(json['total_before_tax']?.toString() ?? '0') ?? 0,
      taxAmount: double.tryParse(json['tax_amount']?.toString() ?? '0') ?? 0,
      finalTotal: double.tryParse(json['final_total']?.toString() ?? '0') ?? 0,
      status: parseStatus(json['shipping_status']?.toString()),
      paymentStatus: json['payment_status']?.toString(),
      additionalNotes: json['additional_notes']?.toString(),
      shippingAddress: json['shipping_address']?.toString(),
      // shippingStatus: json['shipping_status']?.toString(),
      items: (json['sell_lines'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class OrderItem {
  final String id;
  final String productId;
  final String productName;
  final String? productImage;
  final double unitPrice;
  final int quantity;
  final double lineTotal;
  final String? variations;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
    this.variations,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'unit_price': unitPrice,
      'quantity': quantity,
      'line_total': lineTotal,
      'variations': variations,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      productName: json['product']?['name']?.toString() ?? 'Unknown Product',
      productImage: json['product']?['image_url']?.toString(),
      unitPrice: double.tryParse(json['unit_price']?.toString() ?? '0') ?? 0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      lineTotal: (double.tryParse(json['unit_price']?.toString() ?? '0') ?? 0) *
          (int.tryParse(json['quantity']?.toString() ?? '0') ?? 0),
      variations: json['variations']?['name']?.toString(),
    );
  }
}
