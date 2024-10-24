import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../commons/constants.dart';
import '../../../commons/extensions.dart';
import '../../../commons/strings.dart';
import '../../../commons/tip_smart_icons.dart';
import '../../../commons/values.dart';
import '../../../features/ads/ads_manager.dart';
import '../../../features/tips/blocs/api_state.dart';
import '../../../features/tips/blocs/fake_bets_cubit/fake_bets_cubit.dart';
import '../../../features/tips/blocs/tips_cubit/tips_cubit.dart';
import '../../../features/tips/blocs/tips_cubit/tips_state.dart';
import '../../../features/tips/models/bet.dart';
import '../../../features/tips/repositories/tips_repository.dart';
import '../../widgets/info_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/submit_fake_bet_widget.dart';
import '../../widgets/tip_card.dart';
import '../../widgets/tips_filter.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage>
    with AutomaticKeepAliveClientMixin {
  late DateTime _date;
  Bet _bet = Constants.supportedBets[0];
  List<String> _selectedStatus = TipStatus.values.map((v) => v.status).toList();

  @override
  void initState() {
    super.initState();
    _date = DateTime.now();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.colorScheme.primary,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            useSafeArea: true,
            isScrollControlled: true,
            builder: (context) {
              return TipsFilter(
                selectedDate: _date,
                selectedBet: _bet,
                selectedStatus: _selectedStatus,
                onReset: () {
                  setState(() {
                    _date = DateTime.now();
                    _bet = Constants.supportedBets[0];
                    _selectedStatus =
                        TipStatus.values.map((v) => v.status).toList();
                  });
                  Navigator.of(context).pop();
                },
                onSubmit: (date, bet, status) {
                  setState(() {
                    _date = date;
                    _bet = bet;
                    _selectedStatus = status;
                  });
                  Navigator.of(context).pop();
                },
              );
            },
          );
        },
        child: Icon(
          TipSmartIcons.filter,
          color: context.colorScheme.onPrimary,
        ),
      ),
      bottomNavigationBar: AdsManager.instance.bannerAd(),
      body: BlocProvider(
        key: ValueKey('${_date}_${_bet.id}'),
        create: (context) => TipsCubit(
          context.read<TipsRepository>(),
        )..getTips(
            date: DateFormat(Constants.apiDatePattern).format(_date),
            betId: _bet.id),
        child: BlocBuilder<TipsCubit, ApiState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const LoadingWidget();
            }
            if (state is ErrorState) {
              return InfoWidget(
                text: state.message,
                icon: TipSmartIcons.error,
                color: context.colorScheme.error,
                buttonText: Strings.retry,
                onButtonTaped: () => context.read<TipsCubit>().getTips(
                      date: DateFormat(Constants.apiDatePattern).format(_date),
                      betId: _bet.id,
                    ),
              );
            }
            if (state is TipsLoadedState) {
              final tips = state.tips
                  .where((tip) => _selectedStatus.contains(tip.status))
                  .toList();

              if (tips.isEmpty) {
                return InfoWidget(
                  text: Strings.noTipsFound,
                  icon: TipSmartIcons.empty,
                  color: context.colorScheme.secondaryContainer,
                );
              }

              return BlocConsumer<FakeBetsCubit, FakeBetsState>(
                listener: fakeBetSubmitListener,
                builder: (context, state) {
                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: DefaultValues.height60),
                    itemCount: tips.length,
                    itemBuilder: (context, index) {
                      return TipCard(
                        tip: tips[index],
                        onBet: () {
                          if (!tips[index].canAddToSimulator()) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: const Text(Strings.cantBet1),
                                  backgroundColor: context.colorScheme.error,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                          } else {
                            showModalBottomSheet(
                              context: context,
                              clipBehavior: Clip.antiAlias,
                              builder: (context) {
                                return SubmitFakeBetWidget(bets: [tips[index]]);
                              },
                            );
                          }
                        },
                      );
                    },
                  );
                },
              );
            }

            return InfoWidget(
              text: Strings.somethingWentWrong,
              icon: TipSmartIcons.empty,
              color: context.colorScheme.secondaryContainer,
            );
          },
        ),
      ),
    );
  }
}
