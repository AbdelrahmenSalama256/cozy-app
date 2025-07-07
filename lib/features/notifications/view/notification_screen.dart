import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
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
      backgroundColor: AppColors.lightGrey,
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
      body: _buildAllNotifications(),
    );
  }

  Widget _buildAllNotifications() {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          isLoading = true;
        });
        _loadNotifications();
      },
      color: AppColors.primary,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationItem(notification);
        },
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: notification.isRead
            ? null
            : Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleNotificationTap(notification),
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24.r,
                      backgroundImage: NetworkImage(notification.userAvatar),
                      backgroundColor: AppColors.lightGrey,
                    ),
                    if (!notification.isRead)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 12.w),
                // Notification Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: notification.userName,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textBlack,
                              ),
                            ),
                            TextSpan(
                              text: ' ${notification.message}',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        notification.time,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Action Area
                _buildNotificationAction(notification),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationAction(NotificationItem notification) {
    switch (notification.type) {
      case NotificationType.follow:
        return _buildFollowButton(notification);
      case NotificationType.like:
      case NotificationType.comment:
        return _buildPostThumbnail(notification);
      case NotificationType.order:
      case NotificationType.promotion:
        return _buildActionIcon(notification);
    }
  }

  Widget _buildFollowButton(NotificationItem notification) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: notification.isFollowing ? Colors.grey[200] : AppColors.primary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        notification.isFollowing
            ? 'following'.tr(context)
            : 'follow'.tr(context),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: notification.isFollowing ? AppColors.textGrey : Colors.white,
        ),
      ),
    );
  }

  Widget _buildPostThumbnail(NotificationItem notification) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        image: notification.postImage != null
            ? DecorationImage(
                image: NetworkImage(notification.postImage!),
                fit: BoxFit.cover,
              )
            : null,
        color: notification.postImage == null ? AppColors.lightGrey : null,
      ),
      child: notification.postImage == null
          ? Icon(
              Icons.image_outlined,
              color: AppColors.textGrey,
              size: 20.sp,
            )
          : null,
    );
  }

  Widget _buildActionIcon(NotificationItem notification) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: _getNotificationColor(notification.type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        _getNotificationIcon(notification.type),
        color: _getNotificationColor(notification.type),
        size: 16.sp,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Icon(
              Icons.notifications_outlined,
              size: 40.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'no_notifications'.tr(context),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'no_notifications_message'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(NotificationItem notification) {
    if (!notification.isRead) {
      setState(() {
        notification.isRead = true;
      });
    }

    // Handle different notification actions
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

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.follow:
        return Icons.person_add_outlined;
      case NotificationType.like:
        return Icons.favorite_outline;
      case NotificationType.comment:
        return Icons.chat_bubble_outline;
      case NotificationType.order:
        return Icons.shopping_bag_outlined;
      case NotificationType.promotion:
        return Icons.local_offer_outlined;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.follow:
        return AppColors.primary;
      case NotificationType.like:
        return Colors.red;
      case NotificationType.comment:
        return Colors.blue;
      case NotificationType.order:
        return Colors.green;
      case NotificationType.promotion:
        return Colors.orange;
    }
  }
}

// Models
class NotificationItem {
  final String id;
  final String userName;
  final String userAvatar;
  final String message;
  final String time;
  final NotificationType type;
  final String? postImage;
  bool isRead;
  bool isFollowing;

  NotificationItem({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.message,
    required this.time,
    required this.type,
    this.postImage,
    this.isRead = false,
    this.isFollowing = false,
  });
}

enum NotificationType {
  follow,
  like,
  comment,
  order,
  promotion,
}
