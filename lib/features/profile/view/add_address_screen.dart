import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/profile/data/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddAddressScreen extends StatefulWidget {
  final AddressModel? address;

  const AddAddressScreen({super.key, this.address});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();

  bool _isDefault = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _isEditing = true;
      _titleController.text = widget.address!.title;
      _nameController.text = widget.address!.name;
      _phoneController.text = widget.address!.phone;
      _streetController.text = widget.address!.street;
      _cityController.text = widget.address!.city;
      _stateController.text = widget.address!.state;
      _zipController.text = widget.address!.zipCode;
      _countryController.text = widget.address!.country;
      _isDefault = widget.address!.isDefault;
    } else {
      _countryController.text = 'United States';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

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
          _isEditing ? 'edit_address'.tr(context) : 'add_address'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'address_details'.tr(context),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(height: 16.h),
              AppTextField(
                labelText: 'address_title'.tr(context),
                hintText: 'e.g., Home, Office, etc.',
                controller: _titleController,
                validator: (value) => value!.isEmpty
                    ? 'address_title_required'.tr(context)
                    : null,
              ),
              SizedBox(height: 16.h),
              AppTextField(
                labelText: 'full_name'.tr(context),
                hintText: 'enter_name'.tr(context),
                controller: _nameController,
                validator: (value) =>
                    value!.isEmpty ? 'name_required'.tr(context) : null,
              ),
              SizedBox(height: 16.h),
              AppTextField(
                labelText: 'phone_number'.tr(context),
                hintText: 'Enter phone number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'phone_required'.tr(context) : null,
              ),
              SizedBox(height: 16.h),
              AppTextField(
                labelText: 'street_address'.tr(context),
                hintText: 'Enter street address',
                controller: _streetController,
                validator: (value) =>
                    value!.isEmpty ? 'street_required'.tr(context) : null,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AppTextField(
                      labelText: 'city'.tr(context),
                      hintText: 'Enter city',
                      controller: _cityController,
                      validator: (value) =>
                          value!.isEmpty ? 'city_required'.tr(context) : null,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: AppTextField(
                      labelText: 'state'.tr(context),
                      hintText: 'State',
                      controller: _stateController,
                      validator: (value) =>
                          value!.isEmpty ? 'state_required'.tr(context) : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      labelText: 'zip_code'.tr(context),
                      hintText: 'ZIP Code',
                      controller: _zipController,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'zip_required'.tr(context) : null,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    flex: 2,
                    child: AppTextField(
                      labelText: 'country'.tr(context),
                      hintText: 'Enter country',
                      controller: _countryController,
                      validator: (value) => value!.isEmpty
                          ? 'country_required'.tr(context)
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'set_as_default'.tr(context),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBlack,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'use_as_default_address'.tr(context),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isDefault,
                      onChanged: (value) {
                        setState(() {
                          _isDefault = value;
                        });
                      },
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    _isEditing
                        ? 'update_address'.tr(context)
                        : 'save_address'.tr(context),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(_isEditing
              ? 'address_updated'.tr(context)
              : 'address_saved'.tr(context)),
          content: Text(_isEditing
              ? 'Your address has been updated successfully.'
              : 'Your address has been saved successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
