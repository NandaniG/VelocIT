
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocit/pages/Activity/Merchant_Near_Activities/merchant_Activity.dart';
import 'package:velocit/pages/screens/cartDetail_Activity.dart';
import 'package:velocit/pages/screens/offers_Activity.dart';
import 'package:velocit/widgets/global/appBar.dart';

import '../../pages/screens/dashBoard.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import 'package:badges/badges.dart' as badges;
// ignore: must_be_immutable
class DashBoardActivity extends StatefulWidget {
  late TabController controller;
  @override
  _DashBoardActivityState createState() => _DashBoardActivityState();
}

class _DashBoardActivityState extends State<DashBoardActivity> {

  int currentTabIndex = 0;
  String _title ='';

  @override
  // ignore: must_call_super
  initState(){
    _title = 'BreadWinner';
    // ignore: unnecessary_statements
  }

  List<Widget> tabs = [
    DashboardScreen(),
    OfferActivity(),
    Container(),
    MerchantActvity(),
    CartDetailsActivity()
  ];
  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:   PreferredSize(
          preferredSize:
          Size.fromHeight(MediaQuery.of(context).size.height * .135),
          child: Container(
            color: ThemeApp.appBackgroundColor,
            child: AppBarWidget(
              context: context,
              titleWidget: searchBarWidget(),
              location: AddressWidgets(),
            ),
          ),
        ),
        body:
        tabs[currentTabIndex],
        bottomNavigationBar: BottomNavigationBar(

          backgroundColor: ThemeApp.whiteColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: ThemeApp.appColor,
          unselectedItemColor: ThemeApp.unSelectedBottomBarItemColor,

          onTap: onTabTapped,
          currentIndex: currentTabIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon:Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: SvgPicture.asset(
                  'assets/appImages/bottomApp/homeIcon.svg',
                  color: currentTabIndex == 0
                      ? ThemeApp.appColor
                      : ThemeApp.unSelectedBottomBarItemColor,
                  semanticsLabel: 'Acme Logo',
                  theme: SvgTheme(
                    currentColor: ThemeApp.appColor,
                  ),
                  height: 30,
                  width: 30,
                ),
              ),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: currentTabIndex == 1
                  ? Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: SvgPicture.asset(
                  'assets/appImages/bottomApp/offerIcon.svg',
                  color: ThemeApp.appColor,
                  semanticsLabel: 'Acme Logo',
                  theme: SvgTheme(
                    currentColor: ThemeApp.appColor,
                  ),
                  height: 30,
                  width: 30,
                ),
              )
                  : Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: SvgPicture.asset(
                  'assets/appImages/bottomApp/offerIcon.svg',
                  color: ThemeApp.unSelectedBottomBarItemColor,
                  semanticsLabel: 'Acme Logo',
                  theme: SvgTheme(
                    currentColor: ThemeApp.appColor,
                  ),
                  height: 30,
                  width: 30,
                ),
              ),
              label: 'OFFER',
            ),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: currentTabIndex == 2
                    ? Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Icon(Icons.add, color: Colors.transparent),
                )
                    : Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Icon(Icons.add, color: Colors.transparent),
                ),
                label: ''),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: currentTabIndex == 3
                    ? Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: SvgPicture.asset(
                    'assets/appImages/bottomApp/shopIcon.svg',
                    color: ThemeApp.appColor,
                    semanticsLabel: 'Acme Logo',
                    theme: SvgTheme(
                      currentColor: ThemeApp.appColor,
                    ),
                    height: 30,
                    width: 30,
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: SvgPicture.asset(
                    'assets/appImages/bottomApp/shopIcon.svg',
                    color: ThemeApp.unSelectedBottomBarItemColor,
                    semanticsLabel: 'Acme Logo',
                    theme: SvgTheme(
                      currentColor: ThemeApp.unSelectedBottomBarItemColor,
                    ),
                    height: 30,
                    width: 30,
                  ),
                ),
                label: 'SHOP'),
            BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: currentTabIndex == 4
                    ? Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 8),
                  child: StringConstant.BadgeCounterValue == '0' ||
                      StringConstant.BadgeCounterValue == '' ||
                      StringConstant.BadgeCounterValue == 0
                      ? SvgPicture.asset(
                    'assets/appImages/bottomApp/cartIcons.svg',
                    color: ThemeApp.appColor,
                    semanticsLabel: 'Acme Logo',
                    theme: SvgTheme(
                      currentColor: ThemeApp.appColor,
                    ),
                    height: 30,
                    width: 30,
                  )
                      : badges.Badge(
                    position: badges.BadgePosition.topEnd(),
                    badgeContent: Text(
                      StringConstant.BadgeCounterValue.toString(),
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: ThemeApp.redColor,
                      padding: EdgeInsets.all(7),
                    ),
                    child: SvgPicture.asset(
                      'assets/appImages/bottomApp/cartIcons.svg',
                      color: ThemeApp.appColor,
                      semanticsLabel: 'Acme Logo',
                      theme: SvgTheme(
                        currentColor: ThemeApp.appColor,
                      ),
                      height: 30,
                      width: 30,
                    ),
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 8),
                  child: StringConstant.BadgeCounterValue == '0' ||
                      StringConstant.BadgeCounterValue == '' ||
                      StringConstant.BadgeCounterValue == 0
                      ? SvgPicture.asset(
                    'assets/appImages/bottomApp/cartIcons.svg',
                    color: ThemeApp.unSelectedBottomBarItemColor,
                    semanticsLabel: 'Acme Logo',
                    theme: SvgTheme(
                      currentColor: ThemeApp.unSelectedBottomBarItemColor,
                    ),
                    height: 30,
                    width: 30,
                  )
                      : badges.Badge(
                    badgeContent: Text(
                      StringConstant.BadgeCounterValue.toString(),
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: ThemeApp.redColor,
                      padding: EdgeInsets.all(7),
                    ),
                    child: SvgPicture.asset(
                      'assets/appImages/bottomApp/cartIcons.svg',
                      color: ThemeApp.unSelectedBottomBarItemColor,
                      semanticsLabel: 'Acme Logo',
                      theme: SvgTheme(
                        currentColor:
                        ThemeApp.unSelectedBottomBarItemColor,
                      ),
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                label: 'CART'),
          ],
        ),
      ),
    );
  }
  void onTabTapped(int index) {
    setState(() {
      currentTabIndex = index;
      switch(index) {
        case 0: { _title = 'BraidWinner';}
        break;
        case 1: { _title = 'Booking';}
        break;
        case 2: { _title = 'Support';}
        break;
        case 3: { _title = ' My Profile';}
        break;
      }
    });
  }
}
