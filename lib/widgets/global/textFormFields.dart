import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../utils/styles.dart';

class TextFormFieldsWidget extends StatefulWidget {
  TextEditingController controller;
  bool enablepadding;
  bool obsecureText;
  AutovalidateMode? autoValidation;
  TextInputType textInputType;
  String hintText;
  String? intialvalue;
  String errorText;
  int maxline;
  FormFieldSetter onChange;
  FormFieldValidator validator;
  Icon? icon;
  Widget? suffixText;
  int? maxLength;

  TextFormFieldsWidget(
      {required this.errorText,
      this.intialvalue,
      required this.textInputType,
      required this.controller,
      required this.hintText,
      this.autoValidation,
      this.obsecureText: false,
      required this.onChange,
      required this.validator,
      this.enablepadding: true,
      this.maxline: 1,
      this.icon,
      this.suffixText,
      this.maxLength});

  @override
  _TextFormFieldsWidgetState createState() => _TextFormFieldsWidgetState();
}

class _TextFormFieldsWidgetState extends State<TextFormFieldsWidget> {
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: TextFormField(
        controller: widget.controller,
        autovalidateMode: widget.autoValidation,
        keyboardType: widget.textInputType,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        autofocus: false,
        maxLength: widget.maxLength,
        // focusNode: focusNode,
        maxLines: widget.maxline,
        onChanged: widget.onChange,
        decoration: InputDecoration(
          counterText: "",
          prefixIcon: widget.icon,
          suffixIcon: widget.suffixText,
          suffixIconConstraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * .3,
              minWidth: MediaQuery.of(context).size.width * .3),
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: MediaQuery.of(context).size.height * 0.020),
          hintText: widget.hintText,
          errorStyle: TextStyle(
              color: ThemeApp.innerTextFieldErrorColor,
              fontSize: MediaQuery.of(context).size.height * 0.020),
          errorMaxLines: 2,
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: ThemeApp.textFieldBorderColor,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.innerTextFieldErrorColor, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
        ),
        validator: widget.validator,
      ),
    );
  }
}

class CharacterTextFormFieldsWidget extends StatefulWidget {
  TextEditingController controller;
  bool enablepadding;
  bool obsecureText;
  AutovalidateMode? autoValidation;
  TextInputType textInputType;
  String hintText;
  String? intialvalue;
  String errorText;
  int maxline;
  FormFieldSetter onChange;
  FormFieldValidator validator;
  Icon? icon;
  Widget? suffixText;
  int? maxLength;

  CharacterTextFormFieldsWidget(
      {required this.errorText,
        this.intialvalue,
        required this.textInputType,
        required this.controller,
        required this.hintText,
        this.autoValidation,
        this.obsecureText: false,
        required this.onChange,
        required this.validator,
        this.enablepadding: true,
        this.maxline: 1,
        this.icon,
        this.suffixText,
        this.maxLength});

  @override
  _CharacterTextFormFieldsWidgetState createState() => _CharacterTextFormFieldsWidgetState();
}

class _CharacterTextFormFieldsWidgetState extends State<CharacterTextFormFieldsWidget> {
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: TextFormField(
        controller: widget.controller,
        autovalidateMode: widget.autoValidation,
        keyboardType: widget.textInputType,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        autofocus: false,
        maxLength: widget.maxLength,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))],
        // focusNode: focusNode,
        maxLines: widget.maxline,
        onChanged: widget.onChange,
        decoration: InputDecoration(
          counterText: "",
          prefixIcon: widget.icon,
          suffixIcon: widget.suffixText,
          suffixIconConstraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * .3,
              minWidth: MediaQuery.of(context).size.width * .3),
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: MediaQuery.of(context).size.height * 0.020),
          hintText: widget.hintText,
          errorStyle: TextStyle(
              color: ThemeApp.innerTextFieldErrorColor,
              fontSize: MediaQuery.of(context).size.height * 0.020),
          errorMaxLines: 2,
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: ThemeApp.textFieldBorderColor,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.innerTextFieldErrorColor, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
        ),
        validator: widget.validator,
      ),
    );
  }
}

class PasswordTextFormFieldsWidget extends StatefulWidget {
  TextEditingController controller;
  bool enablepadding;
  bool obsecureText;
  AutovalidateMode? autoValidation;
  TextInputType textInputType;
  String hintText;
  String? intialvalue;
  String errorText;
  int maxline;
  FormFieldSetter onChange;
  FormFieldValidator validator;
  Icon? icon;

  PasswordTextFormFieldsWidget(
      {required this.errorText,
      this.intialvalue,
      required this.textInputType,
      required this.controller,
      required this.hintText,
      this.autoValidation,
      this.obsecureText: false,
      required this.onChange,
      required this.validator,
      this.enablepadding: true,
      this.maxline: 1,
      this.icon});

  @override
  _PasswordTextFormFieldsWidgetState createState() =>
      _PasswordTextFormFieldsWidgetState();
}

class _PasswordTextFormFieldsWidgetState
    extends State<PasswordTextFormFieldsWidget> {
  bool _passwordVisible = true;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _passwordVisible ? false : true,
        autovalidateMode: widget.autoValidation,
        keyboardType: widget.textInputType,
        textCapitalization: TextCapitalization.words,
        autofocus: false,
        focusNode: focusNode,
        maxLines: widget.maxline,
        onChanged: widget.onChange,
        decoration: InputDecoration(
          prefixIcon: widget.icon,
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: MediaQuery.of(context).size.height * 0.020),
          hintText: widget.hintText,
          errorStyle: TextStyle(
              color: ThemeApp.innerTextFieldErrorColor,
              fontSize: MediaQuery.of(context).size.height * 0.020),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: ThemeApp.textFieldBorderColor,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.innerTextFieldErrorColor, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
          suffixIcon: IconButton(
            splashColor: Colors.white,
            highlightColor: Colors.white,
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}

class CardCVVTextFormFieldWidget extends StatefulWidget {
  TextEditingController controller;
  bool enablepadding;
  bool obsecureText;
  AutovalidateMode? autoValidation;
  TextInputType textInputType;
  String hintText;
  String? intialvalue;
  TextInputFormatter? inputFormatter;
  String errorText;
  int maxline;
  FormFieldSetter onChange;
  FormFieldValidator validator;
  Icon? icon;
  FocusNode? focusNode;

  CardCVVTextFormFieldWidget(
      {required this.errorText,
      this.intialvalue,
      required this.textInputType,
      required this.controller,
      required this.hintText,
      this.autoValidation,
      this.obsecureText: false,
      required this.onChange,
      this.inputFormatter,
      required this.validator,
      this.enablepadding: true,
      this.maxline: 1,
      this.icon,
      this.focusNode});

  @override
  State<CardCVVTextFormFieldWidget> createState() =>
      _CardCVVTextFormFieldWidgetState();
}

class _CardCVVTextFormFieldWidgetState
    extends State<CardCVVTextFormFieldWidget> {
  bool _passwordVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _passwordVisible ? false : true,
        autovalidateMode: widget.autoValidation,
        keyboardType: widget.textInputType,
        textCapitalization: TextCapitalization.words,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        autofocus: false,
        focusNode: widget.focusNode,
        maxLines: widget.maxline,
        onChanged: widget.onChange,
        decoration: InputDecoration(
          prefixIcon: widget.icon,
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: MediaQuery.of(context).size.height * 0.020),
          hintText: widget.hintText,
          errorStyle: TextStyle(
              color: ThemeApp.innerTextFieldErrorColor,
              fontSize: MediaQuery.of(context).size.height * 0.020),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: ThemeApp.textFieldBorderColor,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.innerTextFieldErrorColor, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
          suffixIcon: IconButton(
            splashColor: Colors.white,
            highlightColor: Colors.white,
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}

class MobileNumberTextFormField extends StatefulWidget {
  TextEditingController controller;
  bool enable = true;

  MobileNumberTextFormField(
      {Key? key, required this.controller, required this.enable})
      : super(key: key);

  @override
  State<MobileNumberTextFormField> createState() =>
      _MobileNumberTextFormFieldState();
}

class _MobileNumberTextFormFieldState extends State<MobileNumberTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: IntlPhoneField(
        // showCountryFlag: false,
        enabled: widget.enable,
        controller: widget.controller,
        flagsButtonPadding: EdgeInsets.only(
          left: 20,
        ),
        dropdownDecoration: const BoxDecoration(
            border: Border(
          right: BorderSide(
              //                   <--- left side
              color: ThemeApp.textFieldBorderColor,
              width: 1),
        )),
        initialCountryCode: "IN",
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        style: TextStyle(color: ThemeApp.darkGreyColor),
        decoration: InputDecoration(
          hintText: 'Do not enter country code',
          counterText: "",
          suffixIconConstraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * .3,
              minWidth: MediaQuery.of(context).size.width * .3),
          filled: true,
          prefix: const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10.0, 0),
          ),
          fillColor: Colors.white,
          hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: MediaQuery.of(context).size.height * 0.015),
          errorStyle: TextStyle(
              color: ThemeApp.innerTextFieldErrorColor,
              fontSize: MediaQuery.of(context).size.height * 0.020),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: ThemeApp.textFieldBorderColor,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.innerTextFieldErrorColor, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
        ),
        onChanged: (phone) {
          print(phone.completeNumber);
        },
        onCountryChanged: (country) {
          print('Country changed to: ' + country.name);
        },
      ),
    );
  }
}

class CardNumberTextFormFieldsWidget extends StatefulWidget {
  TextEditingController controller;
  int? maxLength;
  bool enablepadding;
  bool obsecureText;
  AutovalidateMode? autoValidation;
  TextInputType textInputType;
  String hintText;
  String? intialvalue;
  String errorText;
  int maxline;
  FormFieldSetter onChange;
  FormFieldValidator validator;
  ValueChanged<String?>? onFieldSubmit;
  Icon? icon;
  FocusNode? focusNode;

  CardNumberTextFormFieldsWidget(
      {required this.errorText,
      this.maxLength,
      this.intialvalue,
      required this.textInputType,
      required this.controller,
      required this.hintText,
      this.autoValidation,
      this.obsecureText: false,
      required this.onChange,
      required this.validator,
      this.enablepadding: true,
      this.maxline: 1,
      this.onFieldSubmit,
      this.icon,
      this.focusNode});

  @override
  _CardNumberTextFormFieldsWidgetState createState() =>
      _CardNumberTextFormFieldsWidgetState();
}

class _CardNumberTextFormFieldsWidgetState
    extends State<CardNumberTextFormFieldsWidget> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   if (widget.intialvalue != null) {
  //     setState(() {
  //       widget.controller.text = widget.intialvalue!;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: TextFormField(
        controller: widget.controller,
        maxLength: widget.maxLength,
        autovalidateMode: widget.autoValidation,
        keyboardType: widget.textInputType,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        autofocus: false,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          new CustomInputFormatter(),
        ],
        onFieldSubmitted: widget.onFieldSubmit,
        focusNode: widget.focusNode,
        maxLines: widget.maxline,
        onChanged: widget.onChange,
        decoration: InputDecoration(
          counterText: "",
          prefixIcon: widget.icon,
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: MediaQuery.of(context).size.height * 0.020),
          hintText: widget.hintText,
          errorStyle: TextStyle(
              color: ThemeApp.innerTextFieldErrorColor,
              fontSize: MediaQuery.of(context).size.height * 0.020),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: ThemeApp.textFieldBorderColor,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.innerTextFieldErrorColor, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ThemeApp.textFieldBorderColor, width: 1)),
        ),
        validator: widget.validator,
      ),
    );
  }
}

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var textLength = text.length;
    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(
            ' '); // Replace this with anything you want to put after each 4 numbers
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}

class TextFieldUtils {
  Widget lineHorizontal() {
    return Container(
      decoration: const BoxDecoration(
        color: ThemeApp.whiteColor,
        border: Border(
          top: BorderSide(
            color: ThemeApp.darkGreyTab,
            width: 0.5,
          ),
          bottom: BorderSide(color: ThemeApp.darkGreyTab, width: 0.5),
        ),
      ),
    );
  }

  Widget lineVertical() {
    return Container(
      height: 42,
      decoration: const BoxDecoration(
        color: ThemeApp.blackColor,
        border: Border(
          right: BorderSide(
            color: ThemeApp.darkGreyTab,
            width: 1,
          ),
          left: BorderSide(color: ThemeApp.darkGreyTab, width: 1),
        ),
      ),
    );
  }

  Widget appBarTextField(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * .028,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w500),
    );
  }

  Widget textFieldHeightThree(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * .03,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold),
    );
  }

  Widget textFieldHeightFour(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * .04,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold),
    );
  }

  Widget subHeadingTextFields(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * .016,
          fontWeight: FontWeight.w400,
          overflow: TextOverflow.ellipsis,
          color: Colors.grey),
    );
  }

  Widget titleTextFields(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: MediaQuery.of(context).size.height * .021,
          fontWeight: FontWeight.w500),
    );
  }

  Widget hyperLinkTextFields(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          shadows: [
            const Shadow(color: Colors.blueAccent, offset: Offset(0, -5))
          ],
          color: Colors.transparent,
          decoration: TextDecoration.underline,
          decorationColor: Colors.blueAccent,
          decorationThickness: 3,
          decorationStyle: TextDecorationStyle.solid,
          fontSize: MediaQuery.of(context).size.height * .021,
          fontWeight: FontWeight.w500),
    );
  }

  Widget usingPassTextFields(String text, Color colors, BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * .021,
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.ellipsis,
          color: colors),
    );
  }

  Widget errorTextFields(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * .021,
          color: ThemeApp.innerTextFieldErrorColor,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w500),
    );
  }

  ///Homepage
  Widget homePageheadingTextFieldLineThrough(
      String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * .025,
          color: ThemeApp.darkGreyTab,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
          decoration: TextDecoration.lineThrough,
          decorationThickness: 1.5),
    );
  }

  ///Homepage
  Widget pricesLineThrough(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * .03,
          color: ThemeApp.darkGreyTab,
          overflow: TextOverflow.ellipsis,
          decoration: TextDecoration.lineThrough,
          decorationThickness: 1.5),
    );
  }

  Widget pricesLineThroughWhite(
      String text, BuildContext context, double fontSize) {
    return Text(
      text,
      style: TextStyle(
          fontSize: fontSize,
          color: ThemeApp.whiteColor,
          overflow: TextOverflow.ellipsis,
          decoration: TextDecoration.lineThrough,
          decorationThickness: 1.5),
    );
  }

  Widget homePageheadingTextField(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.height * .025,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget homePageTitlesTextFields(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.height * .021,
        color: ThemeApp.darkGreyTab,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget homePageTitlesTextFieldsWHITE(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.height * .020,
        color: ThemeApp.whiteColor,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget homePageheadingTextFieldWHITE(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * .025,
          color: ThemeApp.whiteColor,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold),
    );
  }

  Widget subHeadingTextFieldsWhite(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.height * .02,
        fontWeight: FontWeight.w400,
        color: ThemeApp.whiteColor,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget stepperTextFields(String text, BuildContext context, Color color) {
    return Text(
      text,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * .012,
          fontWeight: FontWeight.w400,
          overflow: TextOverflow.ellipsis,
          color: color),
    );
  }

  Widget stepperHeadingTextFields(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * .016,
          fontWeight: FontWeight.w400,
          color: Colors.grey),
    );
  }

  Widget appliancesTitleTextFields(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: MediaQuery.of(context).size.height * .020,
          fontWeight: FontWeight.w400),
    );
  }

  Widget listHeadingTextField(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * .025,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold),
    );
  }

  Widget textFieldTwoFiveGrey(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * .025,
          overflow: TextOverflow.ellipsis,
          color: ThemeApp.darkGreyTab,
          fontWeight: FontWeight.bold),
    );
  }

  Widget dynamicText(String text, BuildContext context, TextStyle style) {
    return Text(
      text,
      style: style,
      maxLines: 2,textAlign: TextAlign.center,
    );
  }
}

class _DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;

    String date;
    String month;
    int year;

// Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;

    cText = cText.replaceAll("//", "/");

// Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    /// ENTERING THE DATE
    if (cLen == 1) {
      ///  User enters the first digit of the  date. The first digit
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 3) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      /// User has already entered a valid first digit of the date, now he
      /// enters the second digit of the date; but
      // Days cannot be greater than 31
      int dd = int.parse(cText.substring(0, 2));
      if (dd == 0 || dd > 31) {
        // Remove char
        cText = cText.substring(0, 1);
      } else {
        /// User has entered a valid date (between 1 and 31). So now,
        // Add a / char
        cText += '/';
      }

      /// ENTERING THE MONTH
    } else if (cLen == 4) {
      /// after entering a valid date and programmatic insertion of '/', now User has entered
      /// the first digit of the Month. But, it
      // Can only be 0 or 1
      /// (and, not  '/' either)
      if (int.parse(cText.substring(3, 4)) > 1 ||
          cText.substring(3, 4) == "/") {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      int mm = int.parse(cText.substring(3, 5));
      int dd = int.parse(cText.substring(0, 2));

      /// User has entered the second digit of the Month, but the
      // Month cannot be greater than 12
      /// Also, that entry cannot be '/'
      if ((mm == 0 || mm > 12 || cText.substring(3, 5) == "/") ||

          /// If the date is 31, the month cannot be Apr, Jun, Sept or Nov
          (dd == 31 &&
              (mm == 02 || mm == 04 || mm == 06 || mm == 09 || mm == 11)) ||

          /// If the date is greater than 29, the month cannot be Feb
          /// (Leap years will be dealt with, when user enters the Year)
          (dd > 29 && (mm == 02))) {
        // Remove char
        cText = cText.substring(0, 4);
      } else if (cText.length == 5) {
        /// the Month entered is valid; so,
        // Add a / char
        cText += '/';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = cText.substring(0, 2) + '/';
      } else {
        // Insert / char
        cText =
            cText.substring(0, pLen) + '/' + cText.substring(pLen, pLen + 1);
      }

      /// ENTERING THE YEAR
    } else if (cLen == 6 && pLen == 5) {
      // Can only be 1 or 2 - if so insert a / char
      int y1 = int.parse(cText.substring(5, 6));
      if (y1 < 1 || y1 > 2) {
        // Replace char
        /// i.e, add '/' after the 5th position
        cText = cText.substring(0, 5) + '/';
      } else {
        // Insert / char
        cText = cText.substring(0, 5) + '/' + cText.substring(5, 6);
      }
    } else if (cLen == 7) {
      /// the first digit of year
      // Can only be 1 or 2
      int y1 = int.parse(cText.substring(6, 7));
      if (y1 < 1 || y1 > 2) {
        // Remove char
        cText = cText.substring(0, 6);
      }
    } else if (cLen == 8) {
      // Can only be 19 or 20
      /// Also, there cannot be / typed by the user
      String y2 = cText.substring(6, 8);
      if (y2 != "19" && y2 != "20") {
        // Remove char
        cText = cText.substring(0, 7);
      }
    } else if (cLen == 9) {
      /// There cannot be / typed by the user
      if (cText.substring(8, 9) == "/") {
        // Remove char
        cText = cText.substring(0, 8);
      }
    } else if (cLen == 10) {
      /// There cannot be / typed by the user
      if (cText.substring(9, 10) == "/") {
        // Remove char
        cText = cText.substring(0, 9);
      }

      /// If the year entered is not a leap year but the date entered is February 29,
      /// it will be advanced to the next valid date
      date = cText.substring(0, 2);
      month = cText.substring(3, 5);
      year = int.parse(cText.substring(6, 10));
      bool isNotLeapYear =
          !((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0));
      if (isNotLeapYear && month == "02" && date == "29") {
        cText = "01/03/$year";
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class StepperGlobalWidget extends StatefulWidget {
  const StepperGlobalWidget({Key? key}) : super(key: key);

  @override
  State<StepperGlobalWidget> createState() => _StepperGlobalWidgetState();
}

class _StepperGlobalWidgetState extends State<StepperGlobalWidget> {
  double height = 0.0;
  double width = 0.0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return stepperWidget();
  }

  Widget stepperWidget() {
    return Container(
        height: height * .1,
        width: width,
        alignment: Alignment.center,
        color: ThemeApp.whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: _iconViews(),
              ),
              const SizedBox(
                height: 8,
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _titleViews(context),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _dateViews(context),
                ),
              ),
            ],
          ),
        ));
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    titles.asMap().forEach((i, icon) {
      var circleColor = (i == 0 || i == 1 || _curStep > i + 1)
          ? ThemeApp.darkGreyTab
          : ThemeApp.lightGreyTab;
      var lineColor =
          _curStep > i + 1 ? ThemeApp.darkGreyTab : ThemeApp.lightGreyTab;
      var iconColor = (i == 0 || i == 1 || _curStep > i + 1)
          ? ThemeApp.darkGreyTab
          : ThemeApp.lightGreyTab;

      list.add(
        Container(
          width: 23.0,
          height: 23.0,
          padding: const EdgeInsets.all(0),
          // decoration:(i == 0 || _curStep > i + 1) ? new  BoxDecoration(
          //
          // ):BoxDecoration(   /* color: circleColor,*/
          //   borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
          //   border: new Border.all(
          //     color: circleColor,
          //     width: 2.0,
          //   ),),
          child: (i == 0 || _curStep > i + 1)
              ? Icon(
                  Icons.circle,
                  color: iconColor,
                  size: 18.0,
                )
              : Icon(
                  Icons.radio_button_checked_outlined,
                  color: iconColor,
                  size: 18.0,
                ),
        ),
      );

      //line between icons
      if (i != titles.length - 1) {
        list.add(Expanded(
            child: Container(
          height: 3.0,
          color: lineColor,
        )));
      }
    });

    return list;
  }

  List<Widget> _titleViews(BuildContext context) {
    var list = <Widget>[];
    titles.asMap().forEach((i, text) {
      list.add(
        (i == 0 || i == 1 || _curStep > i + 1)
            ? TextFieldUtils().dynamicText(
                text,
                context,
                TextStyle(
                    color: ThemeApp.darkGreyColor,
                    fontSize: height * .018,
                    fontWeight: FontWeight.bold))
            : TextFieldUtils().dynamicText(
                text,
                context,
                TextStyle(
                    color: ThemeApp.darkGreyColor,
                    fontSize: height * .018,
                    fontWeight: FontWeight.w400)),
      );
    });
    return list;
  }

  List<Widget> _dateViews(BuildContext context) {
    var list = <Widget>[];
    dates.asMap().forEach((i, text) {
      list.add(
        (i == 0 || i == 1 || _curStep > i + 1)
            ? TextFieldUtils().dynamicText(
                text,
                context,
                TextStyle(
                    color: ThemeApp.darkGreyTab,
                    fontSize: height * .016,
                    fontWeight: FontWeight.w400))
            : TextFieldUtils().dynamicText(
                text,
                context,
                TextStyle(
                    color: ThemeApp.darkGreyTab,
                    fontSize: height * .016,
                    fontWeight: FontWeight.w400)),
      );
    });
    return list;
  }
}

final List<String> titles = [
  'Order Placed',
  'Packed',
  'Shipped',
  'Delivered',
];
final List<String> dates = [
  '8 Sept 2022',
  '8 Sept 2022',
  '9 Sept 2022',
  '10 Sept 2022',
];
int _curStep = 1;
