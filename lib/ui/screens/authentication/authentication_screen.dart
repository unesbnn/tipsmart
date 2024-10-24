import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../commons/extensions.dart';
import '../../../features/authentication/blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../widgets/loading_widget.dart';
import 'login_page.dart';
import 'pre_authentication_screen.dart';
import 'register_page.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  late final PageController _pageController;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = 0;
    _pageController = PageController(initialPage: _index);
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    FirebaseAnalytics.instance.logScreenView(screenName: 'AuthenticationScreen');
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocConsumer<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is SignInError) {
              Fluttertoast.showToast(
                msg: state.message,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: context.colorScheme.errorContainer,
                textColor: context.colorScheme.onErrorContainer,
                fontSize: 16.0,
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _index = index),
                  children: [
                    PreAuthenticationScreen(
                      onSignIn: () => _pageController.jumpToPage(1),
                      onSignInWithGoogle: (state is SignInLoading)
                          ? null
                          : () => context.read<SignInBloc>().add(const SignInWithGoogleEvent()),
                      onRegister: () => _pageController.jumpToPage(2),
                      onSignInWithAnonymously: (state is SignInLoading)
                          ? null
                          : () => context.read<SignInBloc>().add(const SignInAnonymouslyEvent()),
                    ),
                    LoginPage(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      onSignIn: (state is SignInLoading)
                          ? null
                          : () => context.read<SignInBloc>().add(
                                SignInWithEmailAndPasswordEvent(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ),
                              ),
                      onSignInWithGoogle: (state is SignInLoading)
                          ? null
                          : () => context.read<SignInBloc>().add(const SignInWithGoogleEvent()),
                      onRegister: () {
                        _pageController.animateToPage(
                          2,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.bounceIn,
                        );
                      },
                    ),
                    RegisterPage(
                      nameController: _nameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      onSignUp: (state is SignInLoading)
                          ? null
                          : () => context.read<SignInBloc>().add(
                                    SignUpWithEmailAndPasswordEvent(
                                      name: _nameController.text.isNotEmpty
                                          ? _nameController.text
                                          : null,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  ),
                      onSignIn: () => _pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.bounceIn,
                        ),
                    ),
                  ],
                ),
                if (state is SignInLoading)
                  Positioned.fill(
                    child: Container(
                      color: context.colorScheme.surface.withOpacity(.5),
                      alignment: Alignment.center,
                      child: const LoadingWidget(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
