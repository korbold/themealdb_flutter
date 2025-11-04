import 'package:flutter/material.dart';
import '../models/api_meal_model.dart';

/// Card widget for displaying meal information
class MealCard extends StatelessWidget {
  final ApiMealModel meal;
  final VoidCallback? onTap;

  const MealCard({
    super.key,
    required this.meal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: meal.imageUrl != null
                    ? Image.network(
                        meal.imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.fastfood,
                            size: 80,
                            color: Colors.grey,
                          );
                        },
                      )
                    : const Icon(
                        Icons.fastfood,
                        size: 80,
                        color: Colors.grey,
                      ),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (meal.category != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        meal.category!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    if (meal.area != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        meal.area!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

