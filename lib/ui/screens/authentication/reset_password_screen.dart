import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../commons/errors_strings.dart';
import '../../../commons/extensions.dart';
import '../../../commons/strings.dart';
import '../../../commons/values.dart';
import '../../../features/authentication/blocs/password_reset_cubit/password_reset_cubit.dart';
import '../../widgets/app_info_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/outlined_text_form_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  final TextEditingController emailController;

  const ResetPasswordScreen({super.key, required this.emailController});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_ForgotPasswordFormState');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<PasswordResetCubit, PasswordResetState>(
          builder: (context, state) {
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
                          Text(
                            Strings.forgotPasswordMsg,
                            style: context.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          Gap(DefaultValues.padding * 2),
                          OutlinedTextFormField(
                            controller: widget.emailController,
                            labelText: Strings.email,
                            hintText: Strings.emailHint,
                            textInputAction: TextInputAction.done,
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
                          FilledButton(
                            style: FilledButton.styleFrom(
                              minimumSize: Size.fromHeight(DefaultValues.height50),
                              textStyle: context.textTheme.bodyLarge,
                            ),
                            onPressed: _canSendEmail(state) ? () => _validateAndSubmit() : null,
                            child: Text(state is PasswordResetSent
                                ? Strings.retryIn.replaceAll('##', '${state.retryIn}')
                                : Strings.sendResetEmail),
                          ),
                          Gap(DefaultValues.padding),
                          if (state is PasswordResetSent)
                            Text(
                              Strings.emailSent,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.colorScheme.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          if (state is PasswordResetSending) const LoadingWidget(),
                          if (state is PasswordResetError)
                            Text(
                              Strings.emailNotSent,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.colorScheme.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  bool _canSendEmail(PasswordResetState state) {
    if (state is PasswordResetSending || state is PasswordResetSent) {
      return false;
    }
    return true;
  }

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<PasswordResetCubit>().verifyUserEmail(widget.emailController.text);
    }
  }
}
