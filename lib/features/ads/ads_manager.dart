import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../commons/strings.dart';
import '../../commons/values.dart';
import 'admob/admob_banner_ad.dart';
import 'admob/admob_manager.dart';
import 'admob/admob_mrec_ad.dart';
import 'applovin/applovin_banner_ad.dart';
import 'applovin/applovin_manager.dart';
import 'applovin/applovin_mrec_ad.dart';

enum AdNetwork { admob, applovin }

class AdsManager {
  AdsManager._();

  static final AdsManager _instance = AdsManager._();

  static AdsManager get instance => _instance;

  final AdNetwork adNetwork = AdNetwork.admob;

  Timer? _timer;
  int _interval = 20;
  final int nextMinInterval = 60;
  final int nextMaxInterval = 120;

  //////////////////////////////////
  Future initializeAds() async {
    if (adNetwork == AdNetwork.admob) {
      await AdmobManager.instance.initializeAdmob();
    } else if (adNetwork == AdNetwork.applovin) {
      await ApplovinManager.instance.initApplovin();
    }
  }

  void showInterstitial() {
    if (adNetwork == AdNetwork.admob) {
      AdmobManager.instance.showInterstitialAd();
    } else if (adNetwork == AdNetwork.applovin) {
      ApplovinManager.instance.showInterstitialAd();
    }
  }

  void showRewardedVideoAd(Function() onReward) {
    if (adNetwork == AdNetwork.admob) {
      AdmobManager.instance.showRewardedVideoAd(onReward);
    } else if (adNetwork == AdNetwork.applovin) {
      //todo: implement Applovin rewarded video ad
    }
  }

  bool interstitialLoaded() {
    if (adNetwork == AdNetwork.admob) {
      return AdmobManager.instance.interstitialReady;
    } else if (adNetwork == AdNetwork.applovin) {
      return ApplovinManager.instance.interstitialReady;
    }
    return false;
  }

  Widget bannerAd() {
    if (adNetwork == AdNetwork.admob) {
      return const AdmobBannerAd();
    } else if (adNetwork == AdNetwork.applovin) {
      return const ApplovinBannerAd();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget mrecAd() {
    if (adNetwork == AdNetwork.admob) {
      return const AdmobMRecAd();
    } else if (adNetwork == AdNetwork.applovin) {
      return const ApplovinMRecAd();
    } else {
      return const SizedBox.shrink();
    }
  }

  //#region Interstitial Timer
  void startTimer(BuildContext context) {
    _timer = Timer.periodic(Duration(seconds: _interval), (timer) {
      final bool isReady = AdsManager.instance.interstitialLoaded();
      if (isReady) {
        _showAdAlertDialog(context);
        _setInterval();
        cancelTimer();
      }
    });
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  void _setInterval() {
    _interval =
        Random().nextInt(nextMaxInterval - nextMinInterval) + nextMinInterval;
  }

  void _showAdAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              Gap(DefaultValues.spacing),
              const Text(Strings.adBreak),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.of(context).pop();
        showInterstitial();
      }
    });
  }
//#endregion
}
