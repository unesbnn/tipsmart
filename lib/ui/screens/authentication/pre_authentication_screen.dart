import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../commons/extensions.dart';
import '../../../commons/strings.dart';
import '../../../commons/tip_smart_icons.dart';
import '../../../commons/values.dart';
import '../../widgets/app_info_widget.dart';

class PreAuthenticationScreen extends StatelessWidget {
  const PreAuthenticationScreen({
    super.key,
    required this.onSignIn,
    required this.onRegister,
    this.onSignInWithGoogle,
    this.onSignInWithAnonymously,
  });

  final Function() onSignIn;
  final Function()? onSignInWithGoogle;
  final Function() onRegister;
  final Function()? onSignInWithAnonymously;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: .5.sh,
          padding: EdgeInsets.all(DefaultValues.padding),
          child: const AppInfoWidget(),
        ),
        Container(
          padding: EdgeInsets.all(DefaultValues.padding),
          // color: context.colorScheme.surface,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(DefaultValues.padding / 2),
              FilledButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(DefaultValues.height50),
                  textStyle: context.textTheme.bodyLarge,
                ),
                onPressed: onSignIn,
                child: const Text(Strings.signIn),
              ),
              Gap(DefaultValues.padding / 2),
              FilledButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(DefaultValues.height50),
                  textStyle: context.textTheme.bodyLarge,
                ),
                onPressed: onRegister,
                child: const Text(Strings.createAccount),
              ),
              Gap(DefaultValues.padding / 2),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(DefaultValues.height50),
                  textStyle: context.textTheme.bodyLarge,
                ),
                onPressed: onSignInWithGoogle,
                icon: const Icon(TipSmartIcons.google),
                label: const Text(Strings.signInWithGoogle),
              ),
              Gap(DefaultValues.padding / 2),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(DefaultValues.height50),
                  textStyle: context.textTheme.bodyLarge,
                ),
                onPressed: onSignInWithAnonymously,
                child: const Text(Strings.continueAnonymous),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
