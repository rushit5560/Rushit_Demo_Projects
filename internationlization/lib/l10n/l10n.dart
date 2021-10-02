import 'dart:ui';

class L10n {
  static final all =[
    const Locale('en'),
    const Locale('ar'),
    const Locale('hi'),
    const Locale('es'),
    const Locale('de'),
  ];

  static String getFlag(String code){
    switch (code) {
      case 'ar':
        return 'AR';
      case 'hi':
        return 'HI';
      case 'es':
        return 'ES';
      case 'de':
        return 'DE';
      case 'en':
      default:
        return 'EN';
    }
  }
}