import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/preference_detail_cubit.dart';
import '../cubit/preference_list_cubit.dart';
import '../cubit/preference_state.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/error_widget.dart' show CustomErrorWidget;
import '../../../core/services/exception_logger.dart';

/// Page displaying details of a saved preference
class PreferenceDetailPage extends StatefulWidget {
  final String preferenceId;

  const PreferenceDetailPage({
    super.key,
    required this.preferenceId,
  });

  @override
  State<PreferenceDetailPage> createState() => _PreferenceDetailPageState();
}

class _PreferenceDetailPageState extends State<PreferenceDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Gusto'),
      ),
      body: BlocProvider(
        create: (_) => PreferenceDetailCubit()..loadPreferenceById(widget.preferenceId),
        child: BlocConsumer<PreferenceDetailCubit, PreferenceState>(
        listener: (context, state) {
          // Log errors to file
          if (state is PreferenceError) {
            ExceptionLogger.writeException(
              'PreferenceDetailPage Error: ${state.message}',
            );
          }
        },
        builder: (context, state) {
          // If state is PreferenceDetailSuccess with correct ID, show it
          if (state is PreferenceDetailSuccess) {
            if (state.preference.id == widget.preferenceId) {
              final preference = state.preference;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image
                    if (preference.imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          preference.imageUrl!,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 250,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.fastfood,
                                size: 100,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.fastfood,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 24),
                    // Custom name
                    Text(
                      preference.customName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    // Original name
                    Text(
                      preference.apiMealName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    // Details
                    if (preference.category != null) ...[
                      _buildDetailRow(
                        context,
                        'Categoría',
                        preference.category!,
                        Icons.category,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (preference.area != null) ...[
                      _buildDetailRow(
                        context,
                        'Área',
                        preference.area!,
                        Icons.location_on,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (preference.instructions != null) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.description),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Instrucciones',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                preference.instructions!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    // Delete button
                    ElevatedButton.icon(
                      onPressed: () => _showDeleteDialog(context, preference.id),
                      icon: const Icon(Icons.delete),
                      label: const Text('Eliminar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Back button
                    OutlinedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Volver'),
                    ),
                  ],
                ),
              );
            } else {
              // ID distinto al esperado: esperar estado correcto
              return const LoadingWidget(message: 'Cargando...');
            }
          }

          // Handle loading state
          if (state is PreferenceLoading) {
            return const LoadingWidget(message: 'Cargando...');
          }

          // Handle error state
          if (state is PreferenceError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                if (!mounted) return;
                try {
                  context.read<PreferenceDetailCubit>().loadPreferenceById(widget.preferenceId);
                } catch (e, stackTrace) {
                  ExceptionLogger.writeException(
                    'Error retrying preference ${widget.preferenceId}: $e',
                    stackTrace: stackTrace,
                  );
                }
              },
            );
          }
          // Estado inicial u otros no manejados
          return const LoadingWidget(message: 'Cargando...');
        },
      ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar gusto'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este gusto? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Usar el cubit de lista global para eliminar
              context.read<PreferenceListCubit>().deletePreference(id);
              context.pop();
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gusto eliminado')),
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
