import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../commons/colors.dart';
import '../../commons/extensions.dart';
import '../../commons/strings.dart';
import '../../commons/utils.dart';
import '../../commons/values.dart';
import '../../features/tips/blocs/fake_bets_cubit/fake_bets_cubit.dart';
import '../../features/tips/models/tip_model.dart';
import '../../features/tips/repositories/fake_bets_repository.dart';
import 'balance_card.dart';
import 'outlined_text_form_field.dart';
import 'summary_card.dart';

class SubmitFakeBetWidget extends StatefulWidget {
  const SubmitFakeBetWidget({
    super.key,
    required this.bets,
  });

  final List<Tip> bets;

  @override
  State<SubmitFakeBetWidget> createState() => _SubmitFakeBetWidgetState();
}

class _SubmitFakeBetWidgetState extends State<SubmitFakeBetWidget> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_BetValueState');
  late final TextEditingController _stakeController;
  final int _step = 50;
  final double _minStake = 10;
  double _stake = 100;
  late double _totalOdds;
  late double _potentialWinning;

  @override
  void initState() {
    super.initState();
    _stakeController = TextEditingController();
    _setControllerText();
    _totalOdds = calculateOdd(widget.bets);
    _calculatePotentialWinning();
  }

  @override
  void didUpdateWidget(SubmitFakeBetWidget oldWidget) {
    _calculatePotentialWinning();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _stakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:MediaQuery.of(context).viewInsets,
      child: ValueListenableBuilder(
        valueListenable: context.read<FakeBetsRepository>().statsBox.listenable(),
        builder: (context, box, widget) {
          final bettingStats = context.read<FakeBetsRepository>().getBettingStats();
          final balance = bettingStats.balance;
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(DefaultValues.padding / 2),
                color: context.colorScheme.secondaryContainer,
                child: Text(
                  Strings.createBet.toUpperCase(),
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              BalanceCard(bettingStats: bettingStats),
              Padding(
                padding: EdgeInsets.all(DefaultValues.padding / 4),
                child: DottedBorder(
                  dashPattern: const [5, 2],
                  color: context.colorScheme.primary,
                  padding: EdgeInsets.all(DefaultValues.padding / 2),
                  strokeWidth: 1.r,
                  child: Column(
                    children: [
                      Text(
                        Strings.adjustStake,
                        style: context.textTheme.bodyLarge,
                      ),
                      Gap(DefaultValues.spacing / 2),
                      _adjustStakeWidget(context, balance),
                      Gap(DefaultValues.spacing / 2),
                      Divider(
                        height: DefaultValues.spacing,
                        color: context.colorScheme.primary,
                      ),
                      _summary(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _adjustStakeWidget(BuildContext context, double balance) {
    return Row(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: SizedBox(
              height: 40,
              child: OutlinedTextFormField(
                controller: _stakeController,
                contentPadding: EdgeInsets.symmetric(
                  vertical: DefaultValues.padding / 2,
                  horizontal: DefaultValues.padding,
                ),
                filled: false,
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.done,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                  signed: false,
                ),
                inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[-, ,,]'))],
                validator: (value) => _validate(value, balance),
                onFieldSubmitted: (value) => _onStakeFieldSubmit(value),
              ),
            ),
          ),
        ),
        Gap(DefaultValues.spacing / 4),
        IconButton.outlined(
          style: IconButton.styleFrom(
            side: BorderSide(color: context.colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
            ),
          ),
          onPressed: _stake <= _minStake ? null : () => _decrementStake(),
          icon: const Icon(Icons.remove),
        ),
        IconButton.outlined(
          style: IconButton.styleFrom(
            side: BorderSide(color: context.colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
            ),
          ),
          onPressed: (_stake >= balance) ? null : () => _incrementStake(balance),
          icon: const Icon(Icons.add),
        ),
        Gap(DefaultValues.spacing / 4),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text(Strings.insufficientBalance),
                    backgroundColor: AppColors.redColor,
                    duration: Duration(seconds: 2),
                  ),
                );
              return;
            }
            _submitBet(context);
            Navigator.of(context).pop();
          },
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
            ),
          ),
          child: const Text(Strings.bet),
        )
      ],
    );
  }

  void _submitBet(BuildContext context) {
    final bool containsBlocked = widget.bets.map((bet) => bet.canAddToSimulator()).contains(false);
    if(containsBlocked) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text(Strings.cantBet2),
            backgroundColor: context.colorScheme.error,
            duration: const Duration(seconds: 2),
          ),
        );
      return;
    }
    context.read<FakeBetsCubit>().submitFakeBet(widget.bets, _stake);
  }

  Widget _summary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SummaryCard(
            title: Strings.events,
            info: '${widget.bets.length}',
          ),
        ),
        Expanded(
          child: SummaryCard(
            title: Strings.totalOdds,
            info: formatNumber(_totalOdds, excludeK: true),
          ),
        ),
        Expanded(
          child: SummaryCard(
            title: Strings.potentialWinning,
            info: formatNumber(_potentialWinning, excludeK: true),
          ),
        ),
      ],
    );
  }

  void _calculatePotentialWinning() {
    _potentialWinning = calculatePotentialWinning(_stake, _totalOdds);
  }

  void _setControllerText() {
    _stakeController.text = _stake.toStringAsFixed(2);
  }

  void _onStakeFieldSubmit(String value) {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _stake = double.parse(value);
      _calculatePotentialWinning();
    });
  }

  String? _validate(String? value, double balance) {
    try {
      final val = double.parse(value!);
      if (val > balance || val < _minStake) {
        return Strings.insufficientBalance;
      }
      return null;
    } catch (e) {
      return Strings.invalidValue;
    }
  }

  void _incrementStake(double balance) {
    setState(() {
      if (_stake + _step > balance) {
        _stake = balance;
      } else {
        _stake += _step;
      }
      _setControllerText();
      _calculatePotentialWinning();
    });
  }

  void _decrementStake() {
    return setState(() {
      if (_stake - _step < _minStake) {
        _stake = _minStake;
      } else {
        _stake -= _step;
      }
      _setControllerText();
      _calculatePotentialWinning();
    });
  }
}

void fakeBetSubmitListener(context, state) {
  if (state is FakeBetsAdding) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('${Strings.submittingTip}...'),
          backgroundColor: AppColors.orangeColor,
          duration: Duration(seconds: 2),
        ),
      );
  }
  if (state is FakeBetsAdded) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(Strings.tipSubmitted),
          backgroundColor: AppColors.greenColor,
          duration: Duration(seconds: 2),
        ),
      );
  }
  if (state is FakeBetsErrorAdding) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(Strings.errorSubmittingTip),
          backgroundColor: AppColors.redColor,
          duration: Duration(seconds: 2),
        ),
      );
  }
}