import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../commons/extensions.dart';
import '../../../commons/strings.dart';
import '../../../commons/tip_smart_icons.dart';
import '../../../commons/utils.dart';
import '../../../commons/values.dart';
import '../../../features/tips/blocs/fake_bets_cubit/fake_bets_cubit.dart';
import '../../../features/tips/models/tip_model.dart';
import '../../../features/tips/repositories/betslip_repository.dart';
import '../../widgets/bet_card.dart';
import '../../widgets/dashed_line_painter.dart';
import '../../widgets/info_widget.dart';
import '../../widgets/submit_fake_bet_widget.dart';

class BetSlipPage extends StatefulWidget {
  const BetSlipPage({super.key});

  @override
  State<BetSlipPage> createState() => _BetSlipPageState();
}

class _BetSlipPageState extends State<BetSlipPage> {
  late List<Tip> bets = [];
  late List<Tip> pendingBets = [];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Tip>>(
      valueListenable: context.read<BetSlipRepository>().box.listenable(),
      builder: (context, box, widget) {
        final bets = context.read<BetSlipRepository>().getAllBets();

        if (bets.isEmpty) {
          return InfoWidget(
            text: Strings.noBetsFound,
            icon: TipSmartIcons.empty,
            color: context.colorScheme.secondaryContainer,
          );
        }

        return Stack(
          children: [
            ListView.separated(
              padding: EdgeInsets.all(DefaultValues.padding / 4).copyWith(
                bottom: DefaultValues.height60,
              ),
              itemCount: bets.length,
              separatorBuilder: (_, __) => Container(
                margin:
                    EdgeInsets.symmetric(horizontal: DefaultValues.radius / 2),
                child: CustomPaint(
                  painter:
                      DashedLinePainter(color: context.colorScheme.secondary),
                ),
              ),
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(bets[index].id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => context
                      .read<BetSlipRepository>()
                      .deleteBetFromSimulator(bets[index].id),
                  confirmDismiss: (_) async {
                    return await showConfirmDialog(
                        context, Strings.confirmDeleteBet);
                  },
                  background: Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    clipBehavior: Clip.antiAlias,
                    color: context.colorScheme.error,
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: DefaultValues.padding),
                      child: Icon(
                        TipSmartIcons.clear,
                        color: context.colorScheme.onError,
                      ),
                    ),
                  ),
                  child: BetCard(bet: bets[index]),
                );
              },
            ),
            Positioned(
              bottom: DefaultValues.spacing,
              right: DefaultValues.spacing,
              child: Row(
                children: [
                  FloatingActionButton(
                    backgroundColor: context.colorScheme.primary,
                    foregroundColor: context.colorScheme.onPrimary,
                    onPressed: bets.isEmpty
                        ? null
                        : () async {
                            await showConfirmDialog(
                                    context, Strings.confirmDeleteBets)
                                .then((value) {
                              if ((value ?? false) && context.mounted) {
                                context
                                    .read<BetSlipRepository>()
                                    .deleteAllBets();
                              }
                            });
                          },
                    child: const Icon(TipSmartIcons.clear),
                  ),
                  Gap(DefaultValues.spacing / 2),
                  BlocConsumer<FakeBetsCubit, FakeBetsState>(
                    listener: fakeBetSubmitListener,
                    builder: (context, state) {
                      return FloatingActionButton.extended(
                        backgroundColor: context.colorScheme.primary,
                        foregroundColor: context.colorScheme.onPrimary,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            clipBehavior: Clip.antiAlias,
                            builder: (context) {
                              return SubmitFakeBetWidget(bets: bets);
                            },
                          );
                        },
                        label: const Text(Strings.submitBet),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
