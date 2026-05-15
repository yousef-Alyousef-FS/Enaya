import 'package:flutter/material.dart';

/// Reusable styled text field for auth forms.
class AuthTextField extends StatefulWidget {
  /// Visible field label.
  final String labelText;

  /// Placeholder shown when input is empty.
  final String hintText;

  /// Text editing controller owned by parent form.
  final TextEditingController controller;

  /// Enables password-obscuring behavior.
  final bool isPassword;

  /// Optional field-level validator.
  final String? Function(String?)? validator;

  /// Keyboard type for platform input optimization.
  final TextInputType keyboardType;

  /// Leading icon shown in input decoration.
  final IconData prefixIcon;

  /// Optional semantic label for accessibility extensions.
  final String? semanticLabel;

  const AuthTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    required this.prefixIcon,
    this.semanticLabel,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      style: theme.textTheme.bodyLarge,

      autofillHints: widget.isPassword
          ? const [AutofillHints.password]
          : widget.keyboardType == TextInputType.emailAddress
          ? const [AutofillHints.email]
          : widget.keyboardType == TextInputType.phone
          ? const [AutofillHints.telephoneNumber]
          : null,

      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,

        prefixIcon: Icon(widget.prefixIcon),

        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: theme.iconTheme.color?.withValues(alpha: 0.6),
                ),
                onPressed: () {
                  setState(() => _obscureText = !_obscureText);
                },
                tooltip: _obscureText ? 'Show password' : 'Hide password',
              )
            : null,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );

    // End auth text-field rendering.
  }
}
