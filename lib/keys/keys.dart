import 'package:envied/envied.dart';

part 'keys.g.dart';

@Envied(path: '.env')
abstract class Keys {
  @EnviedField(varName: 'RAPID_API_KEY', obfuscate: true)
  static String apiFootballApiKey = _Keys.apiFootballApiKey;

  @EnviedField(varName: 'ADMOB_BANNER_ID', obfuscate: true)
  static String admobBannerId = _Keys.admobBannerId;
  @EnviedField(varName: 'ADMOB_MREC_ID', obfuscate: true)
  static String admobMrecId = _Keys.admobMrecId;
  @EnviedField(varName: 'ADMOB_INTERSTITIAL_ID', obfuscate: true)
  static String admobInterstitialId = _Keys.admobInterstitialId;
  @EnviedField(varName: 'ADMOB_REWARDED_ID', obfuscate: true)
  static String admobRewardAdId = _Keys.admobRewardAdId;
  @EnviedField(varName: 'ADMOB_APP_OPEN_ID', obfuscate: true)
  static String admobAppOpenId = _Keys.admobAppOpenId;

  @EnviedField(varName: 'APPLOVIN_SDK_KEY', obfuscate: true)
  static final String applovinSdkKey = _Keys.applovinSdkKey;
  @EnviedField(varName: 'APPLOVIN_BANNER_ID', obfuscate: true)
  static final String applovinBannerId = _Keys.applovinBannerId;
  @EnviedField(varName: 'APPLOVIN_MREC_ID', obfuscate: true)
  static final String applovinMrecId = _Keys.applovinMrecId;
  @EnviedField(varName: 'APPLOVIN_INTERSTITIAL_ID', obfuscate: true)
  static final String applovinInterstitialId = _Keys.applovinInterstitialId;

  @EnviedField(varName: 'ONE_SIGNAL_APP_ID', obfuscate: true)
  static String oneSignalAppId = _Keys.oneSignalAppId;
}
