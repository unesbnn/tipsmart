import '../features/tips/models/bet.dart';

class Constants {
  Constants._();

  static final supportedBets = [
    Bet(id: 1, name: 'Match Winner'), //Match Winner
    Bet(id: 12, name: 'Double Chance'), //Double Chance
    Bet(id: 5, name: 'Goals Over/Under'), //Goals Over/Under
    Bet(id: 8, name: 'Both Teams Score'), //Both Teams Score
    Bet(id: 16, name: 'Total - Home'), //Total - Home
    Bet(id: 17, name: 'Total - Away'), //Total - Away
    // Bet(id: 11, name: 'Highest Scoring Half'), //Highest Scoring Half
  ];

  static const String leaguesBox = 'LeaguesBox';
  static const String simulatorBox = 'SimulatorBox';
  static const String fakeBetsBox = 'FakeBetsBox';
  static const String bettingStatsBox = 'BettingStatsBox';
  static const String balanceHistoryBox = 'BalanceHistoryBoxBox';
  static const String lastWatchTimestamp = 'LastWatchTimestamp';

  //
  static const double initialBalance = 1000;
  static const int videoAdReward = 500;

  //Date Format Patterns
  static const fullDatePattern = 'MMM dd, yyyy HH:mm';
  static const shortDatePattern = 'MMM dd';
  static const apiDatePattern = 'yyyy-MM-dd';

  static const String appPlayStoreUrl = 'https://play.google.com/store/apps/details?id=';
  static const String privacyUrl = 'https://betblitz.netlify.app/privacy';
  static const String termsUrl = 'https://betblitz.netlify.app/terms';
  static const String faqUrl = 'https://betblitz.netlify.app/faq';

  static const String admobBannerAdUnitIdTest = 'ca-app-pub-3940256099942544/6300978111';
  static const String admobMRecAdUnitIdTest = 'ca-app-pub-3940256099942544/6300978111';
  static const String admobInterstitialAdUnitIdTest = 'ca-app-pub-3940256099942544/1033173712';
  static const String admobRewardAdUnitIdTest = 'ca-app-pub-3940256099942544/5224354917';
  static const String admobAppOpenAdUnitIdTest = 'ca-app-pub-3940256099942544/9257395921';
}
