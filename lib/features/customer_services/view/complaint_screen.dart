import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  String _complaintType = 'Product Quality';
  final List<String> _complaintTypes = [
    'Product Quality',
    'Customer Service',
    'Delivery Issue',
    'Website/App Issue',
    'Billing Problem',
    'Other'
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
          'Complaint & Feedback',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
                'Share Your Feedback',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              Text(
                'Help us improve by sharing your experience',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 24.h), // Reduced spacing for smaller screens
              AppTextField(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                controller: _nameController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
              ),
              SizedBox(height: 16.h),
              AppTextField(
                labelText: 'Email Address',
                hintText: 'Enter your email address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter your email';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              AppTextField(
                labelText: 'Order Number (Optional)',
                hintText: 'Enter order number if applicable',
                controller: _orderNumberController,
              ),
              SizedBox(height: 16.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complaint Type *',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _complaintType,
                        isExpanded: true,
                        items: _complaintTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              type,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
              ),
              SizedBox(height: 16.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Priority Level *',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Low',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
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
                              'High',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
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
              ),
              SizedBox(height: 16.h),
              AppTextField(
                labelText: 'Subject',
                hintText: 'Brief summary of your complaint',
                controller: _subjectController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a subject' : null,
              ),
              SizedBox(height: 16.h),
              AppTextField(
                labelText: 'Detailed Description',
                hintText:
                    'Please provide detailed information about your complaint',
                controller: _complaintController,
                maxLines: 5,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Submit Complaint',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Complaint Submitted'),
          content: const Text(
              'Thank you for your feedback. We take all complaints seriously and will investigate this matter promptly.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
