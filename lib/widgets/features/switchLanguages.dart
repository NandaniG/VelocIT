import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../L10n/l10n.dart';
import '../../l10n/localeProvider.dart';
import 'package:provider/provider.dart';

import '../../utils/styles.dart';
import '../global/textFormFields.dart';
import 'package:velocit/utils/StringUtils.dart';

class FlutterLocalizationDemo extends StatelessWidget {
  const FlutterLocalizationDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _title(String val) {
      switch (val) {
        case 'en':
          return Text(
            'English',
            style: TextStyle(fontFamily: 'Roboto',fontSize: 16.0),
          );
        case 'id':
          return Text(
            'Indonesia',
            style: TextStyle(fontFamily: 'Roboto',fontSize: 16.0),
          );

        case 'hi':
          return Text(
            'Hindi',
            style: TextStyle(fontFamily: 'Roboto',fontSize: 16.0),
          );

        case 'it':
          return Text(
            'Italian',
            style: TextStyle(fontFamily: 'Roboto',fontSize: 16.0),
          );

        default:
          return Text(
            'English',
            style: TextStyle(fontFamily: 'Roboto',fontSize: 16.0),
          );
      }
    }

    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      var lang = provider.locale ?? Localizations.localeOf(context);
      return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: ThemeApp.whiteColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: IconButton(
                        icon:
                        Icon(Icons.arrow_back, color: ThemeApp.blackColor),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: TextFieldUtils()
                            .homePageheadingTextField(StringUtils.languages, context)),
                  ),
                ],
              ),
            )),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                StringUtils.login,
                style: TextStyle(fontFamily: 'Roboto',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height:85.0),
              DropdownButton(
                  value: lang,
                  onChanged: (Locale? val) {
                    provider.setLocale(val!);
                  },
                  items: L10n.all
                      .map((e) => DropdownMenuItem(
                    value: e,
                    child: _title(e.languageCode),
                  ))
                      .toList())
            ],
          ),
        ),
      );
    });
  }
}