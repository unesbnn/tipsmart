import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../commons/errors_strings.dart';
import '../../../commons/extensions.dart';
import '../../../commons/strings.dart';
import '../../../commons/tip_smart_icons.dart';
import '../../../commons/values.dart';
import '../../widgets/app_info_widget.dart';
import '../../widgets/outlined_text_form_field.dart';
import 'reset_password_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onSignIn,
    required this.onSignInWithGoogle,
    required this.onRegister,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function()? onSignIn;
  final Function()? onSignInWithGoogle;
  final Function() onRegister;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_SignInFormState');
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
                      onPressed: () =>
                          setState(() => _hidePassword = !_hidePassword),
                      icon: Icon(
                        _hidePassword
                            ? TipSmartIcons.visibility
                            : TipSmartIcons.visibilityOff,
                      ),
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
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.fromHeight(DefaultValues.height50),
                      textStyle: context.textTheme.bodyLarge,
                    ),
                    onPressed: () => context.goTo(
                      ResetPasswordScreen(
                          emailController: widget.emailController),
                      false,
                    ),
                    child: const Text(Strings.forgotPassword),
                  ),
                  Gap(DefaultValues.padding / 2),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: Size.fromHeight(DefaultValues.height50),
                      textStyle: context.textTheme.bodyLarge,
                    ),
                    onPressed: _validateAndSubmit,
                    child: const Text(Strings.signIn),
                  ),
                  Gap(DefaultValues.padding / 2),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: Size.fromHeight(DefaultValues.height50),
                      textStyle: context.textTheme.bodyLarge,
                    ),
                    onPressed: widget.onSignInWithGoogle,
                    icon: const Icon(TipSmartIcons.google),
                    label: const Text(
                      Strings.signInWithGoogle,
                    ),
                  ),
                  Gap(DefaultValues.padding / 2),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(DefaultValues.height50),
                      textStyle: context.textTheme.bodyLarge,
                    ),
                    onPressed: widget.onRegister,
                    child: const Text(Strings.register),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndSubmit() {
    if (widget.onSignIn == null) return;
    if (_formKey.currentState!.validate()) {
      widget.onSignIn!();
    }
  }
}
