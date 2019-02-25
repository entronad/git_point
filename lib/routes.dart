import 'package:flutter/material.dart';
import 'src/utils/navigation.dart';
import 'application.dart';

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
      screen: TestScreen('Main', 'Splash'),
    ),
  };

  @override
  StackNavigatorConfig get stackNavigatorConfig => super.stackNavigatorConfig;
}
