/// A simulation of react-navigation

import 'package:flutter/material.dart' hide Colors;
import 'package:fluro/fluro.dart';
import 'package:git_point/application.dart';
import 'package:git_point/src/config/index.dart';

class Distance {
  Distance({this.horizontal, this.vertical});

  final num horizontal;
  final num vertical;
}

class NavigationOptions {
  NavigationOptions({
    this.title,
    this.header,
    this.headerTitle,
    this.headerTitleAllowFontScaling,
    this.headerBackImage,
    this.headerBackTitle,
    this.headerTruncatedBackTitle,
    this.headerRight,
    this.headerLeft,
    this.headerStyle,
    this.headerForceInset,
    this.headerTitleStyle,
    this.headerBackTitleStyle,
    this.headerTintColor,
    this.headerPressColorAndroid,
    this.headerTransparent,
    this.headerBackground,
    this.gesturesEnabled,
    this.gestureResponseDistance,
    this.gestureDirection,

    this.swipeEnabled,
    this.tabBarIcon,
    this.tabBarLabel = '',
    this.tabBarOnPress,
  });

  // For StackNavigator
  final String title;
  final Widget header;
  final String headerTitle;
  final bool headerTitleAllowFontScaling;
  final String headerBackImage;
  final String headerBackTitle;
  final String headerTruncatedBackTitle;
  final Widget headerRight;
  final Widget headerLeft;
  final Object headerStyle;
  final bool headerForceInset;
  final Object headerTitleStyle;
  final Object headerBackTitleStyle;
  final String headerTintColor;
  final String headerPressColorAndroid;
  final bool headerTransparent;
  final Widget headerBackground;
  final bool gesturesEnabled;
  final Distance gestureResponseDistance;
  final String gestureDirection;

  // For TabNavigator
  final bool swipeEnabled;
  final IconData tabBarIcon;
  final String tabBarLabel;
  final Function tabBarOnPress;
}

class RouteConfig {
  RouteConfig({@required this.screen, this.path, this.navigationOptions});

  final Widget screen;
  final String path;
  final NavigationOptions navigationOptions;
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
  // Required to override.
  Map<String, RouteConfig> get routeConfigs;
  // Optional to ovveride.
  StackNavigatorConfig get stackNavigatorConfig => null;

  @override
  _StackNavigatorState createState() => _StackNavigatorState(routeConfigs, stackNavigatorConfig);
}

class _StackNavigatorState extends State<StackNavigator> {
  _StackNavigatorState(Map<String, RouteConfig> routeConfigs, StackNavigatorConfig stackNavigatorConfig) {
    routeConfigs.forEach((name, config) {
      initialRoute ??= name;
      Application.router.define(name, handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => config.screen));
    });
  }

  String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: Application.router.generator,
      initialRoute: initialRoute,
    );
  }
}

abstract class TabNavigator extends StatefulWidget {
  // Required to override.
  Map<String, RouteConfig> get routeConfigs;
  // Optional to ovveride.
  TabNavigatorConfig get tabNavigatorConfig => null;

  @override
  _TabNavigatorState createState() => _TabNavigatorState(routeConfigs, tabNavigatorConfig);
}

class _TabNavigatorState extends State<TabNavigator> {
  _TabNavigatorState(Map<String, RouteConfig> routeConfigs, TabNavigatorConfig tabNavigatorConfig) {
    routeConfigs.forEach((name, config) {
      _widgetOptions.add(config.screen);
      _barItems.add(BottomNavigationBarItem(
        icon: Icon(config.navigationOptions.tabBarIcon, color: Colors.grey),
        activeIcon: Icon(config.navigationOptions.tabBarIcon, color: Colors.primaryDark),
        // Workaround to 'showLabel: false'
        title: Container(height: 0.0),
      ));
    });
  }

  int _selectedIndex = 0;
  final _widgetOptions = <Widget>[];
  final _barItems = <BottomNavigationBarItem>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(canvasColor: Colors.alabaster),
        child: BottomNavigationBar(
          items: _barItems,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
