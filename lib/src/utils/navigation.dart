/// A simulation of react-navigation

import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

class RouteConfig {
  RouteConfig({@required this.screen, this.path, this.navigationOptions});

  final Widget screen;
  final String path;
  final Function navigationOptions;
}

class StackNavigatorConfig {
  StackNavigatorConfig({
    this.initialRouteName,
    this.initialRouteParams,
    this.navigationOptions,
    this.paths,
    this.mode,
    this.headerMode,
    this.headerTransitionPreset,
    this.cardStyle,
    this.transitionConfig,
    this.onTransitionStart,
    this.onTransitionEnd,
  });

  final String initialRouteName;
  final Object initialRouteParams;
  final Object navigationOptions;
  final Map<String, String> paths;

  final String mode;
  final String headerMode;
  final String headerTransitionPreset;
  final Object cardStyle;
  final Function transitionConfig;
  final Function onTransitionStart;
  final Function onTransitionEnd;
}

class TabNavigatorConfig {
  TabNavigatorConfig({
    this.tabBarComponent,
    this.tabBarPosition,
    this.swipeEnabled,
    this.animationEnabled,
    this.lazy,
    this.removeClippedSubviews,
    this.configureTransition,
    this.initialLayout,
    this.initialRouteName,
    this.order,
    this.paths,
  });

  final Widget tabBarComponent;
  final String tabBarPosition;
  final bool swipeEnabled;
  final bool animationEnabled;
  final bool lazy;
  final bool removeClippedSubviews;
  final Function configureTransition;
  final Map<String, num> initialLayout;
  // final Object tabBarOptions;

  final String initialRouteName;
  final List<String> order;
  final Map<String, String> paths;
}

abstract class StackNavigator extends StatefulWidget {
  // required to override
  Map<String, RouteConfig> get routeConfigs;
  // optional to ovveride
  StackNavigatorConfig get stackNavigatorConfig => null;

  @override
  _StackNavigatorState createState() => _StackNavigatorState(routeConfigs, stackNavigatorConfig);
}

class _StackNavigatorState extends State<StackNavigator> {
  _StackNavigatorState(Map<String, RouteConfig> routeConfigs, StackNavigatorConfig stackNavigatorConfig) {
    routeConfigs.forEach((name, config) {
      initialRoute ??= name;
      router.define(name, handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => config.screen));
    });
  }

  final router = Router();
  String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: router.generator,
      initialRoute: initialRoute,
    );
  }
}


