import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/preference_list_cubit.dart';
import '../cubit/preference_state.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/error_widget.dart' show CustomErrorWidget;
import '../../../core/widgets/preference_card.dart';

/// Page displaying list of saved preferences
class PreferencesListPage extends StatefulWidget {
  const PreferencesListPage({super.key});

  @override
  State<PreferencesListPage> createState() => _PreferencesListPageState();
}

class _PreferencesListPageState extends State<PreferencesListPage> {
  @override
  void initState() {
    super.initState();
    // Load preferences when page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PreferenceListCubit>().loadAllPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Gustos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.pushNamed('api-list');
            },
            tooltip: 'Buscar platos',
          ),
        ],
      ),
      body: BlocBuilder<PreferenceListCubit, PreferenceState>(
        builder: (context, state) {
          // If state is PreferenceDetailSuccess or PreferenceInitial, reload
          if (state is PreferenceDetailSuccess || state is PreferenceInitial) {
            // Trigger reload and show loading
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<PreferenceListCubit>().loadAllPreferences();
            });
            return const LoadingWidget(message: 'Cargando gustos...');
          }
          
          if (state is PreferenceLoading) {
            return const LoadingWidget(message: 'Cargando gustos...');
          } else if (state is PreferenceError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<PreferenceListCubit>().loadAllPreferences();
              },
            );
          } else if (state is PreferenceSuccess) {
            if (state.preferences.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No tienes gustos guardados',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Busca platos y guárdalos como favoritos',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.pushNamed('api-list');
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('Buscar Platos'),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: state.preferences.length,
              itemBuilder: (context, index) {
                final preference = state.preferences[index];
                return PreferenceCard(
                  preference: preference,
                  onTap: () {
                    context.pushNamed(
                      'prefs-detail',
                      pathParameters: {'id': preference.id},
                    );
                  },
                  onDelete: () {
                    _showDeleteDialog(context, preference.id);
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('api-list');
        },
        child: const Icon(Icons.add),
        tooltip: 'Agregar nuevo gusto',
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar gusto'),
        content: const Text('¿Estás seguro de que deseas eliminar este gusto?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<PreferenceListCubit>().deletePreference(id);
              context.pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

