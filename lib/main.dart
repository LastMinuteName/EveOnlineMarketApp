import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'app_themes.dart';
import 'pages/home_page/home_page.dart';
import 'model/database/dbmodel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  //create all models that need to be passed
  //down to children to be used throughout the application
  DbModel dbModel = DbModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: dbModel,
      child: FutureBuilder(
        future: dbModel.initDB(), //Initialize database
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget children;

          if (snapshot.hasData) {

          }
          else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text("Opening Application"),
                  ),
                ],
              ),
            );
          }

          return MaterialApp(
            theme: customTheme(
              brightness: Brightness.light,
            ),
            darkTheme: customTheme(
              brightness: Brightness.dark,
            ),
            themeMode: ThemeMode.system,
            title: 'Localizations Sample App',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            initialRoute: '/',
            routes: {
              '/': (context) => const HomePage()
            },
          );
        }
      ),
    );
  }
}
