import 'package:flutter/material.dart';
import 'package:velocit/widgets/global/proceedButtons.dart';

import '../../utils/StringUtils.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../widgets/global/appBar.dart';
import '../../widgets/global/dynamicPopUp.dart';
import '../../widgets/global/textFormFields.dart';

class CRMFormScreen extends StatefulWidget {
  const CRMFormScreen({Key? key}) : super(key: key);

  @override
  State<CRMFormScreen> createState() => _CRMFormScreenState();
}

class _CRMFormScreenState extends State<CRMFormScreen> {
  BankListDataModel? _bankChoose;
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  TextEditingController nameController = new TextEditingController();
  TextEditingController mobileNumberController = new TextEditingController();
  TextEditingController email = new TextEditingController();

  bool _validateName = false;
  bool _validateEmail = false;

  List<BankListDataModel> bankDataList = [
    BankListDataModel("AC repair"),
    BankListDataModel("Sofa cleaning"),
    BankListDataModel("Fridge repair"),
    //BankListDataModel("Canara","https://bankforms.org/wp-content/uploads/2019/10/Canara-Bank.png")
  ];

  @override
  void initState() {
    super.initState();
    _bankChoose = bankDataList[0];
  }

  void _onDropDownItemSelected(BankListDataModel newSelectedBank) {
    setState(() {
      _bankChoose = newSelectedBank;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;
    return
      Scaffold(
        backgroundColor: ThemeApp.appBackgroundColor,
        key: scaffoldGlobalKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * .09),
          child: appBar_backWidget(
              context, appTitle(context, "CRM Appointment"), SizedBox()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              appointmentService(),
            ],
          ),
        ),
      );
  }

  Widget appointmentService() {
    return Container(
      decoration: const BoxDecoration(
          color: ThemeApp.whiteColor,
          borderRadius: BorderRadius.all(
              Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldUtils().asteriskTextField(
                    StringUtils.services, context),
                FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.fromLTRB(12, 10, 20, 20),
                          // labelText: "hi",
                          // labelStyle: textStyle,
                          // labelText: _dropdownValue == null
                          //     ? 'Where are you from'
                          //     : 'From',
                          // errorText: "Wrong Choice",
                          // errorStyle: TextStyle(
                          //     color: Colors.redAccent, fontSize: 16.0),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(10.0))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<BankListDataModel>(

                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontFamily: "verdana_regular",
                          ),
                          hint: Text(
                            "Select Bank",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          items: bankDataList
                              .map<DropdownMenuItem<BankListDataModel>>(
                                  (BankListDataModel value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Text(value.bank_name),
                                    ],
                                  ),
                                );
                              }).toList(),

                          isExpanded: true,
                          isDense: true,
                          onChanged: (BankListDataModel? newSelectedBank) {
                            _onDropDownItemSelected(newSelectedBank!);
                          },
                          value: _bankChoose,

                        ),
                      ),
                    );
                  },
                ), SizedBox(
                  height: height * .02,
                ),

                nameWidget(),
                SizedBox(
                  height: height * .02,
                ),

                dateAndTimeWidget(),
                SizedBox(
                  height: height * .02,
                ), mobileNumber(),
                SizedBox(
                  height: height * .02,
                ),
                TextFieldUtils().asteriskTextField(
                    StringUtils.emailAddress, context),

                TextFormFieldsWidget(
                    errorText: StringUtils.emailError,
                    textInputType: TextInputType.emailAddress,
                    controller: email,
                    autoValidation: AutovalidateMode.onUserInteraction,
                    hintText: StringUtils.emailAddress,
                    onChange: (val) {
                      setState(() {
                        if (val.isEmpty && email.text.isEmpty) {
                          _validateEmail = true;
                        } else if (!StringConstant().isEmail(val)) {
                          _validateEmail = true;
                        } else {
                          _validateEmail = false;
                        }
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty && email.text.isEmpty) {
                        _validateEmail = true;
                        return StringUtils.validEmailError;
                      } else if (!StringConstant().isEmail(value)) {
                        _validateEmail = true;
                        return StringUtils.validEmailError;
                      } else {
                        _validateEmail = false;
                      }
                      return null;
                    }),
                SizedBox(
                  height: height * .02,
                ),
                submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nameWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldUtils().asteriskTextField(
            StringUtils.name, context),
        CharacterTextFormFieldsWidget(
            errorText: 'Please enter Name',
            textInputType: TextInputType.name,
            controller: nameController,
            autoValidation: AutovalidateMode.onUserInteraction,
            hintText: 'David Wong',
            onChange: (val) {
              setState(() {
                if (val.isEmpty && nameController.text.isEmpty) {
                  _validateName = true;
                } else if (nameController.text.length < 4) {
                  _validateName = true;
                } else {
                  _validateName = false;
                }
              });
            },
            validator: (value) {
              if (value.isEmpty && nameController.text.isEmpty) {
                _validateName = true;
                return StringUtils.fullName;
              } else if (nameController.text.length < 4) {
                _validateName = true;
                return StringUtils.fullName;
              } else {
                _validateName = false;
              }
              return null;
            }),
      ],
    );
  }

  Widget dateAndTimeWidget() {
    return Row(
      children: [
        Expanded(flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldUtils().asteriskTextField(
                  StringUtils.date, context),
              TextFormFieldsWidget(
                  errorText: 'Please enter date',
                  textInputType: TextInputType.name,
                  controller: nameController,
                  autoValidation: AutovalidateMode.onUserInteraction,
                  hintText: 'MM / YY',
                  onChange: (val) {
                    setState(() {
                      if (val.isEmpty && nameController.text.isEmpty) {
                        _validateName = true;
                      } else if (nameController.text.length < 4) {
                        _validateName = true;
                      } else {
                        _validateName = false;
                      }
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty && nameController.text.isEmpty) {
                      _validateName = true;
                      return StringUtils.fullName;
                    } else if (nameController.text.length < 4) {
                      _validateName = true;
                      return StringUtils.fullName;
                    } else {
                      _validateName = false;
                    }
                    return null;
                  }),
            ],
          ),
        ),
        Expanded(flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldUtils().asteriskTextField(
                  StringUtils.time, context),
              TextFormFieldsWidget(
                  errorText: 'Please enter time',
                  textInputType: TextInputType.name,
                  controller: nameController,
                  autoValidation: AutovalidateMode.onUserInteraction,
                  hintText: '00:00',
                  onChange: (val) {
                    setState(() {
                      if (val.isEmpty && nameController.text.isEmpty) {
                        _validateName = true;
                      } else if (nameController.text.length < 4) {
                        _validateName = true;
                      } else {
                        _validateName = false;
                      }
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty && nameController.text.isEmpty) {
                      _validateName = true;
                      return StringUtils.fullName;
                    } else if (nameController.text.length < 4) {
                      _validateName = true;
                      return StringUtils.fullName;
                    } else {
                      _validateName = false;
                    }
                    return null;
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget mobileNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldUtils().asteriskTextField(
            StringUtils.mobileNumber, context),
        MobileNumberTextFormField(
          controller: mobileNumberController,
          enable: true,
        ),
      ],
    );
  }

  Widget submitButton() {
    return proceedButton('Submit', ThemeApp.tealButtonColor,
        context, false, () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return submitDialog(
                    heading: 'Thank you',
                    subHeading: 'You have successfully submitted Plumber Appointment.',
                    buttonText: 'Close',
                    onTap
                        :(){
                      Navigator.pop(context);
                    });
              });
        });
  }


}

class BankListDataModel {
  String bank_name;

  BankListDataModel(this.bank_name,);
}

class submitDialog extends StatefulWidget {
  final String heading;
  final String subHeading;
  final String buttonText;
  final VoidCallback onTap;

  submitDialog(
      {required this.heading, required this.subHeading, required this.buttonText, required this.onTap,});

  @override
  State<submitDialog> createState() => _submitDialogState();
}

class _submitDialogState extends State<submitDialog> {
  dialogContent(BuildContext context) {
    {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 70.0,
          maxHeight: 300.0,
          maxWidth: MediaQuery
              .of(context)
              .size
              .width,
        ),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 5.0),
              ),
            ],
          ),
          child: Container(
            //  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    child: TextFieldUtils()
                        .textFieldHeightThree(widget.heading, context)),
                TextFieldUtils().dynamicText(
                    widget.subHeading,
                    context,
                    TextStyle(
                        color: ThemeApp.blackColor,
                        // fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.height * .022,
                        fontWeight: FontWeight.w400)),

                proceedButton(
                    widget.buttonText, ThemeApp.blackColor, context, false,
                    widget.onTap),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
