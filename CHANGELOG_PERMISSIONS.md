# Permission Handling Feature - Changelog

## Summary

Enhanced the image picker service with intelligent permission handling that provides a better user experience when camera or photo gallery permissions are denied. When permissions are denied, users now see error toasts with action buttons that allow them to quickly navigate to app settings to enable permissions.

## Changes

### 1. Added Dependencies

**File**: `pubspec.yaml`
- Added `permission_handler: ^11.3.1` for handling runtime permissions

### 2. Enhanced Image Picker Service

**File**: `lib/services/grx_image_picker.service.dart`

#### Before:
- Directly opened camera/gallery without permission checks
- No user feedback when access was denied
- Users had to manually navigate to settings

#### After:
- Requests camera permission before opening camera
- Requests photo gallery permission before opening gallery
- Shows error toasts when permissions are denied
- Includes "Abrir Configurações" action button in toasts
- Differentiates between regular denial and permanent denial
- Action button opens device settings automatically

**Key Features**:
```dart
// Permission states handled:
✓ Granted → Opens camera/gallery normally
✓ Denied → Shows error toast with settings button
✓ Permanently Denied → Shows error toast with "permanentemente" message + settings button
```

### 3. Documentation

#### PERMISSIONS_SETUP.md (New)
Comprehensive setup guide including:
- iOS Info.plist configuration with Portuguese usage descriptions
- Android AndroidManifest.xml permissions (Android 13+ support)
- Platform-specific setup instructions
- Testing guidelines
- Troubleshooting section

#### PERMISSION_EXAMPLE.md (New)
Developer guide with:
- Visual flow diagrams showing user experience
- Code examples and usage patterns
- Custom implementation examples
- Best practices
- Testing checklist

#### README.md (Updated)
- Added reference to permissions setup documentation
- Linked to PERMISSIONS_SETUP.md for users of GrxUserAvatar

## User Experience Flow

### Scenario 1: Permission Granted
1. User taps camera icon
2. System permission dialog appears (first time only)
3. User grants permission
4. Camera/gallery opens immediately

### Scenario 2: Permission Denied
1. User taps camera icon
2. System permission dialog appears
3. User denies permission
4. **Error toast appears** with:
   - Message: "Permissão de acesso à câmera negada."
   - Action button: "⚙️ Abrir Configurações"
5. User taps action button
6. **App settings open automatically**
7. User can enable permission

### Scenario 3: Permission Permanently Denied
1. User has denied permission multiple times
2. User taps camera icon
3. **Error toast appears** with:
   - Message: "Permissão de acesso à câmera negada **permanentemente**."
   - Action button: "⚙️ Abrir Configurações"
4. User taps action button
5. **App settings open automatically**

## Technical Implementation

### Permission States
```dart
enum PermissionStatus {
  granted,      // Camera/gallery opens normally
  denied,       // Show error toast with action button
  permanentlyDenied,  // Show error toast with "permanentemente" + action button
}
```

### Toast Actions
```dart
GrxToastAction(
  label: 'Abrir Configurações',  // User-friendly label
  icon: Icons.settings,           // Visual indicator
  onPressed: () => openAppSettings(),  // Direct navigation
)
```

### Error Messages (Portuguese)
- Camera denied: `"Permissão de acesso à câmera negada."`
- Camera permanently denied: `"Permissão de acesso à câmera negada permanentemente."`
- Gallery denied: `"Permissão de acesso à galeria negada."`
- Gallery permanently denied: `"Permissão de acesso à galeria negada permanentemente."`

## Platform Requirements

### iOS (Info.plist)
```xml
<key>NSCameraUsageDescription</key>
<string>Este aplicativo precisa de acesso à câmera para você poder tirar fotos do seu perfil</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Este aplicativo precisa de acesso à galeria para você poder selecionar fotos do seu perfil</string>
```

### Android (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

## Benefits

### For Users
✅ Clear feedback when permissions are denied
✅ One-tap navigation to settings
✅ No confusion about how to enable permissions
✅ Better overall app experience

### For Developers
✅ Automatic permission handling
✅ No boilerplate code needed
✅ Consistent error messaging
✅ Easy to customize
✅ Works with existing GrxUserAvatar widget

## Migration Guide

### If you're already using GrxUserAvatar

**No code changes required!** The permission handling is built-in.

Just add the platform-specific permissions:

1. **iOS**: Update `Info.plist` (see PERMISSIONS_SETUP.md)
2. **Android**: Update `AndroidManifest.xml` (see PERMISSIONS_SETUP.md)
3. **Run**: `flutter pub get` to install permission_handler
4. **Test**: Try denying permissions to see the new toasts

### If you're using GrxImagePickerService directly

The API hasn't changed - the same methods now include permission handling:

```dart
// This now includes automatic permission handling
final image = await GrxImagePickerService.openCamera();

// This also includes automatic permission handling
final gallery = await GrxImagePickerService.openGallery();
```

## Testing

### Manual Testing Steps
1. ✅ Uninstall and reinstall app (resets permissions)
2. ✅ Tap camera icon → Verify system dialog appears
3. ✅ Deny permission → Verify error toast with button appears
4. ✅ Tap "Abrir Configurações" → Verify settings open
5. ✅ Enable permission in settings
6. ✅ Return to app and try again → Verify camera opens
7. ✅ Repeat for gallery permissions

### Android-Specific
- ✅ Test with "Don't ask again" checked
- ✅ Verify "permanentemente" appears in message
- ✅ Test on Android 13+ (READ_MEDIA_IMAGES)

### iOS-Specific
- ✅ Deny twice to trigger permanent denial
- ✅ Verify proper settings page opens

## Version Compatibility

- Flutter SDK: ^3.7.0
- permission_handler: ^11.3.1
- iOS: 12.0+
- Android: API 21+ (Android 5.0+)
- Android 13+: Uses new photo picker with READ_MEDIA_IMAGES

## Future Enhancements

Potential improvements for future versions:

- [ ] Support for more permission types (microphone, location, etc.)
- [ ] Customizable toast duration based on message length
- [ ] Analytics tracking for permission denials
- [ ] In-app permission education before requesting
- [ ] Multi-language support for error messages
- [ ] Retry mechanism directly from toast
- [ ] Permission status indicator in UI

## References

- [permission_handler package](https://pub.dev/packages/permission_handler)
- [Android permissions](https://developer.android.com/guide/topics/permissions/overview)
- [iOS permissions](https://developer.apple.com/documentation/uikit/protecting_the_user_s_privacy)
- PERMISSIONS_SETUP.md (setup instructions)
- PERMISSION_EXAMPLE.md (code examples)

---

**Last Updated**: October 13, 2025
**Feature Status**: ✅ Complete and Ready for Production

