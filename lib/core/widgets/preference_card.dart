import 'package:flutter/material.dart';
import '../models/local_preference_model.dart';

/// Card widget for displaying saved preference
class PreferenceCard extends StatelessWidget {
  final LocalPreferenceModel preference;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const PreferenceCard({
    super.key,
    required this.preference,
    this.onTap,
    this.onDelete,
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
                child: preference.imageUrl != null
                    ? Image.network(
                        preference.imageUrl!,
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
                      preference.customName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      preference.apiMealName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (preference.category != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        preference.category!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              // Delete button
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onDelete,
                  color: Theme.of(context).colorScheme.error,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

