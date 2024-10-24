import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../commons/errors_strings.dart';
import '../../../commons/extensions.dart';
import '../../../commons/strings.dart';
import '../../../commons/values.dart';
import '../../widgets/accept_terms.dart';
import '../../widgets/app_info_widget.dart';
import '../../widgets/outlined_text_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.onSignUp,
    required this.onSignIn,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function()? onSignUp;
  final Function() onSignIn;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_SignUpFormState');
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: .5.sh,
              padding: EdgeInsets.all(DefaultValues.padding),
              child: const AppInfoWidget(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(DefaultValues.padding),
              // color: context.colorScheme.surface,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedTextFormField(
                    controller: widget.nameController,
                    labelText: Strings.userNameOp,
                    hintText: Strings.nameHint,
                    textInputAction: TextInputAction.next,
                  ),
                  Gap(DefaultValues.padding / 2),
                  OutlinedTextFormField(
                    controller: widget.emailController,
                    labelText: Strings.email,
                    hintText: Strings.emailHint,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) {
                      if (email?.isEmpty ?? true) {
                        return ErrorsStrings.kEmptyEmail;
                      }
                      if (!EmailValidator.validate(email ?? '')) {
                        return ErrorsStrings.kInvalidEmail;
                      }
                      return null;
                    },
                  ),
                  Gap(DefaultValues.padding / 2),
                  OutlinedTextFormField(
                    controller: widget.passwordController,
                    labelText: Strings.password,
                    hintText: Strings.passwordHint,
                    obscureText: _hidePassword,
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _hidePassword = !_hidePassword),
                      icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                    ),
                    onFieldSubmitted: (_) => _validateAndSubmit(),
                    validator: (password) {
                      if (password?.isEmpty ?? true) {
                        return ErrorsStrings.kEmptyPassword;
                      }
                      if ((password ?? '').length < 8) {
                        return ErrorsStrings.kInvalidPassword;
                      }
                      return null;
                    },
                  ),
                  Gap(DefaultValues.padding / 2),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: Size.fromHeight(DefaultValues.height50),
                      textStyle: context.textTheme.bodyLarge,
                    ),
                    onPressed: _validateAndSubmit,
                    child: const Text(Strings.signUp),
                  ),
                  Gap(DefaultValues.padding / 2),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(DefaultValues.height50),
                      textStyle: context.textTheme.bodyLarge,
                    ),
                    onPressed: widget.onSignIn,
                    child: const Text(Strings.haveAccountSignIn),
                  ),
                  Gap(DefaultValues.padding / 2),
                  const AcceptTerms(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndSubmit() {
    if (widget.onSignUp == null) return;
    if (_formKey.currentState!.validate()) {
      widget.onSignUp!();
    }
  }
}
