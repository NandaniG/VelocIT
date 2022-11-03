import 'package:flutter/material.dart';

import '../../pages/screens/dashBoard.dart';
import '../../utils/constants.dart';

class BottomNavigationBarCustom extends StatefulWidget {
  @override
  _BottomNavigationBarCustomState createState() =>
      _BottomNavigationBarCustomState();
}

class _BottomNavigationBarCustomState extends State<BottomNavigationBarCustom> {
  PageController _myPage = PageController(initialPage: 0);
  late var mqHeight;

  @override
  Widget build(BuildContext context) {
    mqHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: PageView(
        controller: _myPage,
        onPageChanged: (indexScreen) {
          print('Screen to $indexScreen');
        },
        children: <Widget>[
          DashboardScreen(),
          Container(),
          Container(),
          Container(),
          Container(),
        ],
      ),
      bottomNavigationBar: bottomAppBar()/*BottomAppBar(
        child: Container(
          height: mqHeight / 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              BottomAppBarItem(
                nameItem: "Beranda",
                iconItem: Icons.home,
                onTap: () => setState(
                  () => DashboardScreen(),
                ),
              ),
              BottomAppBarItem(
                nameItem: "Berita",
                iconItem: Icons.surround_sound,
                onTap: () => setState(() => Container()),
              ),
              BottomAppBarItem(
                nameItem: "Produk",
                iconItem: Icons.category,
                onTap: () => setState(() => Container()),
              ),
              BottomAppBarItem(
                nameItem: "Kegiatan",
                iconItem: Icons.calendar_today,
                onTap: () => setState(() => Container()),
              ),
              BottomAppBarItem(
                nameItem: "Kontak",
                iconItem: Icons.contact_mail,
                onTap: () => setState(() => Container()),
              ),
            ],
          ),
        ),
        color: Colors.red,
      )*/,
    );
  }


}
bottomAppBar() {
  SizeConfig.init;
  return BottomAppBar(
    color: Colors.red,
    child: Container(
      height:  SizeConfig.screenWidth / 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          BottomAppBarItem(
            nameItem: "Beranda",
            iconItem: Icons.home,
            onTap: () => (
                  () => DashboardScreen()
            ),
          ),
          BottomAppBarItem(
            nameItem: "Berita",
            iconItem: Icons.surround_sound,
            onTap: () => (() => Container()),
          ),
          BottomAppBarItem(
            nameItem: "Produk",
            iconItem: Icons.category,
            onTap: () => (() => Container()),
          ),
          BottomAppBarItem(
            nameItem: "Kegiatan",
            iconItem: Icons.calendar_today,
            onTap: () => (() => Container()),
          ),
          BottomAppBarItem(
            nameItem: "Kontak",
            iconItem: Icons.contact_mail,
            onTap: () => (() => Container()),
          ),
        ],
      ),
    ),
  );
}
class BottomAppBarItem extends StatefulWidget {
  final String nameItem;
  final IconData iconItem;
  final VoidCallback onTap;

  BottomAppBarItem({
    this.nameItem = "Beranda",
    this.iconItem = Icons.home,
    required this.onTap,
  });

  @override
  _BottomAppBarItemState createState() => _BottomAppBarItemState();
}

class _BottomAppBarItemState extends State<BottomAppBarItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(widget.iconItem, color: Colors.white),
          Text(widget.nameItem, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
