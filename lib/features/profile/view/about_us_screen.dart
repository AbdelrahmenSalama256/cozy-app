import 'package:cozy/core/common/common.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/profile/data/models/about_model.dart';
import 'package:cozy/features/profile/data/repo/about_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! AboutUsScreen
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'about_us'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
      ),
      body: FutureBuilder(
        future: sl<AboutRepo>().fetchAbout(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final either = snapshot.data!;
          return either.fold(
            (error) => Center(
                child: Text(error.tr(context),
                    style:
                        TextStyle(fontSize: 16.sp, color: AppColors.textGrey))),
            (about) => _buildContent(context, about),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, AboutResponse data) {
    final lang = Localizations.localeOf(context).languageCode;
    final aboutTitle =
        lang == 'ar' ? (data.about.titleAr ?? '') : (data.about.title ?? '');
    final aboutDesc = lang == 'ar'
        ? (data.about.descriptionAr ?? '')
        : (data.about.description ?? '');
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (aboutTitle.isNotEmpty)
            Center(
              child: Text(
                aboutTitle,
                style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack),
              ),
            ),
          if (aboutDesc.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              aboutDesc,
              style: TextStyle(
                  fontSize: 14.sp, color: AppColors.textGrey, height: 1.5),
            ),
          ],
          SizedBox(height: 24.h),
          if (data.about.content.isNotEmpty)
            Column(
              children: data.about.content
                  .map((e) => _buildSection(e.title ?? '', e.description ?? ''))
                  .toList(),
            ),
          SizedBox(height: 24.h),
          _buildSocialSection(context, data.social),
          SizedBox(height: 24.h),
          _buildStatsSection(context, data.statistics),
        ],
      ),
    );
  }

  Widget _buildSocialSection(BuildContext context, SocialLinks social) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('follow_us'.tr(context),
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack)),
        SizedBox(height: 16.h),
        Wrap(spacing: 16.w, runSpacing: 10.h, children: [
          if ((social.facebook ?? '').isNotEmpty)
            _buildSocialButton(
                context, Icons.facebook, 'Facebook', social.facebook),
          if ((social.instagram ?? '').isNotEmpty)
            _buildSocialButton(
                context, Icons.camera_alt, 'Instagram', social.instagram),
          if ((social.twitter ?? '').isNotEmpty)
            _buildSocialButton(
                context, Icons.alternate_email, 'Twitter', social.twitter),
          if ((social.youtube ?? '').isNotEmpty)
            _buildSocialButton(
                context, Icons.video_library, 'YouTube', social.youtube),
          if ((social.linkedin ?? '').isNotEmpty)
            _buildSocialButton(
                context, Icons.work_outline, 'LinkedIn', social.linkedin),
        ])
      ]),
    );
  }

  Widget _buildStatsSection(
      BuildContext context, StatisticsSection statistics) {
    final lang = Localizations.localeOf(context).languageCode;
    final tagline = lang == 'ar'
        ? (statistics.taglineAr ?? statistics.tagline ?? '')
        : (statistics.tagline ?? '');
    final desc = lang == 'ar'
        ? (statistics.descriptionAr ?? statistics.description ?? '')
        : (statistics.description ?? '');
    if (statistics.content.isEmpty && tagline.isEmpty && desc.isEmpty)
      return const SizedBox();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (tagline.isNotEmpty)
          Text(tagline,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack)),
        if (desc.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Text(desc,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textGrey)),
        ],
        SizedBox(height: 12.h),
        if (statistics.content.isNotEmpty)
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: statistics.content
                .map(
                  (s) => Container(
                    width: 150.w,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(children: [
                      Text(s.stats ?? '',
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary)),
                      SizedBox(height: 4.h),
                      Text(
                          (lang == 'ar'
                              ? (s.titleAr ?? s.title ?? '')
                              : (s.title ?? '')),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12.sp, color: AppColors.textGrey)),
                    ]),
                  ),
                )
                .toList(),
          )
      ]),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textGrey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(
      BuildContext context, IconData icon, String platform, String? url) {
    return InkWell(
      borderRadius: BorderRadius.circular(28.r),
      onTap: () => launchCustomUrl(context, url),
      child: Column(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Icon(
              icon,
              size: 24.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            platform,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
