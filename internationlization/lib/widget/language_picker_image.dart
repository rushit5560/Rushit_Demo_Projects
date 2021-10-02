import 'package:flutter/material.dart';
import 'package:internationlization/l10n/l10n.dart';

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final flag = L10n.getFlag(locale.languageCode);
    return Center(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 50,
        child: Text(
          flag,
          style: TextStyle(
          fontSize: 80,
        ),
        ),
      ),
    );
  }
}

class LanguagePickerWidget extends StatelessWidget {
  const LanguagePickerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        icon: Container(width: 12),
        items: L10n.all.map(
              (locale){},
        ).toList(),
        onChanged: (_) {},
      ),
    );
  }
}

