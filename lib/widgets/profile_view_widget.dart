import 'package:flutter/material.dart';
import 'package:flutter_food/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

class ProfileViewWidget extends StatefulWidget {
  const ProfileViewWidget({super.key});

  @override
  State<ProfileViewWidget> createState() => _ProfileViewWidgetState();
}

class _ProfileViewWidgetState extends State<ProfileViewWidget> {
  bool _notificationsEnabled = true;
  String _languageCode = 'es';

  void _openLanguagePicker() async {
    final String? selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: false,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Español'),
                trailing:
                    _languageCode == 'es' ? const Icon(Icons.check) : null,
                onTap: () => Navigator.of(context).pop('es'),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('English'),
                trailing:
                    _languageCode == 'en' ? const Icon(Icons.check) : null,
                onTap: () => Navigator.of(context).pop('en'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (selected != null && mounted) {
      setState(() {
        _languageCode = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final isDarkMode = themeNotifier.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: colorScheme.primary,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu perfil',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gestiona tu información personal',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Configuración',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: colorScheme.onPrimary,
                  value: isDarkMode,
                  onChanged: (enabled) =>
                      context.read<ThemeNotifier>().setDarkMode(enabled),
                  title: Text(isDarkMode ? 'Modo oscuro' : 'Modo claro'),
                  subtitle: Text(
                    'Cambia la apariencia de la aplicación',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  secondary: Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: colorScheme.secondary,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.language,
                    color: colorScheme.secondary,
                  ),
                  title: const Text('Idioma'),
                  subtitle: Text(_languageCode == 'es' ? 'Español' : 'English'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onTap: _openLanguagePicker,
                ),
                SwitchListTile(
                  activeColor: colorScheme.onPrimary,
                  value: _notificationsEnabled,
                  onChanged: (v) => setState(() => _notificationsEnabled = v),
                  title: const Text('Notificaciones'),
                  subtitle: Text('Recibir recordatorios y actualizaciones'),
                  secondary: Icon(
                    Icons.notifications_active,
                    color: colorScheme.tertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Acerca de',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            color: Theme.of(context).cardTheme.color,
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: colorScheme.secondary,
                  ),
                  title: const Text('Versión'),
                  subtitle: const Text('1.0.0'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.help_outline,
                    color: colorScheme.secondary,
                  ),
                  title: const Text('Ayuda y soporte'),
                  trailing: Icon(
                    Icons.open_in_new,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
