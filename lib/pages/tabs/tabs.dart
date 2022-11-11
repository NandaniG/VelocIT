// import 'package:flutter/material.dart';
//
// import '../../utils/styles.dart';
//
// class Tabs extends StatelessWidget {
//   final List _tabIcons;
//   final int activeIndex;
//   final ValueChanged<int> onTabChanged;
//
//   const Tabs({
//     Key? key,
//     required List tabIcons,
//     required this.activeIndex,
//     required this.onTabChanged,
//   })  : _tabIcons = tabIcons,
//         super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       height: 65,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             offset: Offset(0, 0),
//             color: ThemeApp.darkGreyTab,
//             blurRadius: 0,
//           ),
//         ],
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(10),
//           topRight: Radius.circular(10),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: List.generate(_tabIcons.length, (index) {
//           return NavBarItem(
//             icon: _tabIcons[index],
//             index: index,
//             activeIndex: activeIndex,
//             onTabChanged: onTabChanged,
//           );
//         }),
//       ),
//     );
//   }
// }
//
// class NavBarItem extends StatefulWidget {
//   final int index;
//   final int activeIndex;
//   final dynamic icon;
//   final ValueChanged<int> onTabChanged;
//
//   const NavBarItem({
//     Key? key,
//     required this.icon,
//     required this.index,
//     required this.activeIndex,
//     required this.onTabChanged,
//   }) : super(key: key);
//
//   @override
//   _NavBarItemState createState() => _NavBarItemState();
// }
//
// class _NavBarItemState extends State<NavBarItem>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 200),
//       lowerBound: 1,
//       upperBound: 1.3,
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void onTap() {
//     // change currentIndex to this tab's index
//     if (widget.index != widget.activeIndex) {
//       widget.onTabChanged(widget.index);
//       _controller.forward().then((value) => _controller.reverse());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: ScaleTransition(
//         scale: _controller,
//         child: widget.index == 2
//             ? null
//             : Image.asset(widget.icon['icon'],
//                 scale: 1,
//                 height: 23,
//                 color: widget.activeIndex == widget.index
//                     ? ThemeApp.blackColor
//                     : ThemeApp.darkGreyTab),
//       ),
//     );
//   }
// }
