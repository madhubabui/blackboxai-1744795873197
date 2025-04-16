import 'package:flutter/material.dart';
import '../config/constants.dart';

class PermissionRequest extends StatelessWidget {
  final VoidCallback onRequest;

  const PermissionRequest({
    super.key,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_off_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 24),
          Text(
            'Storage Permission Required',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'To save WhatsApp statuses, ${AppConstants.appName} needs access to your device storage.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onRequest,
            icon: const Icon(Icons.folder_rounded),
            label: const Text('Grant Permission'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Why Storage Permission?'),
                  content: const SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Text('• To access and display WhatsApp statuses'),
                        SizedBox(height: 8),
                        Text('• To save selected statuses to your device'),
                        SizedBox(height: 8),
                        Text('• To manage saved statuses'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Learn More'),
          ),
        ],
      ),
    );
  }
}
