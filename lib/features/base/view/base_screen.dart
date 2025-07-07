import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/cubit/global_state.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/cart/view/cart_screen.dart';
import 'package:cozy/features/category/view/categories_screen.dart';
import 'package:cozy/features/home/view/home_screen.dart';
import 'package:cozy/features/profile/view/profile_screen.dart';
import 'package:cozy/features/wishlist/view/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const WishlistScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  final List<NavItem> _navItems = [
    NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'home',
    ),
    NavItem(
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view,
      label: 'categories',
    ),
    NavItem(
      icon: Icons.favorite_outline,
      activeIcon: Icons.favorite,
      label: 'favorites',
    ),
    NavItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      label: 'cart',
    ),
    NavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        return BlocListener<GlobalCubit, GlobalState>(
          listener: (context, state) {
            if (state is LanguageChangedState) {
              setState(() {}); // Rebuild on language change
            }
          },
          child: Scaffold(
            body: _screens[_currentIndex],
            bottomNavigationBar: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Container(
                margin: EdgeInsets.all(20.w),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                height: 70.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    _navItems.length,
                    (index) => Expanded(child: _buildNavItem(index)),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int index) {
    final item = _navItems[index];
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              color: isSelected ? AppColors.primary : AppColors.grey,
              size: 24.sp,
            ),
            SizedBox(height: 2.h),
            Text(
              item.label.tr(context),
              style: TextStyle(
                fontSize: 6.sp,
                color: isSelected ? AppColors.primary : AppColors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
