import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/meal_card.dart';
import '../cubit/api_cubit.dart';
import '../cubit/api_state.dart';

/// Page displaying list of meals from API with search functionality
class ApiListPage extends StatefulWidget {
  const ApiListPage({super.key});

  @override
  State<ApiListPage> createState() => _ApiListPageState();
}

class _ApiListPageState extends State<ApiListPage> {
  final TextEditingController _searchController = TextEditingController();
  late final ApiCubit _apiCubit;

  @override
  void initState() {
    super.initState();
    _apiCubit = context.read<ApiCubit>();
    // Load random meal on init
    _apiCubit.getRandomMeal();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      _apiCubit.getRandomMeal();
    } else {
      _apiCubit.searchMeals(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Platos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              context.pushNamed('prefs');
            },
            tooltip: 'Ver favoritos',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar platos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _apiCubit.getRandomMeal();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          // Results
          Expanded(
            child: BlocBuilder<ApiCubit, ApiState>(
              builder: (context, state) {
                if (state is ApiLoading) {
                  return const LoadingWidget(message: 'Buscando platos...');
                } else if (state is ApiError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () {
                      if (_searchController.text.trim().isEmpty) {
                        _apiCubit.getRandomMeal();
                      } else {
                        _apiCubit.searchMeals(_searchController.text);
                      }
                    },
                  );
                } else if (state is ApiSuccess) {
                  if (state.meals.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No se encontraron platos',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.meals.length,
                    itemBuilder: (context, index) {
                      final meal = state.meals[index];
                      return MealCard(
                        meal: meal,
                        onTap: () {
                          // If we can pop, it means we came from navigation, so return the meal
                          if (context.canPop()) {
                            context.pop(meal);
                          } else {
                            // Otherwise, navigate to new preference page
                            context.pushNamed(
                              'prefs-new',
                              extra: meal,
                            );
                          }
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

