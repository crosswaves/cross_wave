import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_speak_talk/presentation/screen/info_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_speak_talk/auth_utils.dart';
import 'package:flutter_speak_talk/presentation/screen/login_screen.dart';
import 'firebase_options.dart';
import 'presentation/screen/home_screen.dart';
import 'presentation/screen/intro_level_screen.dart';
import 'presentation/screen/intro_name_screen.dart';
import 'presentation/screen/info_photo_screen.dart';
import 'presentation/screen/info_pay_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    GoRouter router = GoRouter(
      initialLocation: '/login',
      // initialLocation: '/',
      routes: [
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) => const Login(),
        ),
        GoRoute(
          path: '/name_set',
          builder: (BuildContext context, GoRouterState state) =>
              const IntroNameScreen(),
        ),
        GoRoute(
          path: '/profile_set',
          builder: (BuildContext context, GoRouterState state) =>
              const InfoPhotoScreen(),
        ),
        GoRoute(
          path: '/pay_set',
          builder: (BuildContext context, GoRouterState state) =>
              const InfoPayScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) =>
              const HomeScreen(),
        ),
        GoRoute(
          path: '/info',
          builder: (BuildContext context, GoRouterState state) =>
              InfoScreen(),
        ),
        GoRoute(
          path: '/level_set',
          builder: (BuildContext context, GoRouterState state) =>
              const IntroLevelScreen(),
        ),

      ],
      redirect: (BuildContext context, GoRouterState state) async {
        final isLoggedIn = await AuthUtils.getLoginStatus();
        final isFirstLoginCompleted = await AuthUtils.getFirstLoginCompleted();

        if (state.matchedLocation == '/login' && isLoggedIn) {
          return isFirstLoginCompleted ? '/' : '/name_set';
        } else if (!isLoggedIn) {
          return '/login';
          // return '/';
        }


        return null;
      },
    );

    return MaterialApp.router(
      title: 'Flutter Speak',
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
