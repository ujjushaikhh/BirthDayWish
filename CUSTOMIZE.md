# Quick Customization Guide

## 🎯 Personalize for Your Special Someone

### Step 1: Edit the Recipient Name

Open `lib/main.dart` and change line 16:

```dart
// Before
home: const IntroScreen(recipientName: "Beautiful"),

// After - use any name
home: const IntroScreen(recipientName: "Sarah"),
```

### Step 2: Optional - Customize the Letter Message

Open `lib/wish_screen.dart` and find lines ~798-801 in the `_buildLetterOverlay()` method:

Change the greeting:
```dart
"Dear ${widget.name},"  // This auto-uses the custom name
```

Change the message (around line 802):
```dart
child: Text(
  "Your custom message here...\n\n"
  "Line 2...\n\n"
  "Signature",
  // ...
),
```

### Step 3: Build & Run

```bash
flutter run
```

That's it! The app will now show your custom name throughout.

---

## 🎨 Advanced Customization

### Change Accent Colors

All color hex codes are now consistent. Search for these and replace them:
- `#E85B8A` - Primary pink (main color)
- `#F5A39B` - Secondary rose
- `#FDC896` - Golden accent
- `#F18BA0` - Blend rose

**Files**: `lib/intro_screen.dart`, `lib/wish_screen.dart`

### Adjust Animation Speeds

- **Countdown**: Change `_remainingSeconds = 15` (line 37 in intro_screen.dart)
- **Pulse animations**: Modify duration in AnimationController initializations
- **Transitions**: Edit `transitionDuration: const Duration(milliseconds: 1200)`

### Modify Audio Files

Replace audio files in `assets/audio/`:
- `happybirthday.mp3` - Main birthday song
- `blast.mp3` - Tap effect sound

---

## 📱 Testing on Different Devices

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Web
flutter run -d chrome

# Desktop (Windows/Mac/Linux)
flutter run -d windows
```

---

## 💡 Pro Tips

1. **Test the letter reveal** - Press the "Open Gift" button to see the two-stage reveal
2. **Check responsiveness** - Resize browser window while running web version
3. **Listen for audio** - Button tap creates a subtle sound effect
4. **Watch for confetti** - Tapping anywhere after countdown triggers confetti
5. **Mobile feel** - Apps looks best on actual phone devices

---

## 🚨 Common Issues

**Q: Name not showing in wish screen?**  
A: Make sure you modified line 16 in `main.dart` with the correct parameter name.

**Q: Colors look different?**  
A: Check that you're running the latest version (hot reload might not pick up color changes—try hot restart)

**Q: Audio not playing?**  
A: Ensure audio files exist in `assets/audio/` directory and `pubspec.yaml` has them listed.

**Q: Animations look jerky on old phone?**  
A: This is normal on lower-end devices. Try `flutter run --profile` for better performance testing.

---

## 💝 Final Tips

- **Screenshot the final state** - The letter screen looks beautiful
- **Share the APK/IPA** - Build and share the compiled app
- **Surprise them!** - Let them experience it on their birthday
- **Personalize every time** - Change the name for different recipients

---

**Happy birthday gifting! 🎂✨**
