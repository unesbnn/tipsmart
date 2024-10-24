import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../commons/constants.dart';
import '../../commons/extensions.dart';
import '../../commons/strings.dart';
import '../../commons/values.dart';
import '../../features/tips/models/bet.dart';
import 'date_button.dart';

class TipsFilter extends StatefulWidget {
  const TipsFilter({
    super.key,
    required this.onSubmit,
    required this.selectedStatus,
    required this.selectedDate,
    required this.selectedBet,
    required this.onReset,
  });

  final DateTime selectedDate;
  final Bet selectedBet;
  final List<String> selectedStatus;
  final Function(DateTime date, Bet bet, List<String> status) onSubmit;
  final Function() onReset;

  @override
  State<TipsFilter> createState() => _TipsFilterState();
}

class _TipsFilterState extends State<TipsFilter> {
  late DateTime _date;
  late Bet _bet;
  late final List<String> _status;

  @override
  void initState() {
    super.initState();
    _date = DateTime.now();
    _date = widget.selectedDate;
    _bet = widget.selectedBet;
    _status = widget.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: DefaultValues.padding,
        horizontal: DefaultValues.padding / 2,
      ),
      child: Column(
        children: [
          Text(
            Strings.selectDate.toUpperCase(),
            style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Gap(DefaultValues.spacing / 2),
          _dateButtons(context),
          Gap(DefaultValues.spacing),
          Text(
            Strings.selectBetType.toUpperCase(),
            style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Gap(DefaultValues.spacing / 2),
          _betTypes(),
          Gap(DefaultValues.spacing),
          Text(
            Strings.selectTipStatus.toUpperCase(),
            style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Gap(DefaultValues.spacing / 2),
          _tipStatus(),
          Gap(DefaultValues.spacing / 2),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colorScheme.error,
                    foregroundColor: context.colorScheme.onError,
                  ),
                  onPressed: widget.onReset,
                  child: const Text(Strings.resetFilter),
                ),
              ),
              Gap(DefaultValues.spacing / 4),
              Expanded(
                child: FilledButton(
                  onPressed: () => widget.onSubmit(_date, _bet, _status),
                  child: const Text(Strings.applyFilter),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  bool _isOtherDate() => !(_date.isToday || _date.isYesterday || _date.isTomorrow);

  Widget _dateButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DateButton(
            title: Strings.selectDate,
            date: _date,
            selected: _isOtherDate(),
            onSelected: (_) async {
              final DateTime? date = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2024, 8, 14),
                lastDate: DateTime.now().add(const Duration(days: 2)),
              );

              if (date != null) {
                setState(() => _date = date);
              }
            },
          ),
        ),
        Gap(DefaultValues.spacing / 4),
        Expanded(
          child: DateButton(
            title: Strings.yesterday,
            date: DateTime.now().subtract(const Duration(days: 1)),
            selected: DateTime.now().subtract(const Duration(days: 1)).isSameDay(_date),
            onSelected: (_) {
              setState(() => _date = DateTime.now().subtract(const Duration(days: 1)));
            },
          ),
        ),
        Gap(DefaultValues.spacing / 4),
        Expanded(
          child: DateButton(
            title: Strings.today,
            date: DateTime.now(),
            selected: DateTime.now().isSameDay(_date),
            onSelected: (_) => setState(() => _date = DateTime.now()),
          ),
        ),
        Gap(DefaultValues.spacing / 4),
        Expanded(
          child: DateButton(
            title: Strings.tomorrow,
            date: DateTime.now().add(const Duration(days: 1)),
            selected: DateTime.now().add(const Duration(days: 1)).isSameDay(_date),
            onSelected: (_) => setState(() => _date = DateTime.now().add(const Duration(days: 1))),
          ),
        ),
      ],
    );
  }

  Widget _betTypes() {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: DefaultValues.spacing / 4,
        runSpacing: DefaultValues.spacing / 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: List<Widget>.generate(Constants.supportedBets.length, (index) {
          return LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              width: (constraints.maxWidth - DefaultValues.spacing / 2) / 2,
              child: FilterChip(
                selected: _bet.id == Constants.supportedBets[index].id,
                showCheckmark: false,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onSelected: (_) => setState(() => _bet = Constants.supportedBets[index]),
                label: SizedBox(
                  width: double.infinity,
                  child: Text(
                    Constants.supportedBets[index].name,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          });
        }),
      ),
    );
  }

  Widget _tipStatus() {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: DefaultValues.spacing / 4,
        runSpacing: DefaultValues.spacing / 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          FilterChip(
            selected: _status.length >= 4,
            showCheckmark: false,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onSelected: (_) {
              _status.clear();
              setState(() {
                _status.addAll(TipStatus.values.map((v) => v.status));
              });
            },
            label: const Text(
              Strings.all,
              textAlign: TextAlign.center,
            ),
          ),
          ...List<Widget>.generate(TipStatus.values.length, (index) {
            return FilterChip(
              selected: _status.contains(TipStatus.values[index].status),
              showCheckmark: false,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _status.add(TipStatus.values[index].status);
                  } else if (_status.length > 1) {
                    _status.remove(TipStatus.values[index].status);
                  }
                });
              },
              label: Text(
                TipStatus.values[index].status,
                textAlign: TextAlign.center,
              ),
            );
          }),
        ],
      ),
    );
  }
}
