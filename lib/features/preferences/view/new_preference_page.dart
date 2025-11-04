import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/api_meal_model.dart';
import '../cubit/preference_list_cubit.dart';

/// Page for creating a new preference from an API meal
class NewPreferencePage extends StatefulWidget {
  final ApiMealModel? meal;

  const NewPreferencePage({super.key, this.meal});

  @override
  State<NewPreferencePage> createState() => _NewPreferencePageState();
}

class _NewPreferencePageState extends State<NewPreferencePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  ApiMealModel? _selectedMeal;

  @override
  void initState() {
    super.initState();
    _selectedMeal = widget.meal;
    if (_selectedMeal != null) {
      _nameController.text = _selectedMeal!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectMeal() async {
    final meal = await context.push<ApiMealModel>(
      '/api-list',
    );
    if (meal != null) {
      setState(() {
        _selectedMeal = meal;
        if (_nameController.text.isEmpty) {
          _nameController.text = meal.name;
        }
      });
    }
  }

  void _savePreference() {
    if (_formKey.currentState!.validate() && _selectedMeal != null) {
      context.read<PreferenceListCubit>().createPreference(
            customName: _nameController.text.trim(),
            apiMeal: _selectedMeal!,
          );
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gusto guardado exitosamente')),
      );
    }
  }

  void _cancel() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Gusto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Select meal button
              Card(
                child: InkWell(
                  onTap: _selectMeal,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.restaurant_menu),
                            const SizedBox(width: 8),
                            Text(
                              'Plato de la API',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                        if (_selectedMeal != null) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if (_selectedMeal!.imageUrl != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    _selectedMeal!.imageUrl!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.fastfood);
                                    },
                                  ),
                                )
                              else
                                const Icon(Icons.fastfood, size: 60),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedMeal!.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    if (_selectedMeal!.category != null)
                                      Text(
                                        _selectedMeal!.category!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ] else
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Toca para seleccionar un plato',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Custom name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre personalizado',
                  hintText: 'Ej: Mi plato favorito',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancel,
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _savePreference,
                      child: const Text('Guardar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

