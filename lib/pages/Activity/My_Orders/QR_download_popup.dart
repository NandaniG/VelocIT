import 'package:flutter/material.dart';
import 'package:velocit/widgets/global/proceedButtons.dart';
import 'package:velocit/widgets/global/textFormFields.dart';

import '../../../utils/styles.dart';

class QRDialog extends StatefulWidget {
  @override
  State<QRDialog> createState() => _QRDialogState();
}

class _QRDialogState extends State<QRDialog> {
  dialogContent(BuildContext context) {
    {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 800,
          maxHeight: double.infinity,
          maxWidth: double.infinity,
        ),
        child: Container(
          // padding: EdgeInsets.all(10),
          decoration: new BoxDecoration(
            // color: Colors.transparent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              // BoxShadow(
              //   // color: Colors.black12,
              //   blurRadius: 10.0,
              //   offset: const Offset(0.0, 5.0),
              // ),
            ],
          ),
          child: Container(
            //  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      alignment: Alignment.topLeft,
                      decoration: new BoxDecoration(
                        color: ThemeApp.whiteColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(Icons.download_outlined, size: 30),
                          ),
                          TextFieldUtils().lineVertical(),
                          Container(
                            color: ThemeApp.whiteColor,
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.share,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.clear,
                          color: ThemeApp.whiteColor,
                          size: 40,
                        )),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .2,
                ),
                Center(
                  child: Container(
                      height: 300,
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.all(15),
                      decoration: new BoxDecoration(
                          color: ThemeApp.whiteColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          shape: BoxShape.rectangle,
                          image: new DecorationImage(
                              // fit: BoxFit.fill,
                              image: new AssetImage(
                                'assets/images/qr_test_image.png',
                              )))),
                ),
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
