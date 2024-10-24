import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../commons/extensions.dart';
import '../../../commons/strings.dart';
import '../../../commons/tip_smart_icons.dart';
import '../../../features/tips/repositories/fake_bets_repository.dart';
import '../../widgets/fake_bet_widget.dart';
import '../../widgets/info_widget.dart';

class FakeBetsPage extends StatelessWidget {
  const FakeBetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<FakeBetsRepository>().box.listenable(),
      builder: (context, box, widget) {
        final fakeBets = context.read<FakeBetsRepository>().getAllFakeBets();

        if (fakeBets.isEmpty) {
          return InfoWidget(
            text: Strings.noFakeBetsFound,
            icon: TipSmartIcons.empty,
            color: context.colorScheme.secondaryContainer,
          );
        }

        return ListView.builder(
          itemCount: fakeBets.length,
          itemBuilder: (context, index) {
            return FakeBetWidget(fakeBet: fakeBets[index]);
          },
        );
      },
    );
  }
}
