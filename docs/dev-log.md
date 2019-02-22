为避免api使用normalizr proxy-polyfill，以1.5.0为准





App.js

切换locale

redux-persist进行rehydrate

codePush进行热更新

在willupdate时进行LayoutAnimation.spring();动画

在导航状态切换时获取routeName，以便查找对应的statusBar样式





路由（nav tab menu）

https://flutter.io/docs/cookbook/navigation/named-routes

https://flutter.io/docs/development/ui/widgets/material#App%20structure%20and%20navigation

fluro https://github.com/theyakka/fluro

i18n

https://flutter.io/docs/development/accessibility-and-localization/internationalization

状态管理(redux, redux-persist)

https://flutter.io/docs/development/data-and-backend/state-mgmt/intro

https://flutter.io/docs/development/data-and-backend/state-mgmt/options

BLoC

https://www.didierboelens.com/2018/08/reactive-programming---streams---bloc/

https://medium.com/flutterpub/architecting-your-flutter-project-bd04e144a8f1



MaterialApp 起到Navigator（Router）的作用

Scaffold 起到Screen（Route）的作用

StackNavigator用MaterialApp

TabNavigator用带BottomNavigationBar的Scaffold代替



为实现类似react-navigation的使用方式，导航器对象继承StackNavigator，重写参数的getter

StackNavigator中生成的router如何传递给子组件还是问题

screen参数只能是实例，不能是类也存在不匹配