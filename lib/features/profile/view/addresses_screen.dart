import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/profile/data/models/address_model.dart';
import 'package:cozy/features/profile/view/add_address_screen.dart';
import 'package:cozy/features/profile/view/widgets/address_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  List<AddressModel> addresses = [
    AddressModel(
      id: '1',
      title: 'Home',
      name: 'John Doe',
      phone: '+1 234 567 8900',
      street: '123 Main Street',
      city: 'New York',
      state: 'NY',
      zipCode: '10001',
      country: 'United States',
      isDefault: true,
    ),
    AddressModel(
      id: '2',
      title: 'Office',
      name: 'John Doe',
      phone: '+1 234 567 8900',
      street: '456 Business Ave',
      city: 'New York',
      state: 'NY',
      zipCode: '10002',
      country: 'United States',
      isDefault: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'addresses'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: AppColors.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddAddressScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: addresses.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.all(20.w),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return AddressCard(
                  address: addresses[index],
                  onEdit: () => _editAddress(addresses[index]),
                  onDelete: () => _deleteAddress(addresses[index].id),
                  onSetDefault: () => _setDefaultAddress(addresses[index].id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAddressScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 80.sp,
            color: AppColors.textGrey,
          ),
          SizedBox(height: 16.h),
          Text(
            'no_addresses'.tr(context),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'add_address_message'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textGrey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddAddressScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text(
              'add_address'.tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editAddress(AddressModel address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddressScreen(address: address),
      ),
    );
  }

  void _deleteAddress(String addressId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_address'.tr(context)),
        content: Text('delete_address_confirmation'.tr(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr(context)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                addresses.removeWhere((address) => address.id == addressId);
              });
              Navigator.pop(context);
            },
            child: Text(
              'delete'.tr(context),
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _setDefaultAddress(String addressId) {
    setState(() {
      for (var address in addresses) {
        address.isDefault = address.id == addressId;
      }
    });
  }
}
