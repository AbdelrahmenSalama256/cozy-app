import 'package:cozy/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

//! ProductImageCarousel
class ProductImageCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const ProductImageCarousel({super.key, required this.imageUrls});

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

//! _ProductImageCarouselState
class _ProductImageCarouselState extends State<ProductImageCarousel> {
  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.imageUrls.length,
      onPageChanged: (index) => setState(() => currentImageIndex = index),
      itemBuilder: (context, index) => Image.network(
        widget.imageUrls[index],
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.lightGrey,
          child: const Icon(Icons.image_not_supported),
        ),
      ),
    );
  }
}

