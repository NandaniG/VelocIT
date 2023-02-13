import 'package:flutter/material.dart';
import 'package:velocit/utils/styles.dart';

class ProgressIndicatorLoader extends StatefulWidget {
  final bool isLoading;

  ProgressIndicatorLoader(this.isLoading);

  @override
  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicatorLoader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: widget.isLoading
          ? new Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: new Center(
              child: SizedBox(
                height: 20,
                width:20,
                child: new CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(ThemeApp.appColor),
                  backgroundColor: Colors.transparent,
                ),
              )))
          : new Container(),
    );
  }
}
