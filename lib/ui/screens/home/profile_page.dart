import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../commons/assets.dart';
import '../../../commons/constants.dart';
import '../../../commons/extensions.dart';
import '../../../commons/strings.dart';
import '../../../commons/tip_smart_icons.dart';
import '../../../commons/utils.dart';
import '../../../commons/values.dart';
import '../../../features/authentication/blocs/authentication_bloc/authentication_bloc.dart';
import '../../../features/authentication/blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../widgets/change_theme_dialog.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/custom_list_tile.dart';
import '../balance_history_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _name;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        _setName(state);
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(DefaultValues.padding / 2),
              child: Column(
                children: [
                  Container(
                    width: 80.h,
                    height: 80.h,
                    clipBehavior: Clip.hardEdge,
                    decoration: ShapeDecoration(
                      shape: CircleBorder(
                        side: BorderSide(
                          color: context.colorScheme.secondaryContainer,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                    ),
                    child: CustomNetworkImage(
                      imageUrl: state.user.photoURL,
                      placeholder: Assets.userPlaceholder,
                    ),
                  ),
                  Gap(DefaultValues.spacing / 2),
                  Text(
                    _name.toUpperCase(),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (state.user.email != null) ...[
                    Gap(DefaultValues.spacing / 4),
                    Text(
                      state.user.email!,
                      style: context.textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            Divider(
                color: context.colorScheme.primary,
                height: DefaultValues.spacing / 2),
            Expanded(
              child: ListView(
                padding:
                    EdgeInsets.symmetric(vertical: DefaultValues.padding / 2),
                children: [
                  CustomListTile(
                    onTap: () => context.goTo(const BalanceHistoryScreen()),
                    title: Strings.balanceHistory,
                    leading: TipSmartIcons.balanceHistory,
                  ),
                  //Theme
                  CustomListTile(
                    onTap: () async => showDialog(
                      context: context,
                      builder: (context) {
                        return const ChangeThemeDialog();
                      },
                    ),
                    title: Strings.theme,
                    subtitle: AdaptiveTheme.of(context).mode.modeName,
                    leading: TipSmartIcons.theme,
                  ),
                  //Rate us
                  CustomListTile(
                    onTap: () async => await rateApp(),
                    title: Strings.rateUs,
                    leading: TipSmartIcons.rate,
                  ),
                  //Share
                  CustomListTile(
                    onTap: () async => await shareApp(),
                    title: Strings.share,
                    leading: TipSmartIcons.share,
                  ),
                  //Privacy
                  CustomListTile(
                    onTap: () async => await openLink(Constants.privacyUrl),
                    title: Strings.privacy,
                    leading: TipSmartIcons.privacy,
                  ),
                  //Privacy
                  CustomListTile(
                    onTap: () async => await openLink(Constants.termsUrl),
                    title: Strings.terms,
                    leading: TipSmartIcons.terms,
                  ),
                ],
              ),
            ),
            Gap(DefaultValues.spacing / 2),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: DefaultValues.padding / 2),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return BlocConsumer<SignInBloc, SignInState>(
                              listener: (context, state) {
                                if (state is SignInSuccess) {
                                  Navigator.maybePop(context);
                                }
                              },
                              builder: (context, state) {
                                return AlertDialog(
                                  titleTextStyle: context.textTheme.titleLarge,
                                  actionsAlignment: MainAxisAlignment.center,
                                  title: Text(
                                    Strings.deleteAccount,
                                    textAlign: TextAlign.center,
                                    style:
                                        context.textTheme.titleLarge?.copyWith(
                                      color: context.colorScheme.error,
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        Strings.deleteAccountWarning,
                                        textAlign: TextAlign.center,
                                      ),
                                      Gap(DefaultValues.spacing / 2),
                                      if (state is SignInError)
                                        Text(state.message),
                                      if (state is SignInLoading)
                                        const LinearProgressIndicator(),
                                    ],
                                  ),
                                  actions: [
                                    FilledButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(Strings.no),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          context.read<SignInBloc>().add(
                                                const DeleteAccountEvent(),
                                              ),
                                      style: FilledButton.styleFrom(
                                        backgroundColor:
                                            context.colorScheme.error,
                                        foregroundColor:
                                            context.colorScheme.onError,
                                      ),
                                      child: const Text(Strings.yes),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: context.colorScheme.error,
                      ),
                      child: const Text(Strings.deleteAccount),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () =>
                          context.read<SignInBloc>().add(const SignOutEvent()),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colorScheme.error,
                        side: BorderSide(color: context.colorScheme.error),
                      ),
                      child: const Text(Strings.logout),
                    ),
                  ),
                ],
              ),
            ),
            Gap(DefaultValues.spacing / 2),
          ],
        );
      },
    );
  }

  void _setName(AuthenticationState state) {
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      _name = Strings.anonymous;
    } else {
      _name = FirebaseAuth.instance.currentUser!.displayName ??
          state.user.name ??
          '';
    }
  }
}
