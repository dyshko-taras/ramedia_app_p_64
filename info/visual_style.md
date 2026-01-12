# Flutter Android App - Visual Style Guide

This design system document is optimized for LLM usage to generate a Flutter Android application.

## Color System

### Background Colors

#### Background1
- **Hex:** #F5F5F5
- **RGBA:** rgba(245,245,245,1)
- **HSLA:** hsla(0,0,96,1)
- **Flutter:** Color(0xFFF5F5F5)
- **Usage:** Main app background, card backgrounds


#### Background2
- **Hex:** #9DC24A
- **RGBA:** rgba(157,194,74,1)
- **HSLA:** hsla(78,50,53,1)
- **Flutter:** Color(0xFF9DC24A)
- **Usage:** Navigation bars, header backgrounds, feature highlights


### Accent Colors

#### Primary
- **Hex:** #9DC24A
- **RGBA:** rgba(157,194,74,1)
- **HSLA:** hsla(78,50,53,1)
- **Flutter:** Color(0xFF9DC24A)
- **Usage:** Primary buttons, active states, links


#### Secondary
- **Hex:** #E59117
- **RGBA:** rgba(229,145,23,1)
- **HSLA:** hsla(36,82,49,1)
- **Flutter:** Color(0xFFE59117)
- **Usage:** Secondary buttons, progress indicators, highlights


### Text Colors

#### Primary
- **Hex:** #FEFEFE
- **RGBA:** rgba(254,254,254,1)
- **HSLA:** hsla(0,0,100,1)
- **Flutter:** Color(0xFFFEFEFE)
- **Usage:** Primary text on dark backgrounds, headers on colored backgrounds


#### Secondary
- **Hex:** #172514
- **RGBA:** rgba(23,37,20,1)
- **HSLA:** hsla(109,30,11,1)
- **Flutter:** Color(0xFF172514)
- **Usage:** Body text, headings on light backgrounds


#### Quaternary
- **Hex:** #9DC24A
- **RGBA:** rgba(157,194,74,1)
- **HSLA:** hsla(78,50,53,1)
- **Flutter:** Color(0xFF9DC24A)
- **Usage:** Accent text, emphasized labels


#### Text 6
- **Hex:** #6F6F6F
- **RGBA:** rgba(111,111,111,1)
- **HSLA:** hsla(0,0,44,1)
- **Flutter:** Color(0xFF6F6F6F)
- **Usage:** Secondary body text, captions, disabled text


### Icon Colors

#### Primary
- **Hex:** #172514
- **RGBA:** rgba(23,37,20,1)
- **HSLA:** hsla(109,30,11,1)
- **Flutter:** Color(0xFF172514)
- **Usage:** Default icon color, active navigation icons


#### Secondary
- **Hex:** #9DC24A
- **RGBA:** rgba(157,194,74,1)
- **HSLA:** hsla(78,50,53,1)
- **Flutter:** Color(0xFF9DC24A)
- **Usage:** Accent icons, highlighted icons


#### Tertiary
- **Hex:** #FDFDFD
- **RGBA:** rgba(253,253,253,1)
- **HSLA:** hsla(0,0,99,1)
- **Flutter:** Color(0xFFFDFDFD)
- **Usage:** Icons on dark backgrounds


### Layer Colors

#### Primary
- **Hex:** #FFFFFF
- **RGBA:** rgba(255,255,255,1)
- **HSLA:** hsla(0,0,100,1)
- **Flutter:** Color(0xFFFFFFFF)
- **Usage:** Card surfaces, modals, dropdowns


#### Secondary
- **Hex:** #ECECEC
- **RGBA:** rgba(236,236,236,1)
- **HSLA:** hsla(0,0,93,1)
- **Flutter:** Color(0xFFECECEC)
- **Usage:** Input backgrounds, secondary surfaces


#### Red
- **Hex:** #D12222
- **RGBA:** rgba(209,34,34,1)
- **HSLA:** hsla(0,72,48,1)
- **Flutter:** Color(0xFFD12222)
- **Usage:** Error messages, delete actions, alerts


## Typography

### Font Family
**Primary Font:** Montserrat  
Add to pubspec.yaml:
```yaml
flutter:
  fonts:
    - family: Montserrat
      fonts:
        - asset: fonts/Montserrat-Light.ttf
          weight: 300
        - asset: fonts/Montserrat-Medium.ttf
          weight: 500
        - asset: fonts/Montserrat-SemiBold.ttf
          weight: 600
        - asset: fonts/Montserrat-Bold.ttf
          weight: 700
```

### Text Styles

#### Headers

**Header1:**
- Font: Montserrat
- Weight: Bold (700)
- Size: 30px
- Line Height: 35px
- Letter Spacing: 0%
- Case: Upper
- Usage: Page titles, section headers

Flutter TextStyle:
```dart
TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w700,
  fontSize: 30,
  height: 1.1666666666666667,
  letterSpacing: 0,
)
```


**Header2:**
- Font: Montserrat
- Weight: Bold (700)
- Size: 60px
- Line Height: 35px
- Letter Spacing: 0%
- Case: Upper
- Usage: Hero titles, main headings

Flutter TextStyle:
```dart
TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w700,
  fontSize: 60,
  height: 0.5833333333333334,
  letterSpacing: 0,
)
```


#### Body Text

**Body1:**
- Font: Montserrat
- Weight: Light
- Size: 24px
- Line Height: 26px
- Letter Spacing: 0.5px
- Usage: Large body text, introductions

Flutter TextStyle:
```dart
TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w300,
  fontSize: 24,
  height: 1.0833333333333333,
  letterSpacing: 0.5,
)
```


**Body2:**
- Font: Montserrat
- Weight: SemiBold
- Size: 22px
- Line Height: 28px
- Letter Spacing: 0%
- Usage: Emphasized body text, card titles

Flutter TextStyle:
```dart
TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w600,
  fontSize: 22,
  height: 1.2727272727272727,
  letterSpacing: 0,
)
```


**Body3:**
- Font: Montserrat
- Weight: Medium
- Size: 16px
- Line Height: 20px
- Letter Spacing: 0.10px
- Usage: Standard body text, form labels

Flutter TextStyle:
```dart
TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w500,
  fontSize: 16,
  height: 1.25,
  letterSpacing: 0.1,
)
```


**Body4:**
- Font: Montserrat
- Weight: Medium
- Size: 12px
- Line Height: 16px
- Letter Spacing: 0.5px
- Usage: Small text, captions, navigation labels

Flutter TextStyle:
```dart
TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w500,
  fontSize: 12,
  height: 1.3333333333333333,
  letterSpacing: 0.5,
)
```


## Design Tokens (Flutter Implementation)

Create a `app_theme.dart` file:

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Background
  static const background1 = Color(0xFFF5F5F5);
  static const background2 = Color(0xFF9DC24A);
  
  // Accent
  static const accentPrimary = Color(0xFF9DC24A);
  static const accentSecondary = Color(0xFFE59117);
  
  // Text
  static const textPrimary = Color(0xFFFEFEFE);
  static const textSecondary = Color(0xFF172514);
  static const textQuaternary = Color(0xFF9DC24A);
  static const textGray = Color(0xFF6F6F6F);
  
  // Icon
  static const iconPrimary = Color(0xFF172514);
  static const iconSecondary = Color(0xFF9DC24A);
  static const iconTertiary = Color(0xFFFDFDFD);
  
  // Layers
  static const layerPrimary = Color(0xFFFFFFFF);
  static const layerSecondary = Color(0xFFECECEC);
  static const layerError = Color(0xFFD12222);
}

class AppTextStyles {
  static const header1 = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    fontSize: 30,
    height: 1.17,
  );
  
  static const header2 = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    fontSize: 60,
    height: 0.58,
  );
  
  static const body1 = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w300,
    fontSize: 24,
    height: 1.08,
    letterSpacing: 0.5,
  );
  
  static const body2 = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
    fontSize: 22,
    height: 1.27,
  );
  
  static const body3 = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.25,
    letterSpacing: 0.1,
  );
  
  static const body4 = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.33,
    letterSpacing: 0.5,
  );
}

ThemeData getAppTheme() {
  return ThemeData(
    primaryColor: AppColors.accentPrimary,
    scaffoldBackgroundColor: AppColors.background1,
    fontFamily: 'Montserrat',
    colorScheme: ColorScheme.light(
      primary: AppColors.accentPrimary,
      secondary: AppColors.accentSecondary,
      error: AppColors.layerError,
      surface: AppColors.layerPrimary,
    ),
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.header2,
      displayMedium: AppTextStyles.header1,
      bodyLarge: AppTextStyles.body1,
      bodyMedium: AppTextStyles.body3,
      bodySmall: AppTextStyles.body4,
      titleMedium: AppTextStyles.body2,
    ),
  );
}
```

## Usage Guidelines

### For LLM Code Generation:

1. **Color Application:**
   - Use AppColors constants for all color references
   - Primary accent (#9DC24A) for main actions and navigation
   - Secondary accent (#E59117) for highlights and progress
   - Text colors should contrast appropriately with backgrounds

2. **Typography:**
   - Use AppTextStyles constants for text styling
   - Maintain the Montserrat font family throughout
   - Respect the hierarchy: Header2 > Header1 > Body1 > Body2 > Body3 > Body4

3. **Component Styling:**
   - Cards and surfaces use layerPrimary (#FFFFFF)
   - Inputs and secondary surfaces use layerSecondary (#ECECEC)
   - Navigation bars use background2 (#9DC24A)

4. **Accessibility:**
   - Ensure text meets WCAG AA contrast ratios
   - Use textSecondary (#172514) on light backgrounds
   - Use textPrimary (#FEFEFE) on dark backgrounds

Generated: 1/12/2026, 5:47:08 PM
