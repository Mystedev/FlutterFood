import 'package:flutter/material.dart';

class AddItemBottomSheet extends StatelessWidget {
  final TextEditingController itemController;
  final GlobalKey<FormState> formKey;
  final Function(String) onAddItem;

  const AddItemBottomSheet({
    super.key,
    required this.itemController,
    required this.formKey,
    required this.onAddItem,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: itemController,
              decoration: InputDecoration(
                labelText: 'Nuevo artículo',
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: colorScheme.primary,
                  ),
                  onPressed: () => onAddItem(itemController.text),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor ingresa un artículo';
                }
                return null;
              },
              autofocus: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.surfaceContainer,
                  foregroundColor: colorScheme.onPrimary,
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    onAddItem(itemController.text);
                  }
                },
                child: const Text('Añadir'),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
