import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInput extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final TextEditingController controller;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final IconData? icon;
  final bool? passwordVisibility;
  final TextInputType? textInputType;
  final bool? obscureText;
  final TextCapitalization? textCapitalization;
  final bool? enabledInputInteraction;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? fontColor;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool? expands;
  final double? width;
  final double? marginBottom;
  final double marginLeft;
  final double marginRight;
  final double marginTop;
  final double contentPadding;
  final bool isNumeric;
  final bool autoUppercase;
  final bool isRequired;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final List<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;

  const CustomInput({
    super.key,
    required this.hintText,
    this.labelText,
    required this.controller,
    this.onSaved,
    this.validator,
    this.icon,
    this.passwordVisibility = false,
    this.textInputType = TextInputType.text,
    this.obscureText = false,
    this.enabledInputInteraction = true,
    this.textCapitalization = TextCapitalization.none,
    this.borderRadius = 8,
    this.backgroundColor,
    this.borderColor,
    this.fontColor,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.expands = false,
    this.width,
    this.marginBottom = 8,
    this.marginTop = 4,
    this.marginLeft = 4,
    this.marginRight = 4,
    this.contentPadding = 14,
    this.isNumeric = false,
    this.isRequired = true,
    this.autoUppercase = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.autofillHints,
    this.inputFormatters,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool passwordObscure = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color getBackgroundColor() {
      if (!widget.enabledInputInteraction!) {
        return colorScheme.surfaceContainerHighest;
      } else {
        return widget.backgroundColor ?? colorScheme.surface;
      }
    }

    Color getBorderColor() => widget.borderColor ?? colorScheme.primary;

    Color getFontColor() {
      if (!widget.enabledInputInteraction!) {
        return colorScheme.onSurface.withValues(alpha: 0.6);
      } else {
        return widget.fontColor ?? colorScheme.onSurface;
      }
    }

    Color getIconColor() {
      if (!widget.enabledInputInteraction!) {
        return colorScheme.onSurface;
      } else {
        return widget.borderColor ?? colorScheme.primary;
      }
    }

    OutlineInputBorder getBorder({
      required Color borderColor,
      required double borderWidth,
    }) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius!),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );

    return Container(
      width: widget.width,
      margin: EdgeInsets.only(
        left: widget.marginLeft,
        top: widget.marginTop,
        right: widget.marginRight,
        bottom: widget.marginBottom!,
      ),
      decoration: BoxDecoration(
        color: getBackgroundColor(),
        borderRadius: BorderRadius.circular(widget.borderRadius!),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        autofillHints: widget.autofillHints,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        validator: widget.validator,
        minLines: widget.minLines!,
        maxLines: widget.maxLines!,
        maxLength: widget.maxLength,
        expands: widget.expands!,
        style:
            textTheme.bodyMedium?.copyWith(
              color: getFontColor(),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ) ??
            GoogleFonts.inter(
              color: getFontColor(),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
        autocorrect: false,
        keyboardType: widget.textInputType,
        obscureText: (widget.obscureText! && passwordObscure),
        enabled: widget.enabledInputInteraction,
        textCapitalization: widget.textCapitalization!,
        inputFormatters: [
          if (widget.isNumeric) FilteringTextInputFormatter.digitsOnly,
          if (widget.autoUppercase &&
              !widget.isNumeric &&
              !widget.obscureText! &&
              widget.textInputType != TextInputType.emailAddress)
            TextInputFormatter.withFunction(
              (oldValue, newValue) => TextEditingValue(
                text: newValue.text.toUpperCase(),
                selection: newValue.selection,
              ),
            ),
          ...?widget.inputFormatters,
        ],
        decoration: InputDecoration(
          errorStyle: textTheme.bodySmall?.copyWith(
            fontSize: 9.5,
            color: colorScheme.error,
          ),
          isCollapsed: true,
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, color: getIconColor(), size: 20)
              : null,
          suffixIcon: widget.passwordVisibility!
              ? IconButton(
                  color: getIconColor(),
                  iconSize: 20,
                  icon: Icon(
                    passwordObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() {
                    passwordObscure = !passwordObscure;
                  }),
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            vertical: widget.contentPadding,
            horizontal: 8,
          ),
          focusedBorder: getBorder(
            borderColor: getBorderColor().withValues(alpha: 0.8),
            borderWidth: 1.5,
          ),
          border: getBorder(
            borderColor: getBorderColor().withValues(alpha: 0.4),
            borderWidth: 1.0,
          ),
          enabledBorder: getBorder(
            borderColor: getBorderColor().withValues(alpha: 0.4),
            borderWidth: 1.0,
          ),
          errorBorder: getBorder(
            borderColor: colorScheme.error,
            borderWidth: 1.2,
          ),
          focusedErrorBorder: getBorder(
            borderColor: colorScheme.error,
            borderWidth: 1.5,
          ),
          labelText:
              widget.labelText ??
              (widget.isRequired ? '${widget.hintText} *' : widget.hintText),
          labelStyle: textTheme.bodySmall?.copyWith(
            color: getFontColor().withValues(alpha: 0.6),
          ),
          floatingLabelStyle: TextStyle(color: getBorderColor()),
          hintText: widget.hintText,
          hintStyle: textTheme.bodySmall?.copyWith(
            color: getFontColor().withValues(alpha: 0.4),
          ),
          counterText: '',
          fillColor: getBackgroundColor(),
          filled: true,
        ),
      ),
    );
  }
}
