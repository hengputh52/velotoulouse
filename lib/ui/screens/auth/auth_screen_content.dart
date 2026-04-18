import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/ui/screens/auth/auth_view_model.dart';
import 'package:velotoulouse/ui/screens/auth/widgets/auth_form_field.dart';
import 'package:velotoulouse/ui/states/view_state.dart';
import 'package:velotoulouse/ui/theme/theme.dart';
import 'package:velotoulouse/ui/widgets/app_error_banner.dart';
import 'package:velotoulouse/ui/widgets/app_primary_button.dart';

class AuthScreenContent extends StatelessWidget {
  const AuthScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSpacings.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppSpacings.xxl),
                // Logo/Header
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.two_wheeler,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                SizedBox(height: AppSpacings.xl),
                Consumer<AuthViewModel>(
                  builder: (context, vm, _) {
                    return Text(
                      vm.isLoginMode ? 'Welcome Back' : 'Create Account',
                      style: AppTextStyles.heading,
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                SizedBox(height: AppSpacings.m),
                Consumer<AuthViewModel>(
                  builder: (context, vm, _) {
                    return Text(
                      vm.isLoginMode
                          ? 'Sign in to continue'
                          : 'Register to get started',
                      style: AppTextStyles.title,
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                SizedBox(height: AppSpacings.xl),
                // Error Banner
                Consumer<AuthViewModel>(
                  builder: (context, vm, _) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: vm.errorMessage != null ? 120 : 0,
                      child: vm.errorMessage != null
                          ? AppErrorBanner(
                              message: vm.errorMessage!,
                            )
                          : const SizedBox.shrink(),
                    );
                  },
                ),
                SizedBox(height: AppSpacings.m),
                // Form Fields with AnimatedSwitcher
                Consumer<AuthViewModel>(
                  builder: (context, vm, _) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: vm.isLoginMode
                          ? _buildLoginForm(context, vm)
                          : _buildRegisterForm(context, vm),
                    );
                  },
                ),
                SizedBox(height: AppSpacings.l),
                // Submit Button
                Consumer<AuthViewModel>(
                  builder: (context, vm, _) {
                    return AppPrimaryButton(
                      label: vm.isLoginMode ? 'Sign In' : 'Create Account',
                      isLoading: vm.state == ViewState.loading,
                      onPressed: () => vm.submit(),
                    );
                  },
                ),
                SizedBox(height: AppSpacings.m),
                // Mode Toggle
                Consumer<AuthViewModel>(
                  builder: (context, vm, _) {
                    return TextButton(
                      onPressed: () => vm.toggleMode(),
                      child: Text(
                        vm.isLoginMode
                            ? "Don't have an account? Register"
                            : 'Back to login',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: AppSpacings.m),
                // Forgot Password (login mode only)
                Consumer<AuthViewModel>(
                  builder: (context, vm, _) {
                    return vm.isLoginMode
                        ? TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Password reset not yet implemented'),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthViewModel vm) {
    return Column(
      key: const ValueKey('login'),
      children: [
        AuthFormField(
          label: 'Email',
          controller: vm.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: AppSpacings.m),
        AuthFormField(
          label: 'Password',
          controller: vm.passwordController,
          isObscure: vm.obscurePassword,
          onObscureToggle: () => vm.toggleObscure(),
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildRegisterForm(BuildContext context, AuthViewModel vm) {
    return Column(
      key: const ValueKey('register'),
      children: [
        AuthFormField(
          label: 'Display Name',
          controller: vm.nameController,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: AppSpacings.m),
        AuthFormField(
          label: 'Email',
          controller: vm.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: AppSpacings.m),
        AuthFormField(
          label: 'Password',
          controller: vm.passwordController,
          isObscure: vm.obscurePassword,
          onObscureToggle: () => vm.toggleObscure(),
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
