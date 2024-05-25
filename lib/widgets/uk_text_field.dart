import 'package:flutter/material.dart';

class UkTextField extends StatelessWidget {
  final String? hintText, labelText, errorMsg;
  final bool obsecureText;
  final Widget? prefixIcon, suffixIcon;
  final VoidCallback? onTap;

  final String? initialValue;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final TextInputType keyBordType;
  const UkTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.initialValue,
    this.onSaved,
    this.validator,
    this.keyBordType = TextInputType.text,
    this.errorMsg,
    this.obsecureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.9,
      child: TextFormField(
        initialValue: initialValue,
        obscureText: obsecureText,
        onTap: onTap,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Colors.grey[700]),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          errorText: errorMsg,
          fillColor: Colors.grey.shade200,
          filled: true,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          labelText: labelText,
          hintText: hintText,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.grey[500]),
          border: InputBorder.none,
          focusedBorder: _fieldBorder(context),
          enabledBorder: _fieldBorder(context),
          disabledBorder: _fieldBorder(context),
          focusedErrorBorder: _fieldBorder(context, Colors.red),
          errorBorder: _fieldBorder(context, Colors.red),
        ),
        onSaved: onSaved,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  OutlineInputBorder _fieldBorder(BuildContext context, [Color? borderColor]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
          color: borderColor ?? Theme.of(context).colorScheme.primary),
    );
  }
}
