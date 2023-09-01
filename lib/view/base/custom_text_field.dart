import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Color? fillColor;
  final Color? borderColor;
  final int maxLines;
  final bool isPassword;
  final bool isCountryPicker;
  final bool isShowBorder;
  final bool isIcon;
  final bool isShowSuffixIcon;
  final bool isShowPrefixIcon;
  final Function? onTap;
  final Function? onSuffixTap;
  final IconData? suffixIconUrl;
  final String? suffixAssetUrl;
  final IconData? prefixIconUrl;
  final bool isSearch;
  final Function? onSubmit;
  final bool isEnabled;
  final TextCapitalization capitalization;
  final bool isElevation;
  final bool isPadding;
  final Function? onChanged;
  //final LanguageProvider languageProvider;

  const CustomTextField(
      {Key? key, this.hintText = 'Write something...',
      this.controller,
      this.focusNode,
      this.borderColor=Colors.red,
      this.nextFocus,
      this.isEnabled = true,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.maxLines = 1,
      this.onSuffixTap,
      this.fillColor,
      this.onSubmit,
      this.capitalization = TextCapitalization.none,
      this.isCountryPicker = false,
      this.isShowBorder = false,
      this.isShowSuffixIcon = false,
      this.isShowPrefixIcon = false,
      this.onTap,
      this.isIcon = false,
      this.isPassword = false,
      this.suffixIconUrl,
      this.prefixIconUrl,
      this.isSearch = false,
      this.isElevation = true,
      this.onChanged,
      this.isPadding=true, this.suffixAssetUrl}) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context)? 20 : 12),
        boxShadow: [
          BoxShadow(
              color: widget.isElevation ? Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200]! : Colors.transparent,
              spreadRadius: 0.5,
              blurRadius: 0.5,
            // changes position of shadow
              ),
        ],
      ),
      child: TextField(
        maxLines: widget.maxLines,
        controller: widget.controller,
        focusNode: widget.focusNode,
        style:
            Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge),
        textInputAction: widget.inputAction,
        keyboardType: widget.inputType,
        cursorColor: Theme.of(context).primaryColor,
        textCapitalization: widget.capitalization,
        enabled: widget.isEnabled,
        autofocus: false,
        //onChanged: widget.isSearch ? widget.languageProvider.searchLanguage : null,
        obscureText: widget.isPassword ? _obscureText : false,
        inputFormatters: widget.inputType == TextInputType.phone ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9+]'))] : null,
        decoration: InputDecoration(

          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: widget.isPadding?22:0),
          border: !widget.isShowBorder ? InputBorder.none : OutlineInputBorder(
            borderRadius: ResponsiveHelper.isDesktop(context) ? BorderRadius.circular(5.0) : BorderRadius.circular(7.0),

            borderSide: BorderSide(/*style: BorderStyle.none,*/ width:  ResponsiveHelper.isDesktop(context) ? 3 : 1 ,color:widget.borderColor!   /*Theme.of(context).hintColor.withOpacity(0.6)*/),
          ),
          isDense: true,
          hintText: widget.hintText,
          fillColor: widget.fillColor ?? Theme.of(context).cardColor,
          hintStyle: joseFinSansLight.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor.withOpacity(0.6)),
          filled: true,
          prefixIcon: widget.isShowPrefixIcon
              ? IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: Icon(
                    widget.prefixIconUrl,
                    color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
                  ),
                  onPressed: () {},
                )
              : const SizedBox.shrink(),
          prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
          suffixIcon: widget.isShowSuffixIcon
              ? widget.isPassword
                  ? IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).hintColor.withOpacity(0.3)),
                      onPressed: _toggle)
                  : widget.isIcon
                      ? IconButton(
                          onPressed: widget.onSuffixTap as void Function()?,
                          icon: ResponsiveHelper.isDesktop(context)? Image.asset(
                            widget.suffixAssetUrl!,
                            width: 15,
                            height: 15,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ) : Icon(widget.suffixIconUrl, color: Theme.of(context).hintColor.withOpacity(0.6)),
                        )
                      : null
              : null,
        ),
        onTap: widget.onTap as void Function()?,
        onChanged: widget.onChanged as void Function(String)?,
        onSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus)
            : widget.onSubmit != null ? widget.onSubmit!(text) : null,
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}