import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit/widgets/global/proceedButtons.dart';

import '../../../../Core/AppConstant/apiMapping.dart';
import '../../../../Core/Model/CRMModels/CRMSingleIDModel.dart';
import '../../../../utils/StringUtils.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/routes/routes.dart';
import '../../../../utils/styles.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/dynamicPopUp.dart';
import '../../../../widgets/global/textFormFields.dart';

class CRMFormScreen extends StatefulWidget {
  final shortName;
  CRMDetailsPayload payload;

  // dynamic dynamicForm;
  CRMFormScreen({
    Key? key,
    this.shortName,
    required this.payload,
    /*required this.dynamicForm*/
  }) : super(key: key);

  @override
  State<CRMFormScreen> createState() => _CRMFormScreenState();
}

class _CRMFormScreenState extends State<CRMFormScreen> {
  BankListDataModel? _bankChoose;
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  String serviceName = '';
  var selectedDate='';
  var selectedTime='';
  TextEditingController serviceController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  TextEditingController mobileNumberController = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController f1_labelController= new TextEditingController();
  TextEditingController f2_labelController= new TextEditingController();
  TextEditingController f3_labelController= new TextEditingController();
  TextEditingController f4_labelController= new TextEditingController();
  TextEditingController f5_labelController= new TextEditingController();

  bool _validateName = false;
  bool _validateMobile = false;
  bool _validateEmail = false;
  bool _validateDate = false;
  bool _validateTime = false;
  final _formKey = GlobalKey<FormState>();
  var is_f1_enabled;
  var is_f2_enabled;
  var is_f3_enabled;
  var is_f4_enabled;
  var is_f5_enabled;
  var f1_label;
  var f2_label;
  var f3_label;
  var f4_label;
  var f5_label;
  List<BankListDataModel> bankDataList = [
    BankListDataModel("AC repair"),
    BankListDataModel("Sofa cleaning"),
    BankListDataModel("Fridge repair"),
    //BankListDataModel("Canara","https://bankforms.org/wp-content/uploads/2019/10/Canara-Bank.png")
  ];

  @override
  void initState() {
    super.initState();
    serviceName = widget.shortName;
    serviceController = new TextEditingController(text: serviceName);
    timeController = new TextEditingController(text: selectedDate);
    dateController = new TextEditingController(text: selectedTime);
    _bankChoose = bankDataList[0];
    getForm();
  }

  void _onDropDownItemSelected(BankListDataModel newSelectedBank) {
    setState(() {
      _bankChoose = newSelectedBank;
    });
  }

  getForm() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      is_f1_enabled = prefs.getBool('is_f1_enabled');
      is_f2_enabled = prefs.getBool('is_f2_enabled');
      is_f3_enabled = prefs.getBool('is_f3_enabled');
      is_f4_enabled = prefs.getBool('is_f4_enabled');

      f1_label = prefs.getString('f1_label');
      f2_label = prefs.getString('f2_label');
      f3_label = prefs.getString('f3_label');
      f4_label = prefs.getString('f4_label');
      f5_label = prefs.getString('f5_label');
    });

    is_f5_enabled = prefs.getBool('is_f5_enabled');
    print(is_f5_enabled);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .09),
        child: appBar_backWidget(context, appTitle(context, "CRM Appointment"),
            SizedBox(), setState),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: appointmentService(),
      ),
    );
  }

  Widget appointmentService() {
    return Container(
      height: height,
      decoration: const BoxDecoration(
          color: ThemeApp.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
             Text(
                StringUtils.services,
                    style: SafeGoogleFont(
                      'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ThemeApp.primaryNavyBlackColor,
                    ),
                  ),
                  CharacterTextFormFieldsWidget(
                      errorText: 'Please enter Name',
                      isEnable: false,
                      textInputType: TextInputType.name,
                      controller: serviceController,
                      autoValidation: AutovalidateMode.onUserInteraction,
                      hintText: '',
                      onChange: (val) {},
                      validator: (value) {
                        return null;
                      }),
                  /*   FormField<String>(
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
                            // errorStyle: TextStyle(fontFamily: 'Roboto',
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
                  ),*/
                  SizedBox(
                    height: height * .02,
                  ),
                  nameWidget(),
                  SizedBox(
                    height: height * .02,
                  ),
                  dateAndTimeWidget(),
                  SizedBox(
                    height: height * .02,
                  ),
                  mobileNumber(),
                  SizedBox(
                    height: height * .02,
                  ),
                  TextFieldUtils()
                      .asteriskTextField(StringUtils.emailAddress, context),
                  EmailTextFormFieldsWidget(
                      errorText: StringUtils.validEmailError,
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
                  ///////dynamic fields
                  if (is_f1_enabled == true)  Text(
                    f1_label,
                    style: SafeGoogleFont(
                      'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ThemeApp.primaryNavyBlackColor,
                    ),
                  ),
                  if (is_f1_enabled == true)
                    TextFormFieldsWidget(
                        errorText: '',
                        textInputType: TextInputType.name,
                        controller: f1_labelController,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: 'F1 label',
                        onChange: (val) {
                          // setState(() {
                          //   if (val.isEmpty && timeController.text.isEmpty) {
                          //     _validateTime = true;
                          //   } else {
                          //     _validateTime = false;
                          //   }
                          // });
                        },
                        validator: (value) {
                          // if (value.isEmpty && timeController.text.isEmpty) {
                          //   _validateTime = true;
                          //   return 'Please enter time';
                          // } else {
                          //   _validateTime = false;
                          // }
                          return null;
                        }),
                  if (is_f1_enabled == true)   SizedBox(
                    height: height * .02,
                  ),
                  if (is_f2_enabled == true) Text(
                    f2_label,
                    style: SafeGoogleFont(
                      'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ThemeApp.primaryNavyBlackColor,
                    ),
                  ),
                  if (is_f2_enabled == true)
                    TextFormFieldsWidget(
                        errorText: '',
                        textInputType: TextInputType.name,
                        controller: f2_labelController,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: 'F1 label',
                        onChange: (val) {
                          // setState(() {
                          //   if (val.isEmpty && timeController.text.isEmpty) {
                          //     _validateTime = true;
                          //   } else {
                          //     _validateTime = false;
                          //   }
                          // });
                        },
                        validator: (value) {
                          // if (value.isEmpty && timeController.text.isEmpty) {
                          //   _validateTime = true;
                          //   return 'Please enter time';
                          // } else {
                          //   _validateTime = false;
                          // }
                          return null;
                        }),
                  if (is_f1_enabled == true) SizedBox(
                    height: height * .02,
                  ),
                  if (is_f3_enabled == true)Text(
                    f3_label,
                    style: SafeGoogleFont(
                      'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ThemeApp.primaryNavyBlackColor,
                    ),
                  ),
                  if (is_f3_enabled == true)
                    TextFormFieldsWidget(
                        errorText: '',
                        textInputType: TextInputType.name,
                        controller: f3_labelController,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: 'F1 label',
                        onChange: (val) {
                          // setState(() {
                          //   if (val.isEmpty && timeController.text.isEmpty) {
                          //     _validateTime = true;
                          //   } else {
                          //     _validateTime = false;
                          //   }
                          // });
                        },
                        validator: (value) {
                          // if (value.isEmpty && timeController.text.isEmpty) {
                          //   _validateTime = true;
                          //   return 'Please enter time';
                          // } else {
                          //   _validateTime = false;
                          // }
                          return null;
                        }),
                  if (is_f1_enabled == true)  SizedBox(
                    height: height * .02,
                  ),
                  if (is_f4_enabled == true)Text(
                    f4_label,
                    style: SafeGoogleFont(
                      'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ThemeApp.primaryNavyBlackColor,
                    ),
                  ),
                  if (is_f4_enabled == true)
                    TextFormFieldsWidget(
                        errorText: '',
                        textInputType: TextInputType.name,
                        controller: f4_labelController,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: 'F4 label',
                        onChange: (val) {
                          // setState(() {
                          //   if (val.isEmpty && timeController.text.isEmpty) {
                          //     _validateTime = true;
                          //   } else {
                          //     _validateTime = false;
                          //   }
                          // });
                        },
                        validator: (value) {
                          // if (value.isEmpty && timeController.text.isEmpty) {
                          //   _validateTime = true;
                          //   return 'Please enter time';
                          // } else {
                          //   _validateTime = false;
                          // }
                          return null;
                        }),
                  if (is_f1_enabled == true)  SizedBox(
                    height: height * .02,
                  ),
                  if (is_f5_enabled == true)Text(
                    f5_label,
                    style: SafeGoogleFont(
                      'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ThemeApp.primaryNavyBlackColor,
                    ),
                  ),
                  if (is_f5_enabled == true)
                    TextFormFieldsWidget(
                        errorText: '',
                        textInputType: TextInputType.name,
                        controller: f5_labelController,
                        autoValidation: AutovalidateMode.onUserInteraction,
                        hintText: 'F5label',
                        onChange: (val) {
                          // setState(() {
                          //   if (val.isEmpty && timeController.text.isEmpty) {
                          //     _validateTime = true;
                          //   } else {
                          //     _validateTime = false;
                          //   }
                          // });
                        },
                        validator: (value) {
                          // if (value.isEmpty && timeController.text.isEmpty) {
                          //   _validateTime = true;
                          //   return 'Please enter time';
                          // } else {
                          //   _validateTime = false;
                          // }
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
      ),
    );
  }

  Widget nameWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldUtils().asteriskTextField(StringUtils.name, context),
        CharacterTextFormFieldsWidget(
            errorText: 'Please enter a Name',
            textInputType: TextInputType.name,
            controller: nameController,
            autoValidation: AutovalidateMode.onUserInteraction,
            hintText: 'Type your name',
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
                return  'Please enter a Name';
              } else if (nameController.text.length < 4) {
                _validateName = true;
                return 'Please enter a Name';
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
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldUtils().asteriskTextField(StringUtils.date, context),
              TextFormFieldsWidget(
                  errorText: 'Please enter date.',
                  textInputType: TextInputType.name,
                  controller: dateController,
                  autoValidation: AutovalidateMode.onUserInteraction,
                  hintText: 'DD / MM / YYYY',
                  readOnly: true,
                  onTap: ()=>_selectDate(context),
                  onChange: (val) {
                    setState(() {
                      if (val.isEmpty && dateController.text.isEmpty) {
                        _validateDate = true;
                      } else if (dateController.text.length < 4) {
                        _validateDate = true;
                      } else {
                        _validateDate = false;
                      }
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty && dateController.text.isEmpty) {
                      _validateDate = true;
                      return 'Please enter date.';
                    } else {
                      _validateDate = false;
                    }
                    return null;
                  }),
            ],
          ),
        ),
        SizedBox(width: 10,),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldUtils().asteriskTextField(StringUtils.time, context),
              TextFormFieldsWidget(
                  errorText: 'Please enter time.',
                  textInputType: TextInputType.name,
                  controller: timeController,
                  autoValidation: AutovalidateMode.onUserInteraction,
                  hintText: '00:00 AM/PM',
                  readOnly: true,
                  onTap: ()=>_selectTime(context),
                  onChange: (val) {
                    setState(() {
                      if (val.isEmpty && timeController.text.isEmpty) {
                        _validateTime = true;
                      } else {
                        _validateTime = false;
                      }
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty && timeController.text.isEmpty) {
                      _validateTime = true;
                      return 'Please enter time.';
                    } else {
                      _validateTime = false;
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
        TextFieldUtils().asteriskTextField(StringUtils.mobileNumber, context),
        MobileNumberTextFormField(
            controller: mobileNumberController,
            enable: true,errorText: 'Please enter a valid mobile.',
            onChanged: (phone) {
              print(phone.completeNumber);
              if (phone.countryCode == "IN") {
                print("india selected");
                print(phone.completeNumber);
              } else {
                print("india not selected");
              }
              setState(() {
                if (phone=='' && mobileNumberController.text.isEmpty) {
                  _validateMobile = true;
                } else {
                  _validateMobile = false;
                }
              });
            },
            validator: (value) {
              if (value==''&& mobileNumberController.text.isEmpty) {
                _validateMobile = true;
                return StringUtils.enterMobileNumber;
              } else if (mobileNumberController.text.length < 10) {
                _validateMobile = true;
                return StringUtils.enterMobileNumber;
              } else {
                _validateMobile = false;
              }
              return null;
            }),
      ],
    );
  }

  Widget submitButton() {
    return proceedButton('Submit', ThemeApp.tealButtonColor, context, false,
        () async {
      final prefs = await SharedPreferences.getInstance();

      if (_formKey.currentState!.validate() &&
          mobileNumberController.text.isNotEmpty) {
        FocusManager.instance.primaryFocus?.unfocus();

        StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';
        String result = DateTime.now().toUtc().toString().replaceAll(" ", "T");
        print("Current Date Time " + result.toString());
        String tempDate = pickedDateForPass.toUtc().toString().replaceAll(" ", "T");
        // String tempTime = pickedTimeForPass.toString().replaceAll(" ", "T");

        print(tempDate);
        // print(tempTime);
        Map data = {
          "appoint_date": tempDate,
          "appoint_time": result,
          "crm_form_id": widget.payload.crmFormId.toString(),
          "email": email.text,
          "f1_value": f1_labelController.text??"",
          "f2_value": f1_labelController.text??"",
          "f3_value": f3_labelController.text??"",
          "f4_value": f4_labelController.text??"",
          "f5_value": f5_labelController.text??"",
          "mobile": mobileNumberController.text,
          "name": nameController.text,
          "note": "Be ready!",
          "service_item_id": 1,
          "user_id": StringConstant.UserLoginId
        };
        print(data);
        apiRequest(data);
        /*  showDialog(
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
              });*/
      }else{
        // if(mobileNumberController.text.isEmpty||mobileNumberController.text.length<10){
        //
        //   _validateMobile = true;
        // }else{_validateMobile=false;}
      }
    });
  }
  DateTime currentDate = DateTime.now();
var pickedDateForPass;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));

    pickedDateForPass = pickedDate;
    String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate!);
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {

          dateController.text = formattedDate;

      });
  }
  var pickedTimeForPass;
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? result =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        pickedTimeForPass = result;
        timeController.text = result.format(context);
      });
    }
  }
  Future apiRequest(Map jsonMap) async {
    var url = ApiMapping.getURI(apiEndPoint.crm_form_data);
    print("CRM form " + url.toString());
    print("CRM form " + jsonMap.toString());

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));

    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    dynamic reply = await response.transform(utf8.decoder).join();
    String rawJson = reply.toString();
    print(reply);
    // Utils.successToast(rawJson.toString());

    Map<String, dynamic> map = jsonDecode(rawJson);
//checking response with 201
    if (response.statusCode == 201) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return submitDialog(
                heading: 'Thank you',
                subHeading: 'You have successfully submitted your enquiry.',
                buttonText: 'Close',
                onTap: () {
                  Navigator.pushReplacementNamed(
                          context, RoutesName.dashboardRoute)
                      .then((value) => setState(() {}));
                });
          });
      // Utils.successToast(name.toString());
      Utils.successToast('Enquiry submitted. Thank you');

      print(reply.toString());
    } else {
      Utils.errorToast('Something went wrong');
    }

    httpClient.close();
    return reply;
  }
}

class BankListDataModel {
  String bank_name;

  BankListDataModel(
    this.bank_name,
  );
}

class submitDialog extends StatefulWidget {
  final String heading;
  final String subHeading;
  final String buttonText;
  final VoidCallback onTap;

  submitDialog({
    required this.heading,
    required this.subHeading,
    required this.buttonText,
    required this.onTap,
  });

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
          maxWidth: MediaQuery.of(context).size.width,
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
                        fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        // fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.height * .022,
                        fontWeight: FontWeight.w400)),
                proceedButton(widget.buttonText, ThemeApp.tealButtonColor,
                    context, false, widget.onTap),
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
