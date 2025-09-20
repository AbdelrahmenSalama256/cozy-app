import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/constants/widgets/print_util.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/notifications/view/cubit/notifications_cubit.dart';
import 'package:cozy/features/notifications/view/widgets/notification_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/models/notification_model.dart';
import '../data/repo/notifications_repo.dart';
import 'cubit/notifications_state.dart';
import 'widgets/notifications_empty_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NotificationsCubit(sl<NotificationsRepo>())..fetchNotifications(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.textBlack,
              size: 20.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'notifications'.tr(context),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          centerTitle: true,
          actions: [
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                final cubit = context.read<NotificationsCubit>();
                final hasUnread = cubit.notifications.any((n) => !n.isRead);

                return hasUnread
                    ? IconButton(
                        icon: Icon(
                          Icons.mark_email_read,
                          color: AppColors.primary,
                          size: 24.sp,
                        ),
                        onPressed: () => cubit.markAllAsRead(),
                      )
                    : SizedBox();
              },
            ),
          ],
        ),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return _buildLoadingState(context);
            }

            if (state is NotificationsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textGrey,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => context
                          .read<NotificationsCubit>()
                          .fetchNotifications(),
                      child: Text('retry'.tr(context)),
                    ),
                  ],
                ),
              );
            }

            final cubit = context.read<NotificationsCubit>();
            final notifications = cubit.notifications;

            if (notifications.isEmpty) {
              return const NotificationsEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<NotificationsCubit>().fetchNotifications();
              },
              color: AppColors.primary,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return NotificationItemWidget(
                    notification: notification,
                    onTap: () => _handleNotificationTap(context, notification),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(
    BuildContext context,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomLoadingIndicator(
            type: LoadingType.furnitureRotation,
          ),
          SizedBox(height: 16.h),
          Text(
            'loading_notifications'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(
      BuildContext context, NotificationModel notification) {
    if (!notification.isRead) {
      context.read<NotificationsCubit>().markAsRead(notification.id);
    }

    switch (notification.type) {
      case NotificationType.order:
        // Navigate to order details
        if (notification.link != null) {
          // Handle order details navigation
          PrintUtil.debug('Navigate to order: ${notification.data}');
        }
        break;
      case NotificationType.promotion:
        // Navigate to promotion
        PrintUtil.debug('Navigate to promotion');
        break;
      case NotificationType.system:
        // Handle system notification
        break;
      case NotificationType.follow:
        // Navigate to user profile
        break;
      case NotificationType.like:
      case NotificationType.comment:
        // Navigate to post
        break;
      case NotificationType.unknown:
        // Handle unknown notification type
        break;
    }
  }
}
