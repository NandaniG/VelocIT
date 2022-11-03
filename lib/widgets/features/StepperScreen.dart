import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/styles.dart';
import '../global/textFormFields.dart';

class StepProgressView extends StatelessWidget {
  final double _width;

  final List<String> _titles;
  final int _curStep;
  final Color _activeColor;
  final Color _inactiveColor = ThemeApp.darkGreyTab;
  final double lineWidth = 3.0;

  StepProgressView(
      {Key? key,
        required int curStep,
        required List<String> titles,
       required double width,
       required Color color})
      : _titles = titles,
        _curStep = curStep,
        _width = width,
        _activeColor = color,
        assert(width > 0),
        super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),

            child: Container(
              height: 300,alignment: Alignment.center,
                width: 200,
                child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: _iconViews(),
                    ),
                    SizedBox(
                      height: 8,
                    ),

                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _titleViews(context),
                      ),
                    ),
                  ],
                )),

        ),
      ),
    );
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    _titles.asMap().forEach((i, icon) {
      var circleColor = (i == 0 || _curStep > i + 1) ? _activeColor : _inactiveColor;
      var lineColor = _curStep > i + 1 ? _activeColor : _inactiveColor;
      var iconColor = (i == 0 || _curStep > i + 1) ? _activeColor : _inactiveColor;

      list.add(
        Container(
          width: 20.0,
          height: 20.0,
          padding: EdgeInsets.all(0),
          decoration: new BoxDecoration(
            /* color: circleColor,*/
            borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
            border: new Border.all(
              color: circleColor,
              width: 2.0,
            ),
          ),
          child: Icon(
            Icons.circle,
            color: iconColor,
            size: 12.0,
          ),
        ),
      );

      //line between icons
      if (i != _titles.length - 1) {
        list.add(Expanded(
            child: Container(
              height: lineWidth,
              color: lineColor,
            )));
      }
    });

    return list;
  }

  List<Widget> _titleViews(BuildContext context) {
    var list = <Widget>[];
    _titles.asMap().forEach((i, text) {
      list.add( TextFieldUtils().subHeadingTextFields(
          text, context),);
    });
    return list;
  }
}

// import 'package:flutter/material.dart';
//
// import '../../utils/styles.dart';
//
// class ProcessCard {
//   String title;
//   IconData icon;
//
//   ProcessCard(this.title, this.icon);
// }
//
// class StepperScreen extends StatefulWidget {
//   const StepperScreen({Key? key}) : super(key: key);
//
//   @override
//   State<StepperScreen> createState() => _StepperScreenState();
// }
// List<Color> colors = [ThemeApp.darkGreyTab,ThemeApp.darkGreyTab,ThemeApp.darkGreyTab];
//
// class _StepperScreenState extends State<StepperScreen> {
//   List<ProcessCard> _getProcess() {
//     List<ProcessCard> processCard = [];
//
//     processCard.add(ProcessCard("Order Placed", Icons.circle));
//     processCard.add(ProcessCard(
//         "Packed", Icons.circle));
//     processCard.add(ProcessCard(
//         "Shipped", Icons.adjust_rounded));
//
//
//     processCard.add(ProcessCard(
//         "Delivered",Icons.circle_outlined));
//     return processCard;
//   }
//
//   List<ProcessCard> processCard = [];
//
//   @override
//   void initState() {
// // TODO: implement initState
//     super.initState();
//     processCard = _getProcess();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: ThemeApp.whiteColor,
//         appBar: PreferredSize(
//             preferredSize: const Size.fromHeight(70),
//             child: Container(
//               alignment: Alignment.centerLeft,
//               child: IconButton(
//                 icon: Icon(Icons.arrow_back, color: ThemeApp.blackColor),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//             )),
//         body: Container(
//           child: ListView.builder(
//               itemCount: processCard.length,
//               itemBuilder: (context, index) {
//                 return Container(
//                     child: Row(
//                   children: <Widget>[
//                     Column(
//                       children: <Widget>[
//                         Container(
//                           width: 2,
//                           height: 60,
//                           color: index == 0 ? Colors.white : Colors.black,
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(left: 8, right: 5),
//                           padding: EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                               color: colors[(index + 1) % 4],
//                               borderRadius: BorderRadius.circular(50)),
//                           child: Icon(
//                             processCard[index].icon,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Container(
//                           width: 2,
//                           height: 60,
//                           color: index == processCard.length - 1
//                               ? Colors.white
//                               : Colors.black,
//                         ),
//                       ],
//                     ),
//                     Expanded(
//                         child: Container(
//                       margin: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border(
//                             top: BorderSide(
//                               width: 3,
//                               color: colors[(index + 1) % 4],
//                             ),
//                             left: BorderSide(
//                               width: 3,
//                               color: colors[(index + 1) % 4],
//                             ),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               blurRadius: 5,
//                               color: Colors.black26,
//                             )
//                           ]),
//                       height: 140,
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(
//                               processCard[index].title,
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: colors[(index + 1) % 4],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ))
//                   ],
//                 ));
//               }),
//         ));
//   }
// }
