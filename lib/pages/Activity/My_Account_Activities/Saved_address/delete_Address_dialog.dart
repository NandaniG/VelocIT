import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/Saved_address/saved_address_detailed_screen.dart';

import '../../../../services/models/AddressListModel.dart';
import '../../../../services/providers/Products_provider.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/global/proceedButtons.dart';
import '../../../../widgets/global/textFormFields.dart';

class DeleteAddressDialog extends StatefulWidget {
  final int index;
  List<AddressListModel> addressList;

  DeleteAddressDialog({required this.index, required this.addressList});

  @override
  State<DeleteAddressDialog> createState() => _DeleteAddressDialogState();
}

class _DeleteAddressDialogState extends State<DeleteAddressDialog> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;

  dialogContent(BuildContext context) {
    {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: height * .25,
          maxHeight: height * .25,
          maxWidth: width,
        ),
        child: Container(
          padding: EdgeInsets.all(10),
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
                TextFieldUtils().dynamicText(
                    'Delete Address',
                    context,
                    TextStyle(
                        color: ThemeApp.blackColor,
                        fontSize: height * .025,
                        fontWeight: FontWeight.w500)),
                Center(
                  child: TextFieldUtils().dynamicText(
                      "Are you sure about deleting\n selected Address.",
                      context,
                      TextStyle(
                          color: ThemeApp.darkGreyTab,
                          fontSize: height * .018,
                          fontWeight: FontWeight.w400)),
                ),
                SizedBox(
                  height: height * .02,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: proceedButton(AppLocalizations.of(context).no,
                            ThemeApp.whiteColor, context, () {
                          Navigator.pop(context);
                        }),
                      ),
                      SizedBox(
                        width: width * .03,
                      ),
                      Expanded(
                        flex: 1,
                        child: Consumer<ProductProvider>(
                            builder: (context, value, child) {
                          return proceedButton(AppLocalizations.of(context).yes,
                              ThemeApp.blackColor, context, () {
                            setState(() {
                              print(widget.addressList.length);
                              value.deleteAddress(widget.index);
                              final snackBar = SnackBar(
                                content: Text('Address delete successfully!'),
                                clipBehavior: Clip.antiAlias,
                                backgroundColor:
                                    ThemeApp.innerTextFieldErrorColor,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SavedAddressDetails(),
                                ),
                              );

                              // widget.cardList.creditCardList.removeAt(widget.index);
                            });
                          });
                        }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

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
