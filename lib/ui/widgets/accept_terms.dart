import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../commons/constants.dart';
import '../../commons/strings.dart';
import '../../commons/extensions.dart';
import '../../commons/utils.dart';

class AcceptTerms extends StatelessWidget {
  const AcceptTerms({super.key});

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.bodyLarge;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: context.textTheme.bodyLarge,
        children: [
          const TextSpan(text: Strings.accept1),
          TextSpan(
            text: Strings.terms,
            style: style?.copyWith(color: context.colorScheme.primary),
            recognizer: TapGestureRecognizer()
              ..onTap = () async => await openLink(Constants.termsUrl),
          ),
          const TextSpan(text: Strings.accept2),
          TextSpan(
            text: Strings.privacy,
            style: style?.copyWith(color: context.colorScheme.primary),
            recognizer: TapGestureRecognizer()
              ..onTap = () async => await openLink(Constants.privacyUrl),
          ),
        ],
      ),
    );
  }
}
