import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Bloc/Album/album_bloc.dart';
import 'package:skoolfame/Bloc/Friends/friends_bloc.dart';
import 'package:skoolfame/Bloc/High%20School/high_school_bloc.dart';
import 'package:skoolfame/Bloc/Home/home_bloc.dart';
import 'package:skoolfame/Bloc/Live/live_bloc.dart';
import 'package:skoolfame/Bloc/Login/login_bloc.dart';
import 'package:skoolfame/Bloc/Message/message_bloc.dart';
import 'package:skoolfame/Bloc/Notification/notification_bloc.dart';
import 'package:skoolfame/Bloc/Profile/profile_bloc.dart';
import 'package:skoolfame/Bloc/Setting/setting_bloc.dart';
import 'package:skoolfame/Bloc/Signup/signup_bloc.dart';
import 'package:skoolfame/Bloc/Video/video_bloc.dart';
import 'package:skoolfame/Routes/router.dart';
import 'package:skoolfame/Routes/routes.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  FirebaseMessaging.instance
      .getToken()
      .then((value) => print("Token ${value}"));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(),
        ),
        BlocProvider<SignupBloc>(
          create: (BuildContext context) => SignupBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (BuildContext context) => ProfileBloc(),
        ),
        BlocProvider<SettingBloc>(
          create: (BuildContext context) => SettingBloc(),
        ),
        BlocProvider<AlbumBloc>(
          create: (BuildContext context) => AlbumBloc(),
        ),
        BlocProvider<VideoBloc>(
          create: (BuildContext context) => VideoBloc(),
        ),
        BlocProvider<FriendsBloc>(
          create: (BuildContext context) => FriendsBloc(),
        ),
        BlocProvider<HighSchoolBloc>(
          create: (BuildContext context) => HighSchoolBloc(),
        ),
        BlocProvider<NotificationBloc>(
          create: (BuildContext context) => NotificationBloc(),
        ),
        BlocProvider<MessageBloc>(
          create: (BuildContext context) => MessageBloc(),
        ),
        BlocProvider<LiveBloc>(
          create: (BuildContext context) => LiveBloc(),
        ),
        BlocProvider<HomeBloc>(
          create: (BuildContext context) => HomeBloc(),
        ),
      ],
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Skoolfame',
          scaffoldMessengerKey: snackbarKey,
          theme: ThemeData(
              primarySwatch: Colors.orange,
              scaffoldBackgroundColor: Colors.white),

          // onGenerateRoute: generateRoute,
          initialRoute: Routes.SPLASH_SCREEN_ROUTE,
          routes: AppRouter.generateRoute(context),
          builder: EasyLoading.init(),
        );
      }),
    );
  }
}
