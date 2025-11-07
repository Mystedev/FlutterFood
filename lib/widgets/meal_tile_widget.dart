import 'package:flutter/material.dart';
import 'package:flutter_food/models/meal.dart' as model;

class MealTileWidget extends StatelessWidget {
  final DateTime date;
  final String type;
  final model.Meal? meal;
  final VoidCallback onTap;

  const MealTileWidget({
    super.key,
    required this.date,
    required this.type,
    required this.meal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasMeal = meal != null && (meal!.name.isNotEmpty);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: hasMeal ? colorScheme.surfaceContainer : colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            type == 'Comida' ? Icons.lunch_dining : Icons.dinner_dining,
            color: hasMeal ? colorScheme.onPrimary : colorScheme.primaryFixed,
          ),
        ),
        title: Text(
          type,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          hasMeal ? meal!.name : 'Añadir $type',
          style: TextStyle(
            fontStyle: hasMeal ? FontStyle.normal : FontStyle.italic,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 19,
          color: hasMeal ? colorScheme.onSurface : colorScheme.outlineVariant,
        ),
        onTap: onTap,
      ),
    );
  }
}
