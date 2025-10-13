# Permission Handling Example

This document shows how the improved permission handling works with action buttons in the toast messages.

## Visual Flow

### 1. User Taps Camera Button
The user taps the camera icon on the avatar to select or take a photo.

### 2. Permission Request Dialog (First Time)
- **iOS**: System alert appears: "Allow [App Name] to access your camera?"
- **Android**: System dialog appears: "Allow [App Name] to take pictures and record video?"

### 3. Permission Denied - Error Toast Appears

```
┌─────────────────────────────────────────┐
│  ❌ Permissão de acesso à câmera       │
│     negada.                            │
│                                        │
│                  [⚙️ Abrir Configurações]│
└─────────────────────────────────────────┘
```

The toast includes:
- **Error message** (red background)
- **Action button** labeled "Abrir Configurações" with a settings icon
- **Close button** (X) in the top-right corner

### 4. User Clicks "Abrir Configurações"
The app automatically navigates to the device settings page where the user can enable permissions:

**iOS**: Opens Settings > [App Name] > Permissions
**Android**: Opens Settings > Apps > [App Name] > Permissions

### 5. Permission Permanently Denied

If the user denies permission multiple times (or checks "Don't ask again" on Android):

```
┌─────────────────────────────────────────┐
│  ❌ Permissão de acesso à câmera       │
│     negada permanentemente.            │
│                                        │
│                  [⚙️ Abrir Configurações]│
└─────────────────────────────────────────┘
```

## Code Implementation

Here's how the permission handling is implemented in `GrxImagePickerService`:

```dart
static Future<CroppedFile?> openCamera() async {
  final status = await Permission.camera.request();
  
  if (status.isDenied || status.isPermanentlyDenied) {
    GrxToastService.showError(
      message:
          status.isPermanentlyDenied
              ? 'Permissão de acesso à câmera negada permanentemente.'
              : 'Permissão de acesso à câmera negada.',
      actions: [
        GrxToastAction(
          label: 'Abrir Configurações',
          icon: Icons.settings,
          onPressed: () => openAppSettings(),
        ),
      ],
    );
    return null;
  }
  
  final image = await _picker.pickImage(source: ImageSource.camera);
  if (image == null) return null;

  return cropImage(image.path);
}
```

## Usage in Your App

### Basic Usage

Simply use the `GrxUserAvatar` widget with `editable: true`:

```dart
import 'package:grex_ds/grex_ds.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _avatarFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: GrxUserAvatar(
          text: 'John Doe',
          imageFile: _avatarFile,
          editable: true,
          radius: 50,
          onPickAvatar: (file) {
            setState(() {
              _avatarFile = file;
            });
            
            if (file != null) {
              // Upload the image to your backend
              uploadAvatar(file);
            }
          },
        ),
      ),
    );
  }
  
  Future<void> uploadAvatar(File file) async {
    // Your upload logic here
    print('Uploading avatar: ${file.path}');
  }
}
```

### Custom Permission Messages

If you need to customize the messages for your specific use case, you can create a wrapper around the service:

```dart
import 'package:grex_ds/grex_ds.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomImagePicker {
  static Future<CroppedFile?> openCameraWithCustomMessage() async {
    final status = await Permission.camera.request();
    
    if (status.isDenied || status.isPermanentlyDenied) {
      GrxToastService.showError(
        message: 'We need camera access to take your photo!',
        actions: [
          GrxToastAction(
            label: 'Open Settings',
            icon: Icons.settings_outlined,
            onPressed: () => openAppSettings(),
          ),
        ],
      );
      return null;
    }
    
    // Continue with image picker logic...
  }
}
```

### Multiple Action Buttons

The toast service supports multiple action buttons if you need them:

```dart
GrxToastService.showError(
  message: 'Permissão de acesso à câmera negada.',
  actions: [
    GrxToastAction(
      label: 'Tentar Novamente',
      icon: Icons.refresh,
      onPressed: () => _retryPermission(),
    ),
    GrxToastAction(
      label: 'Abrir Configurações',
      icon: Icons.settings,
      onPressed: () => openAppSettings(),
    ),
  ],
);
```

## User Experience Best Practices

1. **Clear Messages**: The error messages clearly explain what went wrong
2. **Easy Action**: Users can tap one button to fix the issue
3. **Visual Feedback**: Error color (red) indicates something needs attention
4. **Icon Support**: Settings icon helps users understand what the button does
5. **Non-Intrusive**: Toast can be dismissed if the user wants to skip

## Testing Checklist

- [ ] Camera permission request shows system dialog
- [ ] Gallery permission request shows system dialog  
- [ ] Denying permission shows error toast with action button
- [ ] Tapping "Abrir Configurações" opens app settings
- [ ] Error toast shows "permanentemente" for permanent denials
- [ ] Toast auto-dismisses after timeout
- [ ] Toast can be manually closed with X button
- [ ] Permission works correctly after enabling in settings
- [ ] Works on both iOS and Android

## Troubleshooting

### Toast doesn't appear
Make sure you've initialized the toast service in your app:

```dart
@override
Widget build(BuildContext context) {
  GrxToastService.init(context);
  
  return MaterialApp(
    // your app configuration
  );
}
```

### Settings don't open
Ensure the `permission_handler` package is properly configured with platform-specific settings (see PERMISSIONS_SETUP.md).

### Permission always denied
Check that you've added the required permissions to:
- iOS: `Info.plist` (NSCameraUsageDescription, NSPhotoLibraryUsageDescription)
- Android: `AndroidManifest.xml` (CAMERA, READ_MEDIA_IMAGES)

