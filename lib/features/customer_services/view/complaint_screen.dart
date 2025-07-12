import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/widgets/app_button.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _orderNumberController = TextEditingController();
  final _subjectController = TextEditingController();
  final _complaintController = TextEditingController();

  String _complaintType = 'product_quality';
  final List<String> _complaintTypes = [
    'product_quality',
    'customer_service',
    'delivery_issue',
    'website_app_issue',
    'billing_problem',
    'other'
  ];

  int _severityLevel = 2;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _orderNumberController.dispose();
    _subjectController.dispose();
    _complaintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'complaint_feedback'.tr(context),
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
              _buildOrderNumberField(context),
              SizedBox(height: 16.h),
              _buildComplaintTypeDropdown(context),
              SizedBox(height: 16.h),
              _buildPriorityLevelSlider(context),
              SizedBox(height: 16.h),
              _buildSubjectField(context),
              SizedBox(height: 16.h),
              _buildDescriptionField(context),
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
          'share_feedback'.tr(context),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'help_us_improve'.tr(context),
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
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

  Widget _buildOrderNumberField(BuildContext context) {
    return AppTextField(
      labelText: 'order_number_optional'.tr(context),
      hintText: 'enter_order_number'.tr(context),
      controller: _orderNumberController,
    );
  }

  Widget _buildComplaintTypeDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'complaint_type'.tr(context),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _complaintType,
              isExpanded: true,
              items: _complaintTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(
                    type.tr(context),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _complaintType = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityLevelSlider(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'priority_level'.tr(context),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    'low'.tr(context),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '1',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Slider(
                value: _severityLevel.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                activeColor: _severityLevel <= 2
                    ? Colors.green
                    : _severityLevel <= 3
                        ? Colors.orange
                        : Colors.red,
                onChanged: (double value) {
                  setState(() {
                    _severityLevel = value.round();
                  });
                },
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'high'.tr(context),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '5',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  Widget _buildDescriptionField(BuildContext context) {
    return AppTextField(
      labelText: 'detailed_description'.tr(context),
      hintText: 'description_hint'.tr(context),
      controller: _complaintController,
      maxLines: 5,
      validator: (value) =>
          value!.isEmpty ? 'please_enter_description'.tr(context) : null,
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return AppButton(
      onPressed: _submitForm,
      text: 'submit_complaint'.tr(context),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('complaint_submitted'.tr(context)),
          content: Text('thank_you_feedback'.tr(context)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('ok'.tr(context)),
            ),
          ],
        ),
      );
    }
  }
}
