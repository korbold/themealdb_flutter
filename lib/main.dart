import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/routes/app_router.dart';
import 'features/api/cubit/api_cubit.dart';
import 'features/preferences/cubit/preference_list_cubit.dart';

/// Main entry point of the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

/// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ApiCubit()),
        BlocProvider(
          create: (_) => PreferenceListCubit()..init(),
          lazy: false,
        ),
      ],
      child: MaterialApp.router(
        title: 'Prueba Técnica',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
