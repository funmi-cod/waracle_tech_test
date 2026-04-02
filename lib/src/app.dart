import 'package:cake_it_app/src/features/cakes/bloc/cake_bloc.dart';
import 'package:cake_it_app/src/features/cakes/bloc/cake_event.dart';
import 'package:cake_it_app/src/features/cakes/data/cake_repository.dart';
import 'package:cake_it_app/src/features/cakes/view/cake_details_view.dart';
import 'package:cake_it_app/src/features/cakes/view/cake_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localization/app_localizations.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return RepositoryProvider(
          create: (context) => CakeRepository(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            restorationScopeId: 'app',

            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],

            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,

            theme: ThemeData(),
            darkTheme: ThemeData.dark(),
            themeMode: settingsController.themeMode,

            // Define a function to handle named routes in order to support
            // Flutter web url navigation and deep linking.
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case SettingsView.routeName:
                      return SettingsView(controller: settingsController);
                    case CakeDetailsView.routeName:
                      return const CakeDetailsView();
                    case CakeListView.routeName:
                    default:
                      return BlocProvider(
                        create: (context) => CakeBloc(
                          cakeRepository:
                              RepositoryProvider.of<CakeRepository>(context),
                        )..add(FetchCakes()),
                        child: const CakeListView(),
                      );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
