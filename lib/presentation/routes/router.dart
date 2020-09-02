import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter_notes_app/presentation/sign_in/sign_in_page.dart';
import 'package:flutter_notes_app/presentation/splash/splash_page.dart';

@MaterialAutoRouter(
  routes: [
    MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: SignInPage)
  ],
  generateNavigationHelperExtension: true
)
class $Router {}
