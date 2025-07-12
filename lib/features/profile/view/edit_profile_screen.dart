import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();

  String _selectedGender = 'male';
  final List<String> _genders = ['male', 'female', 'other'];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    // Pre-fill with current user data
    _nameController.text = 'John Doe';
    _emailController.text = 'john.doe@example.com';
    _phoneController.text = '+1 234 567 8900';
    _addressController.text = '123 Main Street';
    _cityController.text = 'New York';
    _zipController.text = '10001';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
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
              _buildProfilePicture(context),
              SizedBox(height: 32.h),
              _buildPersonalInfoSection(context),
              SizedBox(height: 24.h),
              _buildAddressSection(context),
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
        'edit_profile'.tr(context),
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
      ),
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60.r,
            backgroundColor: AppColors.primary,
            child: Text(
              'JD',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'personal_information'.tr(context),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 16.h),
        _buildNameField(context),
        SizedBox(height: 16.h),
        _buildEmailField(context),
        SizedBox(height: 16.h),
        _buildPhoneField(context),
        SizedBox(height: 16.h),
        _buildGenderDropdown(context),
      ],
    );
  }

  Widget _buildNameField(BuildContext context) {
    return AppTextField(
      controller: _nameController,
      labelText: 'full_name'.tr(context),
      hintText: 'enter_name'.tr(context),
      validator: (value) => value!.isEmpty ? 'name_required'.tr(context) : null,
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return AppTextField(
      controller: _emailController,
      labelText: 'email'.tr(context),
      hintText: 'enter_email'.tr(context),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) return 'email_required'.tr(context);
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'invalid_email'.tr(context);
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return AppTextField(
      controller: _phoneController,
      labelText: 'phone_number'.tr(context),
      hintText: 'enter_phone'.tr(context),
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildGenderDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'gender'.tr(context),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.lightGrey),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(4.r),
              value: _selectedGender,
              isExpanded: true,
              items: _genders.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender.tr(context)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'address_information'.tr(context),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 16.h),
        _buildAddressField(context),
        SizedBox(height: 16.h),
        _buildCityZipFields(context),
      ],
    );
  }

  Widget _buildAddressField(BuildContext context) {
    return AppTextField(
      controller: _addressController,
      labelText: 'street_address'.tr(context),
      hintText: 'enter_street'.tr(context),
    );
  }

  Widget _buildCityZipFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: AppTextField(
            controller: _cityController,
            labelText: 'city'.tr(context),
            hintText: 'enter_city'.tr(context),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: AppTextField(
            controller: _zipController,
            labelText: 'zip_code'.tr(context),
            hintText: 'enter_zip'.tr(context),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return AppButton(
      text: 'save_changes'.tr(context),
      onPressed: _saveProfile,
      type: AppButtonType.primary,
      height: 50.h,
      borderRadius: BorderRadius.circular(4.r),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('profile_updated'.tr(context)),
          content: Text('profile_update_success'.tr(context)),
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
