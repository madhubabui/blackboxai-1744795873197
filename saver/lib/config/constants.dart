class AppConstants {
  // App Information
  static const String appName = 'Saver';
  static const String appVersion = '1.0.0';
  static const String privacyDisclaimer = 
    'Saver is not affiliated with WhatsApp. We respect your privacy.';
  
  // Storage Paths
  static const String whatsappStatusPath = '/storage/emulated/0/WhatsApp/Media/.Statuses';
  static const String savedStatusPath = '/storage/emulated/0/DCIM/Saver';
  static const String recycleBinPath = '/storage/emulated/0/DCIM/Saver/.recyclebin';
  
  // File Extensions
  static const List<String> supportedImageExtensions = ['.jpg', '.jpeg', '.png'];
  static const List<String> supportedVideoExtensions = ['.mp4', '.3gp'];
  
  // Durations
  static const Duration recycleBinRetention = Duration(hours: 24);
  static const Duration splashScreenDuration = Duration(seconds: 2);
  static const Duration snackBarDuration = Duration(seconds: 3);
  
  // UI Constants
  static const double gridSpacing = 2.0;
  static const int gridCrossAxisCount = 3;
  static const double borderRadius = 12.0;
  static const double elevation = 2.0;
  
  // Animation Durations
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration buttonAnimationDuration = Duration(milliseconds: 200);
  
  // Permissions
  static const List<String> requiredPermissions = [
    'android.permission.READ_EXTERNAL_STORAGE',
    'android.permission.WRITE_EXTERNAL_STORAGE'
  ];

  // Error Messages
  static const String errorNoStatuses = 'No statuses found';
  static const String errorPermissionDenied = 'Storage permission is required';
  static const String errorLoadingStatuses = 'Error loading statuses';
  static const String errorSavingStatus = 'Error saving status';
  static const String errorDeletingStatus = 'Error deleting status';

  // Success Messages
  static const String successStatusSaved = 'Status saved successfully';
  static const String successStatusDeleted = 'Status deleted successfully';
  static const String successMultipleStatusesSaved = 'All selected statuses saved';
  static const String successMultipleStatusesDeleted = 'Selected statuses deleted';

  // Onboarding
  static const List<Map<String, String>> onboardingData = [
    {
      'title': 'Welcome to Saver',
      'description': 'The most elegant way to save and manage your WhatsApp statuses',
      'image': 'assets/images/onboarding1.png',
    },
    {
      'title': 'Easy to Use',
      'description': 'View, save, and share statuses with just one tap',
      'image': 'assets/images/onboarding2.png',
    },
    {
      'title': 'Privacy First',
      'description': 'Your data stays on your device. No internet connection needed',
      'image': 'assets/images/onboarding3.png',
    },
  ];

  // Settings
  static const Map<String, String> settingsHelp = {
    'permissions': 'Allow storage access to view and save statuses',
    'whatsapp': 'Make sure WhatsApp is installed and statuses are enabled',
    'storage': 'Saved statuses can be found in DCIM/Saver folder',
  };
}
