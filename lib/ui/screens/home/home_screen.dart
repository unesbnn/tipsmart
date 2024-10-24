import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../commons/app_config.dart';
import '../../../commons/extensions.dart';
import '../../../commons/strings.dart';
import '../../../commons/tip_smart_icons.dart';
import '../../../commons/utils.dart';
import '../../../features/ads/ads_manager.dart';
import 'betslip_page.dart';
import 'fake_bets_page.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'tips_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late final PageController _pageController;
  int _selectedIndex = 0;

  late final AppLifecycleListener _listener;
  late AppLifecycleState? _state;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _state = SchedulerBinding.instance.lifecycleState;
    _listener = AppLifecycleListener(
      onStateChange: _handleStateChange,
    );
    startInterstitialTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  startInterstitialTimer() => AdsManager.instance.startTimer(context);

  cancelInterstitialTimer() => AdsManager.instance.cancelTimer();

  void _handleStateChange(AppLifecycleState state) {
    printMessage(state.name, tag: 'ADMOB_TIMER');
    switch (state) {
      case AppLifecycleState.resumed:
        startInterstitialTimer();
        break;
      default:
        cancelInterstitialTimer();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppConfig.name),
        actions: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
            icon: Icon(
              TipSmartIcons.profile,
              color: context.colorScheme.primary,
            ),
          )
        ],
      ),
      endDrawer: const Drawer(
        child: SafeArea(child: ProfilePage()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.shifting,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          _pageController.animateToPage(
            _selectedIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(TipSmartIcons.home),
            label: Strings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(TipSmartIcons.tips),
            label: Strings.tips,
          ),
          BottomNavigationBarItem(
            icon: Icon(TipSmartIcons.betslip),
            label: Strings.betslip,
          ),
          BottomNavigationBarItem(
            icon: Icon(TipSmartIcons.bets),
            label: Strings.myBets,
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: _pages,
      ),
    );
  }

  List<Widget> get _pages => [
        const HomePage(),
        const TipsPage(),
        const BetSlipPage(),
        const FakeBetsPage(),
      ];
}
