import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:task_manager/app/core/ui/theme/theme_config.dart';
import 'package:task_manager/app/core/utils/router_name_utils.dart';
import 'package:task_manager/app/pages/home/home_router.dart';
import 'package:task_manager/fake_task_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider(create: (context) => FakeTasksApi())],
      child: Sizer(
        builder: (context, orientation, screenType) => MaterialApp(
          title: 'Task Manager',
          debugShowCheckedModeBanner: false,
          theme: ThemeConfig.lightTheme,
          darkTheme: ThemeConfig.darkTheme,
          themeMode: ThemeMode.system,
          
          initialRoute: RouterNameUtils.getHomePage,
          routes: {
            RouterNameUtils.getHomePage: (context) => HomeRouter.page,
          },
        ),
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:task_manager/app/core/ui/theme/theme_config.dart';
import 'package:task_manager/app/core/utils/router_name_utils.dart';
import 'package:task_manager/app/pages/home/home_router.dart';
import 'package:task_manager/fake_task_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App());
}

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider(create: (context) => FakeTasksApi())],
      child: Sizer(
        builder: (context, orientation, screenType) => MaterialApp(
          title: 'Task Manager',
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          theme: ThemeConfig.theme,
          routes: {RouterNameUtils.getHomePage: (context) => HomeRouter.page},
        ),
      ),
    );
  }
}
*/