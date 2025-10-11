import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/home/view/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/model/product_details_model.dart';

//! QuantitySelector
class QuantitySelector extends StatelessWidget {
  final bool hasVariations;
  final ProductDetailsModel product;

  const QuantitySelector({super.key, required this.hasVariations, required this.product});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final selectedVariationId = cubit.selectedVariationId;
    final selectedVariation = hasVariations
        ? product.variations?.firstWhere(
            (v) => v.id?.toString() == selectedVariationId,
            orElse: () => product.variations!.first,
          )
        : null;

    final availableQuantity = selectedVariation?.quantity ?? 0;
    final quantity = cubit.quantity;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('quantity'.tr(context),
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                if (quantity > 1) {
                  cubit.updateQuantity(quantity - 1);
                }
              },
            ),
            Text('$quantity', style: TextStyle(fontSize: 16.sp)),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (quantity < availableQuantity) {
                  cubit.updateQuantity(quantity + 1);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

