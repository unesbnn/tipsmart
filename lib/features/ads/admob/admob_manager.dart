import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../commons/constants.dart';
import '../../../commons/utils.dart';
import '../../../keys/keys.dart';

class AdmobManager {
  AdmobManager._();

  static final AdmobManager _instance = AdmobManager._();

  static AdmobManager get instance => _instance;

  bool interstitialReady = false;
  InterstitialAd? interstitialAd;
  RewardedAd? _rewardedAd;
  final bool testMode = true;

  Future initializeAdmob() async {
    await MobileAds.instance.initialize().then(
      (onValue) {
        requestConsentInfoUpdate();
        loadInterstitialAd();
        loadRewardedVideoAd();
      },
    );
  }

  void requestConsentInfoUpdate() {
    ConsentInformation.instance.reset();
    // final ConsentDebugSettings debugSettings = ConsentDebugSettings(
    //     debugGeography: DebugGeography.debugGeographyEea,
    //     testIdentifiers: ['BC74F2713F6035807D7D076C97D55FB2']);

    final ConsentRequestParameters params =
        ConsentRequestParameters(/*consentDebugSettings: debugSettings*/);
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          _loadForm();
        }
      },
      (FormError error) {
        // Handle the error
      },
    );
  }

  void _loadForm() {
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        final status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          consentForm.show(
            (FormError? formError) {
              // Handle dismissal by reloading form
              _loadForm();
            },
          );
        }
      },
      (formError) {
        // Handle the error
      },
    );
  }

  /// Loads an interstitial ad.
  void loadInterstitialAd() {
    final String adUnitId =
        testMode ? Constants.admobInterstitialAdUnitIdTest : Keys.admobInterstitialId;
    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {
                // canShowInterstitial = false;
                interstitialReady = false;
              },
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {
                // canShowInterstitial = false;
              },
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                // Dispose the ad here to free resources.
                // canShowInterstitial = true;
                interstitialReady = false;
                ad.dispose();
                loadInterstitialAd();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                // Dispose the ad here to free resources.
                // canShowInterstitial = true;
                ad.dispose();
                loadInterstitialAd();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {},
            );

            printMessage('AdmobManager', tag: '$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            interstitialAd = ad;
            interstitialReady = true;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            interstitialReady = false;
            printMessage('AdmobManager', tag: 'InterstitialAd failed to load: $error');
          },
        ));
  }

  void loadRewardedVideoAd() {
    final String adUnitId = testMode ? Constants.admobRewardAdUnitIdTest : Keys.admobRewardAdId;
    RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            printMessage('$ad loaded.');

            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                // Dispose the ad here to free resources.
                ad.dispose();
                _rewardedAd?.dispose();
                _rewardedAd = null;
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                // Dispose the ad here to free resources.
                ad.dispose();
                _rewardedAd?.dispose();
                _rewardedAd = null;
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {},
            );

            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            printMessage('RewardedAd failed to load: $error');
          },
        ));
  }

  void showInterstitialAd() {
    if (interstitialAd == null) {
      loadInterstitialAd();
    } else {
      interstitialAd?.show();
    }
  }

  void showRewardedVideoAd(Function() onReward) {
    if (_rewardedAd == null) {
      loadRewardedVideoAd();
    } else {
      _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
        onReward();
      });
    }
  }
}
