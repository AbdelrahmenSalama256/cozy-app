import 'package:cozy/core/component/widgets/app_button.dart';
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
    _initializeForm();
  }

  void _initializeForm() {
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
      appBar: _buildAppBar(context),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 16.h),
              _buildTitleField(context),
              SizedBox(height: 16.h),
              _buildNameField(context),
              SizedBox(height: 16.h),
              _buildPhoneField(context),
              SizedBox(height: 16.h),
              _buildStreetField(context),
              SizedBox(height: 16.h),
              _buildCityStateFields(context),
              SizedBox(height: 16.h),
              _buildZipCountryFields(context),
              SizedBox(height: 24.h),
              _buildDefaultAddressToggle(context),
              SizedBox(height: 32.h),
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'address_details'.tr(context),
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textBlack,
      ),
    );
  }

  Widget _buildTitleField(BuildContext context) {
    return AppTextField(
      labelText: 'address_title'.tr(context),
      hintText: 'address_title_hint'.tr(context),
      controller: _titleController,
      validator: (value) =>
          value!.isEmpty ? 'address_title_required'.tr(context) : null,
    );
  }

  Widget _buildNameField(BuildContext context) {
    return AppTextField(
      labelText: 'full_name'.tr(context),
      hintText: 'enter_name'.tr(context),
      controller: _nameController,
      validator: (value) => value!.isEmpty ? 'name_required'.tr(context) : null,
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return AppTextField(
      labelText: 'phone_number'.tr(context),
      hintText: 'phone_hint'.tr(context),
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      validator: (value) =>
          value!.isEmpty ? 'phone_required'.tr(context) : null,
    );
  }

  Widget _buildStreetField(BuildContext context) {
    return AppTextField(
      labelText: 'street_address'.tr(context),
      hintText: 'street_hint'.tr(context),
      controller: _streetController,
      validator: (value) =>
          value!.isEmpty ? 'street_required'.tr(context) : null,
    );
  }

  Widget _buildCityStateFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: AppTextField(
            labelText: 'city'.tr(context),
            hintText: 'city_hint'.tr(context),
            controller: _cityController,
            validator: (value) =>
                value!.isEmpty ? 'city_required'.tr(context) : null,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: AppTextField(
            labelText: 'state'.tr(context),
            hintText: 'state_hint'.tr(context),
            controller: _stateController,
            validator: (value) =>
                value!.isEmpty ? 'state_required'.tr(context) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildZipCountryFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            labelText: 'zip_code'.tr(context),
            hintText: 'zip_hint'.tr(context),
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
            hintText: 'country_hint'.tr(context),
            controller: _countryController,
            validator: (value) =>
                value!.isEmpty ? 'country_required'.tr(context) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAddressToggle(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
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
            onChanged: (value) => setState(() => _isDefault = value),
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return AppButton(
      onPressed: _saveAddress,
      text: _isEditing
          ? 'update_address'.tr(context)
          : 'save_address'.tr(context),
      type: AppButtonType.primary,
      backgroundColor: AppColors.primary,
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
              ? 'address_update_success'.tr(context)
              : 'address_save_success'.tr(context)),
          actions: [
            AppButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              text: 'ok'.tr(context),
              type: AppButtonType.secondary,
              height: 36.h,
              borderRadius: BorderRadius.circular(8.r),
              borderColor: AppColors.textGrey,
              textStyle: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      );
    }
  }
}
