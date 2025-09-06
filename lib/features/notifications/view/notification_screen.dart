import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/notifications/view/widgets/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/notifications_empty_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        notifications = _getSampleNotifications();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (notifications.isEmpty) {
      return const NotificationsEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() => isLoading = true);
        _loadNotifications();
      },
      color: AppColors.primary,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationItemWidget(
            notification: notification,
            onTap: () => _handleNotificationTap(notification),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
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

  void _handleNotificationTap(NotificationItem notification) {
    if (!notification.isRead) {
      setState(() => notification.isRead = true);
    }

    switch (notification.type) {
      case NotificationType.follow:
        // Navigate to user profile
        break;
      case NotificationType.like:
      case NotificationType.comment:
        // Navigate to post
        break;
      case NotificationType.order:
        // Navigate to order details
        break;
      case NotificationType.promotion:
        // Navigate to promotion
        break;
    }
  }

  List<NotificationItem> _getSampleNotifications() {
    return [
      NotificationItem(
        id: '1',
        userName: 'Sarah Johnson',
        userAvatar:
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150',
        message: 'started following you',
        time: '2m',
        type: NotificationType.follow,
        isRead: false,
        isFollowing: false,
      ),
      NotificationItem(
        id: '2',
        userName: 'Mike Chen',
        userAvatar:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        message: 'liked your post',
        time: '5m',
        type: NotificationType.like,
        isRead: false,
        postImage:
            'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=150',
      ),
      NotificationItem(
        id: '3',
        userName: 'Emma Wilson',
        userAvatar:
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
        message: 'commented on your post: "This looks amazing!"',
        time: '10m',
        type: NotificationType.comment,
        isRead: true,
        postImage:
            'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=150',
      ),
      NotificationItem(
        id: '4',
        userName: 'Alex Rodriguez',
        userAvatar:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
        message: 'and 5 others liked your post',
        time: '1h',
        type: NotificationType.like,
        isRead: true,
        postImage:
            'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=150',
      ),
      NotificationItem(
        id: '5',
        userName: 'Lisa Park',
        userAvatar:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
        message: 'started following you',
        time: '2h',
        type: NotificationType.follow,
        isRead: true,
        isFollowing: true,
      ),
      NotificationItem(
        id: '6',
        userName: 'System',
        userAvatar:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
        message: 'Your order #12345 has been confirmed',
        time: '3h',
        type: NotificationType.order,
        isRead: true,
      ),
      NotificationItem(
        id: '7',
        userName: 'David Kim',
        userAvatar:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
        message: 'commented on your post: "Where did you get this?"',
        time: '1d',
        type: NotificationType.comment,
        isRead: true,
        postImage:
            'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=150',
      ),
    ];
  }
}
