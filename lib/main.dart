// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:task_manager/app/core/ui/theme/theme_config.dart';
import 'package:task_manager/app/core/ui/theme/theme_manager.dart';
import 'package:task_manager/app/core/utils/router_name_utils.dart';
import 'package:task_manager/app/pages/create/task_create_router.dart';
import 'package:task_manager/app/pages/edit/task_edit_router.dart';
import 'package:task_manager/app/pages/home/home_router.dart';
import 'package:task_manager/app/pages/settings/settings_router.dart';
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
      providers: [
        Provider(create: (context) => FakeTasksApi()),
        ChangeNotifierProvider(create: (context) => ThemeManager()),
      ],
      child: Sizer(
        builder: (context, orientation, screenType) {
          final themeManager = Provider.of<ThemeManager>(context);
          
          return MaterialApp(
            title: 'Task Manager',
            debugShowCheckedModeBanner: false,
            theme: ThemeConfig.lightTheme,
            darkTheme: ThemeConfig.darkTheme,
            themeMode: themeManager.themeMode,
            navigatorKey: navigatorKey,
            
            initialRoute: RouterNameUtils.getHomePage,
            onGenerateRoute: (settings) {
              // Rota Home
              if (settings.name == RouterNameUtils.getHomePage) {
                return MaterialPageRoute(
                  builder: (context) => HomeRouter.page,
                );
              }
              
              // Rota de Edição
              if (settings.name == RouterNameUtils.getTaskEditPage) {
                final args = settings.arguments as Map<String, dynamic>?;
                
                if (args == null) {
                  return MaterialPageRoute(
                    builder: (context) => HomeRouter.page,
                  );
                }
                
                final taskId = args['taskId'] as int;
                final taskTitle = args['taskTitle'] as String;
                
                return MaterialPageRoute(
                  builder: (context) => TaskEditRouter.getPage(
                    taskId: taskId,
                    taskTitle: taskTitle,
                  ),
                );
              }
              
              // Rota de Criação
              if (settings.name == RouterNameUtils.getTaskCreatePage) {
                return MaterialPageRoute(
                  builder: (context) => TaskCreateRouter.getPage(),
                );
              }
              
              // Rota de Configurações
              if (settings.name == RouterNameUtils.getSettingsPage) {
                return MaterialPageRoute(
                  builder: (context) => SettingsRouter.page,
                );
              }
              
              // Rota não encontrada
              return MaterialPageRoute(
                builder: (context) => HomeRouter.page,
              );
            },
          );
        },
      ),
    );
  }
}