import 'package:flutter/material.dart';
import 'package:property_management/chat/pages/list_chats_page.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  Future<dynamic> navigateToPage(Widget page) {
    // navigatorKey.currentState.pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) =>
    //         DashBoardPage()), (Route<dynamic> route) => route.settings.
    // );
    // navigatorKey.currentState.popUntil((MaterialPageRoute(builder: (context) => DashBoardPage())));
    return navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => page));
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }
}