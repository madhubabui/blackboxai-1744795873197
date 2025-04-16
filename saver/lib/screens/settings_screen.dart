import 'package:flutter/material.dart';
import 'package:shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _checkPermission();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
    });
  }

  Future<void> _checkPermission() async {
    final status = await Permission.storage.status;
    setState(() {
      _hasPermission = status.isGranted;
    });
  }

  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // App Info Section
          _buildSection(
            title: 'App Information',
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('Version'),
                subtitle: Text(AppConstants.appVersion),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy Policy'),
                subtitle: Text(AppConstants.privacyDisclaimer),
              ),
            ],
          ),

          // Storage Section
          _buildSection(
            title: 'Storage',
            children: [
              ListTile(
                leading: Icon(
                  _hasPermission
                      ? Icons.folder_rounded
                      : Icons.folder_off_rounded,
                ),
                title: const Text('Storage Permission'),
                subtitle: Text(
                  _hasPermission
                      ? 'Permission granted'
                      : 'Permission required',
                ),
                trailing: _hasPermission
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    : TextButton(
                        onPressed: () async {
                          final status = await Permission.storage.request();
                          setState(() {
                            _hasPermission = status.isGranted;
                          });
                        },
                        child: const Text('Grant'),
                      ),
              ),
              ListTile(
                leading: const Icon(Icons.save_rounded),
                title: const Text('Saved Location'),
                subtitle: Text(AppConstants.savedStatusPath),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Saved statuses are stored in DCIM/Saver'),
                    ),
                  );
                },
              ),
            ],
          ),

          // Help Section
          _buildSection(
            title: 'Help',
            children: [
              for (var entry in AppConstants.settingsHelp.entries)
                ListTile(
                  leading: Icon(_getHelpIcon(entry.key)),
                  title: Text(_getHelpTitle(entry.key)),
                  subtitle: Text(entry.value),
                ),
            ],
          ),

          // About Section
          _buildSection(
            title: 'About',
            children: [
              const ListTile(
                leading: Icon(Icons.code_rounded),
                title: Text('Developer'),
                subtitle: Text('Created with Flutter'),
              ),
              ListTile(
                leading: const Icon(Icons.star_rounded),
                title: const Text('Rate App'),
                onTap: () {
                  // TODO: Implement app rating
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Rating feature coming soon!'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_rounded),
                title: const Text('Share App'),
                onTap: () {
                  // TODO: Implement app sharing
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sharing feature coming soon!'),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  IconData _getHelpIcon(String key) {
    switch (key) {
      case 'permissions':
        return Icons.folder_rounded;
      case 'whatsapp':
        return Icons.whatsapp;
      case 'storage':
        return Icons.save_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String _getHelpTitle(String key) {
    switch (key) {
      case 'permissions':
        return 'Storage Access';
      case 'whatsapp':
        return 'WhatsApp Setup';
      case 'storage':
        return 'Saved Files';
      default:
        return key;
    }
  }
}
