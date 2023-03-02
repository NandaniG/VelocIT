import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/state_manager.dart';
import 'package:velocit/utils/utils.dart';
import 'package:velocit/widgets/global/proceedButtons.dart';
import 'package:velocit/widgets/global/textFormFields.dart';

import '../../../utils/styles.dart';

class QRDialog extends StatefulWidget {
  final Map Order;

  const QRDialog({super.key, required this.Order});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Utils().loadPdfFromNetwork(widget.Order["order_qr_code"], widget.Order["order_id"].toString(),widget.Order["short_name"].toString()).then((value){
                            Utils.successToast('Order QR Download Successfully');

                          });
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: ThemeApp.whiteColor,
                              border: Border.all(
                                width: 1,
                                color: ThemeApp.appColor,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              'assets/appImages/DownloadQRIcon.svg',
                              color: ThemeApp.appColor,
                              semanticsLabel: 'Acme Logo',

                              // width: 8.77,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: (){Utils().shareFile
                       (widget.Order["order_qr_code"], widget.Order["order_id"].toString(),widget.Order["short_name"].toString()).then((value){

                          });
                        },
                        child: Container(
                          height: 40,      width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: ThemeApp.appColor,
                              border: Border.all(
                                width: 1,
                                color: ThemeApp.appColor,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              'assets/appImages/ShareIcon.svg',
                              color: ThemeApp.whiteColor,
                              semanticsLabel: 'Acme Logo',
                              // height: 16.29,
                              // width: 8.77,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                    // color: ThemeApp.whiteColor,
                    // borderRadius:
                    //     const BorderRadius.all(Radius.circular(30)),
                    shape: BoxShape.rectangle,
                    // image: new DecorationImage(
                    //     // fit: BoxFit.fill,
                    //     image: new AssetImage(
                    //       'assets/images/qr_test_image.png',
                    //     ))
                  ),
                  child: Image.network(
                    widget.Order["order_qr_code"] ?? "",
                    // fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300,
                        child: Icon(
                          Icons.error_outline,
                          color: ThemeApp.redColor,
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
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
