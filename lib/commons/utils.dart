import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../features/tips/models/tip_model.dart';
import 'app_config.dart';
import 'constants.dart';
import 'extensions.dart';
import 'strings.dart';

void printMessage(String message, {String tag = 'DEBUGGING'}) {
  debugPrint('$tag: $message');
}

List<List<T>> splitList<T>(List<T> list, {int size = 10}) {
  final List<List<T>> result = [];

  for (int i = 0; i < list.length; i += size) {
    result.add(list.sublist(i, i + size > list.length ? list.length : i + size));
  }

  return result;
}

double calculateOdd(List<Tip> bets) {
  return bets.map((tip) => tip.betValueOdd).reduce((value, element) => value * element);
}

double calculatePotentialProfit(double stake, double odds) {
  return (stake * odds) - stake;
}

double calculatePotentialWinning(double stake, double odds) {
  return (stake * odds);
}

String formatNumber(num? number, {bool excludeU = false, bool excludeK = false, bool excludeAll = false}) {
  if (number == null) return '';
  if (excludeAll) return NumberFormat('#,##0.00', 'en_US').format(number);
  if (excludeK && number < 1000000) return NumberFormat('#,##0.00', 'en_US').format(number);
  if (excludeU && number < 1000) return NumberFormat('#,##0.00', 'en_US').format(number);
  return NumberFormat.compact().format(number);
}

Future openLink(String url, {LaunchMode? mode}) async {
  if (!await launchUrl(Uri.parse(url), mode: mode ?? LaunchMode.inAppBrowserView)) {
    printMessage('can\'t launch url');
  }
}

String teamLogo(int? teamId) {
  if (teamId == null) return '';
  return 'https://media.api-sports.io/football/teams/$teamId.png';
}

String leagueLogo(int? leagueId) {
  if (leagueId == null) return '';
  return 'https://media.api-sports.io/football/leagues/$leagueId.png';
}

String countryFlag(int? countryId) {
  if (countryId == null) return '';
  return 'https://media.api-sports.io/flags/$countryId.svg';
}

Future rateApp() async {
  String appUrl = '';

  if (Platform.isAndroid) {
    appUrl += '${Constants.appPlayStoreUrl}${AppConfig.packageName}';
  }

  await openLink(appUrl, mode: LaunchMode.externalApplication);
}

Future shareApp() async {
  final index = Random().nextInt(Strings.shareMessages.length);
  String shareMessage = Strings.shareMessages[index];

  if (Platform.isAndroid) {
    shareMessage += '\n${Constants.appPlayStoreUrl}${AppConfig.packageName}';
  }
  await Share.share(shareMessage, subject: AppConfig.name);
}

Future<bool?> showConfirmDialog(BuildContext context, String title) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        titleTextStyle: context.textTheme.titleMedium,
        actionsAlignment: MainAxisAlignment.center,
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text(Strings.no),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: FilledButton.styleFrom(
              backgroundColor: context.colorScheme.error,
              foregroundColor: context.colorScheme.onError,
            ),
            child: const Text(Strings.yes),
          ),
        ],
      );
    },
  );
}

Future showRateDialog(BuildContext context) async {
  final RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 0,
    minLaunches: 3,
    remindDays: 3,
    remindLaunches: 5,
    googlePlayIdentifier: AppConfig.packageName,
    appStoreIdentifier: AppConfig.packageName,
  );

  final bool ignoreNativeDialog = kDebugMode ? Platform.isAndroid : false;
  rateMyApp.init().then((_) {
    if (rateMyApp.shouldOpenDialog && context.mounted) {
      rateMyApp.showRateDialog(
        context,
        title: Strings.rateAppTitle.replaceAll('##', AppConfig.name),
        message: Strings.rateAppMessage.replaceAll('##', AppConfig.name),
        rateButton: Strings.rate,
        noButton: Strings.noThanks,
        laterButton: Strings.later,
        listener: (button) {
          switch (button) {
            case RateMyAppDialogButton.rate:
              debugPrint('Clicked on "Rate".');
              break;
            case RateMyAppDialogButton.later:
              debugPrint('Clicked on "Later".');
              break;
            case RateMyAppDialogButton.no:
              debugPrint('Clicked on "No".');
              break;
          }

          return true;
        },
        ignoreNativeDialog: ignoreNativeDialog,
        dialogStyle: DialogStyle(
          titleStyle: context.textTheme.titleLarge,
          messageStyle: context.textTheme.bodyMedium,
          titleAlign: TextAlign.center,
          messageAlign: TextAlign.center,
        ),
        // Custom dialog styles.
        onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
        // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
      );
    }
  });
}