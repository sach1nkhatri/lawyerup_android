import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/service_locater/service_locator.dart';
import '../../../../app/shared/widgets/global_snackbar.dart';
import '../bloc/login_cubit.dart';
import '../bloc/login_state.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: const _LoginBody(),
    );
  }
}

class _LoginBody extends StatefulWidget {
  const _LoginBody({super.key});

  @override
  State<_LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<_LoginBody> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    context.read<LoginCubit>().login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          GlobalSnackBar.show(
            context,
            'Login successful! Welcome back.',
            type: SnackType.success,
          );
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else if (state is LoginError) {
          // Detect specific error types (optional)
          final message = state.message.toLowerCase();
          if (message.contains('user not found')) {
            GlobalSnackBar.show(
              context,
              'No account exists with that email.',
              type: SnackType.error,
            );
          } else if (message.contains('password')) {
            GlobalSnackBar.show(
              context,
              'Incorrect password. Please try again.',
              type: SnackType.error,
            );
          } else {
            GlobalSnackBar.show(
              context,
              state.message,
              type: SnackType.error,
            );
          }
        }
      },
      builder: (context, state) {
        return LoginForm(
          emailController: _emailController,
          passwordController: _passwordController,
          onLogin: _handleLogin,
          isLoading: state is LoginLoading,
        );
      },
    );
  }
}