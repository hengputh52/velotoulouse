import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

class AuthFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isObscure;
  final VoidCallback? onObscureToggle;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;

  const AuthFormField({
    super.key,
    required this.label,
    required this.controller,
    this.isObscure = false,
    this.onObscureToggle,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: AppColors.secondary,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacings.radius),
          borderSide: BorderSide(color: AppColors.secondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacings.radius),
          borderSide: BorderSide(color: AppColors.secondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacings.radius),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: EdgeInsets.all(AppSpacings.m),
        suffixIcon: onObscureToggle != null
            ? GestureDetector(
                onTap: onObscureToggle,
                child: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.secondary,
                ),
              )
            : null,
      ),
    );
  }
}
