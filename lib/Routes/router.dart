import 'package:flutter/material.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Screens/Activity/activity_screen.dart';
import 'package:skoolfame/Screens/Album/add_album_screen.dart';
import 'package:skoolfame/Screens/Album/add_photo_screen.dart';
import 'package:skoolfame/Screens/Album/image_album_details.dart';
import 'package:skoolfame/Screens/Album/images_album_screen.dart';
import 'package:skoolfame/Screens/FriendRequest/friend_request_screen.dart';
import 'package:skoolfame/Screens/HighSchool/highschool_screen.dart';
import 'package:skoolfame/Screens/HighSchool/my_superlatives_screen.dart';
import 'package:skoolfame/Screens/HighSchool/nominees_screen.dart';
import 'package:skoolfame/Screens/HighSchool/superlatives_screen.dart';
import 'package:skoolfame/Screens/Home/comment_screen.dart';
import 'package:skoolfame/Screens/Home/home_screen.dart';
import 'package:skoolfame/Screens/Live/live_message.dart';
import 'package:skoolfame/Screens/Live/live_streming.dart';
import 'package:skoolfame/Screens/Messages/chat_screen.dart';
import 'package:skoolfame/Screens/Messages/message_screen.dart';
import 'package:skoolfame/Screens/Onboarding/Remaining_details_screen.dart';
import 'package:skoolfame/Screens/Onboarding/forgot_password_screen.dart';
import 'package:skoolfame/Screens/Onboarding/login_screen.dart';
import 'package:skoolfame/Screens/Onboarding/request_school_screen.dart';
import 'package:skoolfame/Screens/Onboarding/signup_screen.dart';
import 'package:skoolfame/Screens/Onboarding/splash_screen.dart';
import 'package:skoolfame/Screens/Profile/profile_about_page.dart';
import 'package:skoolfame/Screens/Profile/profile_screen.dart';
import 'package:skoolfame/Screens/Relationship/my_relationship.dart';
import 'package:skoolfame/Screens/Relationship/relationship_request.dart';
import 'package:skoolfame/Screens/Relationship/relationship_screen.dart';
import 'package:skoolfame/Screens/Settings/feedback_screen.dart';
import 'package:skoolfame/Screens/Settings/notification_settings_screen.dart';
import 'package:skoolfame/Screens/Settings/settings_about_screen.dart';
import 'package:skoolfame/Screens/Video/add_album_video_screen.dart';
import 'package:skoolfame/Screens/Video/add_video_screen.dart';
import 'package:skoolfame/Screens/Video/play_video_screen.dart';
import 'package:skoolfame/Screens/Video/video_album_details.dart';
import 'package:skoolfame/Screens/Video/videos_album_screen.dart';
import 'package:skoolfame/Screens/dashboard.dart';
import 'package:skoolfame/Screens/notifications_screen.dart';

import '../Screens/Live/live_user_profile_screen.dart';

class AppRouter {
  static generateRoute(BuildContext context) {
    return {
      Routes.SPLASH_SCREEN_ROUTE: (BuildContext context) =>
          const SplashScreen(),
      Routes.LOGIN_SCREEN_ROUTE: (BuildContext context) => const LoginScreen(),
      Routes.SIGNUP_SCREEN_ROUTE: (BuildContext context) =>
          const SignupScreen(),
      Routes.HOME_SCREEN_ROUTE: (BuildContext context) => HomeScreen(),
      Routes.ACTIVITY_SCREEN_ROUTE: (BuildContext context) =>
          const ActivityScreen(),
      Routes.NOTIFICATIONS_SCREEN_ROUTE: (BuildContext context) =>
          const NotificationsScreen(),
      Routes.RELATIONSHIP_SCREEN_ROUTE: (BuildContext context) =>
          const RelationshipScreen(),
      Routes.ALBUM_SCREEN_ROUTE: (BuildContext context) =>
          const ImagesAlbumScreen(),
      Routes.VIDEO_SCREEN_ROUTE: (BuildContext context) =>
          const VideosAlbumScreen(),
      Routes.HIGH_SCHOOL_SCREEN_ROUTE: (BuildContext context) =>
          const HighSchoolScreen(),
      Routes.DASHBOARD_ROUTE: (BuildContext context) => const Dashboard(),
      Routes.MY_RELATIONSHIP_ROUTE: (BuildContext context) =>
          const MyRelationship(),
      Routes.RELATIONSHIP_REQUEST_ROUTE: (BuildContext context) =>
          const RelationshipRequest(),
      Routes.NOMINEES_ROUTE: (BuildContext context) => const NomineesScreen(),
      Routes.SUPERLATIVES_ROUTE: (BuildContext context) =>
          const SuperlativesScreen(),
      Routes.MY_SUPERLATIVES_ROUTE: (BuildContext context) =>
          const MySuperlativesScreen(),
      Routes.IMAGES_SCREEN_DETAILS: (BuildContext context) =>
          const ImageAlbumDetails(),
      Routes.VIDEOS_SCREEN_DETAILS: (BuildContext context) =>
          const VideoAlbumDetails(),
      Routes.ADD_PHOTO_SCREEN: (BuildContext context) => const AddPhotoScreen(),
      Routes.ADD_VIDEO_SCREEN: (BuildContext context) => const AddVideoScreen(),
      Routes.PROFILE_ABOUT_SCREEN: (BuildContext context) =>
          const ProfileAboutPage(),
      Routes.NOTIFICATION_SETTINGS_SCREEN: (BuildContext context) =>
          const NotificationSettingsScreen(),
      Routes.FEEDBACK_SCREEN: (BuildContext context) => const FeedBackScreen(),
      Routes.SETTINGS_ABOUT_SCREEN: (BuildContext context) =>
          const SettingsAboutScreen(),
      Routes.LIVE_USER_PROFILE_SCREEN: (BuildContext context) =>
          const LiveUserProfileScreen(),
      Routes.LIVE_MESSAGE: (BuildContext context) => const LiveMessage(),
      Routes.LIVE_STREAMING: (BuildContext context) => const LiveStream(),
      Routes.CHAT_SCREEN: (BuildContext context) => ChatScreen(),
      Routes.REMAINING_DEATAILS_SCREEN: (BuildContext context) =>
          const RemainingDetailsScreen(),
      Routes.FORGOT_PASSWORD_SCREEN: (BuildContext context) =>
          const ForgotPasswordScreen(),
      Routes.ADD_ALBUM_SCREEN: (BuildContext context) => const AddAlbumScreen(),
      Routes.ADD_VIDEO_ALBUM_SCREEN: (BuildContext context) =>
          const AddAlbumVideoScreen(),
      Routes.PLAY_VIDEO_SCREEN: (BuildContext context) =>
          const PlayVideoScreen(),
      Routes.REQUEST_SCHOOL_SCREEN: (BuildContext context) =>
          const RequestSchoolScreen(),
      Routes.FRIEND_REQUEST_SCREEN: (BuildContext context) =>
          const FriendRequestScreen(),
      Routes.PROFILE_SCREEN: (BuildContext context) => const ProfileScreen(),
      Routes.COMMENT_SCREEN: (BuildContext context) => const CommentScreen(),
      Routes.MESSAGE_SCREEN: (BuildContext context) => const MessageScreen(),
    };
  }
}
