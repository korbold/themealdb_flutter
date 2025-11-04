import 'package:go_router/go_router.dart';
import '../../features/api/view/api_list_page.dart';
import '../../features/preferences/view/preferences_list_page.dart';
import '../../features/preferences/view/new_preference_page.dart';
import '../../features/preferences/view/preference_detail_page.dart';
import '../../core/models/api_meal_model.dart';

/// Application router configuration using go_router
class AppRouter {
  static GoRouter get router => _router;

  static final _router = GoRouter(
    initialLocation: '/api-list',
    routes: [
      GoRoute(
        path: '/api-list',
        name: 'api-list',
        builder: (context, state) => const ApiListPage(),
      ),
      GoRoute(
        path: '/prefs',
        name: 'prefs',
        builder: (context, state) => const PreferencesListPage(),
      ),
      GoRoute(
        path: '/prefs/new',
        name: 'prefs-new',
        builder: (context, state) {
          final meal = state.extra as ApiMealModel?;
          return NewPreferencePage(meal: meal);
        },
      ),
      GoRoute(
        path: '/prefs/:id',
        name: 'prefs-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PreferenceDetailPage(preferenceId: id);
        },
      ),
    ],
  );
}

