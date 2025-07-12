import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GeneralInquiryScreen extends StatefulWidget {
  const GeneralInquiryScreen({super.key});

  @override
  State<GeneralInquiryScreen> createState() => _GeneralInquiryScreenState();
}

class _GeneralInquiryScreenState extends State<GeneralInquiryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedCategory = 'product_information';
  final List<String> _categories = [
    'product_information',
    'order_status',
    'shipping',
    'payment',
    'account',
    'other'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'general_inquiry'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
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
              _buildHeader(context),
              SizedBox(height: 24.h),
              _buildNameField(context),
              SizedBox(height: 16.h),
              _buildEmailField(context),
              SizedBox(height: 16.h),
              _buildPhoneField(context),
              SizedBox(height: 16.h),
              _buildCategoryDropdown(context),
              SizedBox(height: 16.h),
              _buildSubjectField(context),
              SizedBox(height: 16.h),
              _buildMessageField(context),
              SizedBox(height: 24.h),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ask_us_anything'.tr(context),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'response_time'.tr(context),
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField(BuildContext context) {
    return AppTextField(
      labelText: 'full_name'.tr(context),
      hintText: 'enter_full_name'.tr(context),
      controller: _nameController,
      validator: (value) =>
          value!.isEmpty ? 'please_enter_name'.tr(context) : null,
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return AppTextField(
      labelText: 'email_address'.tr(context),
      hintText: 'enter_email'.tr(context),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) return 'please_enter_email'.tr(context);
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'enter_valid_email'.tr(context);
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return AppTextField(
      labelText: 'phone_number'.tr(context),
      hintText: 'enter_phone'.tr(context),
      controller: _phoneController,
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'category'.tr(context),
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
              value: _selectedCategory,
              isExpanded: true,
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(
                    category.tr(context),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectField(BuildContext context) {
    return AppTextField(
      labelText: 'subject'.tr(context),
      hintText: 'subject_hint'.tr(context),
      controller: _subjectController,
      validator: (value) =>
          value!.isEmpty ? 'please_enter_subject'.tr(context) : null,
    );
  }

  Widget _buildMessageField(BuildContext context) {
    return AppTextField(
      labelText: 'message'.tr(context),
      hintText: 'message_hint'.tr(context),
      controller: _messageController,
      maxLines: 5,
      validator: (value) =>
          value!.isEmpty ? 'please_enter_message'.tr(context) : null,
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return AppButton(
      onPressed: _submitForm,
      text: 'submit_inquiry'.tr(context),
      type: AppButtonType.primary,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('inquiry_success'.tr(context)),
          content: Text('inquiry_success_message'.tr(context)),
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
