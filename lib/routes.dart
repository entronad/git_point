import 'package:flutter/material.dart';
import 'src/utils/navigation.dart';
import 'application.dart';

import './src/auth/index.dart';

// Placeholder for test
class TestScreen extends StatelessWidget {
  TestScreen(this.from, this.to);

  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text(from),
          onPressed: () {
            Application.router.navigateTo(context, to);
          },
        ),
      ),
    );
  }
}

class MainTabNavigator extends TabNavigator {
  @override
  Map<String, RouteConfig> get routeConfigs => {
    'Home': RouteConfig(
      screen: TestScreen('Home', 'Splash'),
      navigationOptions: NavigationOptions(
        tabBarIcon: Icons.home,
      )
    ),
    'Notifications': RouteConfig(
      screen: TestScreen('Notifications', 'Splash'),
      navigationOptions: NavigationOptions(
        tabBarIcon: Icons.notifications,
      )
    ),
    'Search': RouteConfig(
      screen: TestScreen('Search', 'Splash'),
      navigationOptions: NavigationOptions(
        tabBarIcon: Icons.search,
      )
    ),
    'MyProfile': RouteConfig(
      screen: Splash(),
      navigationOptions: NavigationOptions(
        tabBarIcon: Icons.person,
      )
    ),
  };

  @override
  TabNavigatorConfig get tabNavigatorConfig => super.tabNavigatorConfig;
}

class GitPoint extends StackNavigator {
  @override
  Map<String, RouteConfig> get routeConfigs => {
    'Splash': RouteConfig(
      screen: TestScreen('Splash', 'Login'),
    ),
    'Login': RouteConfig(
      screen: TestScreen('Login', 'Welcome'),
    ),
    'Welcome': RouteConfig(
      screen: TestScreen('Welcome', 'Main'),
    ),
    'Main': RouteConfig(
      screen: MainTabNavigator(),
    ),
  };

  @override
  StackNavigatorConfig get stackNavigatorConfig => super.stackNavigatorConfig;
}
