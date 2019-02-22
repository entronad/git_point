import 'package:flutter/material.dart';
import 'src/utils/navigation.dart';

Scaffold buildTestScreen(String text) => Scaffold(
  body: Text(text),
);

class GitPoint extends StackNavigator {
  @override
  Map<String, RouteConfig> get routeConfigs => {
    'Splash': RouteConfig(
      screen: buildTestScreen('Splash'),
    ),
    'Login': RouteConfig(
      screen: buildTestScreen('Login'),
    ),
    'Welcome': RouteConfig(
      screen: buildTestScreen('Welcome'),
    ),
    'Main': RouteConfig(
      screen: buildTestScreen('Main'),
    ),
  };

  @override
  StackNavigatorConfig get stackNavigatorConfig => super.stackNavigatorConfig;
}