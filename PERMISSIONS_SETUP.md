# Permission Setup Guide

This document explains how to configure platform-specific permissions for camera and photo gallery access in your Flutter application using the Grex Design System.

## iOS Setup

Add the following keys to your app's `Info.plist` file (located at `ios/Runner/Info.plist`):

```xml
<key>NSCameraUsageDescription</key>
<string>Este aplicativo precisa de acesso à câmera para você poder tirar fotos do seu perfil</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Este aplicativo precisa de acesso à galeria para você poder selecionar fotos do seu perfil</string>
```

For iOS 14 and later, also add:

```xml
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Este aplicativo precisa de acesso à galeria para você poder selecionar fotos do seu perfil</string>
```

## Android Setup

Add the following permissions to your app's `AndroidManifest.xml` file (located at `android/app/src/main/AndroidManifest.xml`):

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="your.package.name">
    
    <!-- Camera Permission -->
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-feature android:name="android.hardware.camera" android:required="false"/>
    
    <!-- Gallery/Storage Permissions -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" 
        android:maxSdkVersion="32"/>
    
    <!-- Android 13+ (API 33+) Photo Picker -->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
    
    <application>
        <!-- Your app configuration -->
    </application>
</manifest>
```

### Android 13+ Support

For Android 13 (API level 33) and above, the new photo picker is used automatically and requires `READ_MEDIA_IMAGES` permission. The old `READ_EXTERNAL_STORAGE` permission is still included for backward compatibility with older Android versions.

## How It Works

When a user attempts to select an avatar:

1. **Permission Granted**: The camera or gallery opens normally.
2. **Permission Denied**: An error toast is shown with the message "Permissão de acesso à câmera/galeria negada" and an "Abrir Configurações" button that allows the user to open the app settings directly.
3. **Permission Permanently Denied**: An error toast is shown with the message "Permissão de acesso à câmera/galeria negada permanentemente" and an "Abrir Configurações" button with a settings icon that opens the app settings page.

## Usage Example

The permission handling is integrated into the `GrxUserAvatar` widget. Simply use it with the `editable` parameter:

```dart
GrxUserAvatar(
  editable: true,
  onPickAvatar: (file) {
    // Handle the selected image file
    if (file != null) {
      // Upload or process the image
    }
  },
)
```

## Customizing Permission Messages

You can customize the permission messages and action button labels by modifying the `openCamera()` and `openGallery()` methods in `lib/services/grx_image_picker.service.dart`.

The default implementation includes:
- **Error Messages** (in Portuguese):
  - Camera denied: "Permissão de acesso à câmera negada"
  - Gallery denied: "Permissão de acesso à galeria negada"
  - Permanently denied: Adds "permanentemente" to the message
- **Action Button**: "Abrir Configurações" with a settings icon that calls `openAppSettings()`

## Testing Permissions

To test the permission flow:

1. **First request**: Tap the camera button - you should see a system permission dialog.
2. **Deny once**: Tap "Don't Allow" - an error toast should appear with an "Abrir Configurações" button.
3. **Tap the action button**: Click "Abrir Configurações" on the toast - the app settings page should open.
4. **Deny permanently** (Android): Tap "Don't Allow" and check "Don't ask again" - the toast will show "permanentemente" in the message.
5. **Deny permanently** (iOS): Deny twice - subsequent attempts will show the permanent denial message.

## Troubleshooting

### iOS
- Make sure all Info.plist keys are added correctly
- Clean and rebuild the project: `flutter clean && flutter pub get && cd ios && pod install && cd ..`

### Android
- Verify all permissions are in AndroidManifest.xml
- Make sure permissions are inside the `<manifest>` tag but outside the `<application>` tag
- For Android 13+, ensure `compileSdkVersion` is 33 or higher in `android/app/build.gradle`

### General
- Make sure the `permission_handler` package is properly installed: `flutter pub get`
- Check that `GrxToastService.init(context)` is called in your app initialization

