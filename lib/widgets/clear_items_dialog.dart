import 'package:flutter/material.dart';

class ClearItemsDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ClearItemsDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: Theme.of(context).cardTheme.color,
      content: Text(
        'Vas a eliminar todos los elementos de la lista, estas seguro?',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancelar',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
