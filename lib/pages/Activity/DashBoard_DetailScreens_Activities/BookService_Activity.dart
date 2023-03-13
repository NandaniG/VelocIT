// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:velocit/Core/Model/FindProductBySubCategoryModel.dart';
//
// import '../../../Core/Model/CategoriesModel.dart';
// import '../../../Core/Model/ProductCategoryModel.dart';
// import '../../../Core/ViewModel/dashboard_view_model.dart';
// import '../../../Core/ViewModel/product_listing_view_model.dart';
// import '../../../Core/data/responses/status.dart';
// import '../../../Core/datapass/productDataPass.dart';
// import '../../../services/models/ProductDetailModel.dart';
// import '../../../services/models/demoModel.dart';
// import '../../../services/providers/Products_provider.dart';
// import '../../../utils/constants.dart';
// import '../../../utils/styles.dart';
// import '../../../widgets/global/appBar.dart';
// import '../../../widgets/global/textFormFields.dart';
//
// import '../../homePage.dart';
// import '../../screens/dashBoard.dart';
// import '../Product_Activities/Products_List.dart';
//
// class BookServiceActivity extends StatefulWidget {
//   List<ProductList>? shopByCategoryList;
//   final int shopByCategorySelected;
//
//   BookServiceActivity({
//     Key? key,
//     required this.shopByCategoryList,
//     required this.shopByCategorySelected,
//   }) : super(key: key);
//
//   @override
//   State<BookServiceActivity> createState() => _BookServiceActivityState();
// }
//
// class _BookServiceActivityState extends State<BookServiceActivity> {
//   int selected = 0;
//   double height = 0.0;
//   double width = 0.0;
//   GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
//   ProductSpecificListViewModel productViewModel =
//       ProductSpecificListViewModel();
//   Map data = {
//     "category_code": "EOLP",
//     "recommended_for_you": "1",
//     "Merchants Near You": "1",
//     "best_deal": "",
//     'budget_buys': ""
//   };
//
//   var productList;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     productViewModel.productBySubCategoryWithGet(
//         0, 10, widget.shopByCategoryList![widget.shopByCategorySelected].id!);
//     print(widget.shopByCategoryList![widget.shopByCategorySelected].id!);
//     selected = widget.shopByCategorySelected;
//     // productViewModel.productSpecificListWithGet(context,data);
//
//     super.initState();
//   }
//
//   Future<List<Payloads>> getImageSlide() async {
//     String response = '['
//         '{"sponsorlogo":"assets/images/laptopImage.jpg"},'
//         '{"sponsorlogo":"assets/images/iphones_Image.jpg"},'
//         '{"sponsorlogo":"assets/images/laptopImage2.jpg"}]';
//     var payloadList = payloadFromJson(response);
//     return payloadList;
//   }
//
//   bool isExpand = false;
//
//   @override
//   Widget build(BuildContext context) {
//     height = MediaQuery.of(context).size.height;
//     width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       key: scaffoldGlobalKey,
//       backgroundColor: ThemeApp.appBackgroundColor,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(height * .135),
//         child: AppBarWidget(
//           context: context,
//           titleWidget: searchBarWidget(),
//           location: const AddressWidgets(),
//         ),
//       ),
//       bottomNavigationBar: bottomNavigationBarWidget(context, 0),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Consumer<ProductProvider>(builder: (context, product, _) {
//             return Container(
//               padding: const EdgeInsets.only(
//                 left: 10,
//                 right: 10,
//               ),
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     imageLists(),
//                     // carouselImages(),
//                     SizedBox(
//                       height: height * .02,
//                     ),
//                     TextFieldUtils()
//                         .headingTextField('Shop by Categories', context),
//                     SizedBox(
//                       height: height * .02,
//                     ),
//                     ListView.builder(
//                       key: Key('builder ${selected.toString()}'),
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: widget.shopByCategoryList!.length,
//                       itemBuilder: (context, index) {
//                         return Card(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           margin: const EdgeInsets.symmetric(
//                               horizontal: 5, vertical: 5),
//                           child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 ExpansionTile(
//                                   key: Key(index.toString()),
//                                   onExpansionChanged: ((newState) {
//                                     if (newState) {
//                                       setState(() {
//                                         const Duration(seconds: 20000);
//                                         selected = index;
//                                       });
//                                     } else {
//                                       setState(() {
//                                         selected = -1;
//                                       });
//                                     }
//                                   }),
//                                   initiallyExpanded: index == selected,
//                                   trailing: Icon(
//                                     Icons.keyboard_arrow_down,
//                                     color: ThemeApp.textFieldBorderColor,
//                                     size: height * .05,
//                                   ),
//                                   tilePadding: const EdgeInsets.symmetric(
//                                       horizontal: 20, vertical: 5),
//                                   childrenPadding: const EdgeInsets.symmetric(
//                                       horizontal: 20, vertical: 10),
//                                   textColor: Colors.black,
//                                   title: Row(
//                                     children: [
//                                       CircleAvatar(
//                                         child: ClipRRect(
//                                           borderRadius: const BorderRadius.all(
//                                               Radius.circular(50)),
//                                           child: Image.network(
//                                             widget.shopByCategoryList![index]
//                                                 .productCategoryImageId!,
//                                             // fit: BoxFit.fill,
//                                             height: MediaQuery.of(context)
//                                                     .size
//                                                     .height *
//                                                 .07,
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: width * .03,
//                                       ),
//                                       categoryListFont(
//                                           widget
//                                               .shopByCategoryList![index].name!,
//                                           context)
//                                     ],
//                                   ),
//                                   expandedAlignment: Alignment.centerLeft,
//                                   expandedCrossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                   children: [
//                                     subListOfCategories(
//                                         widget.shopByCategoryList![index])
//                                   ],
//                                 ),
//                               ]),
//                         );
//                       },
//                     )
//                   ]),
//             );
//           }),
//         ),
//       ),
//     );
//   }
//
//   Widget categoryListFont(String text, BuildContext context) {
//     return Text(
//       text,
//       style: TextStyle(
//           fontFamily: 'Roboto',
//           fontSize: 16,
//           overflow: TextOverflow.ellipsis,
//           fontWeight: FontWeight.w700,
//           letterSpacing: -0.25,
//           color: ThemeApp.primaryNavyBlackColor),
//     );
//   }
//
//   Widget subCategoryListFont(String text, BuildContext context) {
//     return Text(
//       text,
//       style: TextStyle(
//           fontFamily: 'Roboto',
//           fontSize: 13,
//           overflow: TextOverflow.ellipsis,
//           fontWeight: FontWeight.w500,
//           letterSpacing: -0.25,
//           color: ThemeApp.primaryNavyBlackColor),
//     );
//   }
//
//   Widget imageLists() {
//     return FutureBuilder<List<Payloads>>(
//         future: getImageSlide(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) print(snapshot.error);
//           return snapshot.hasData
//               ? Container(
//                   height: (MediaQuery.of(context).orientation ==
//                           Orientation.landscape)
//                       ? height * .5
//                       : height * 0.2,
//                   width: width,
//                   child: CarouselSlider(
//                     items: snapshot.data?.map((e) {
//                       return Card(
//                         margin: EdgeInsets.zero,
//                         shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                         ),
//                         color: ThemeApp.whiteColor,
//                         child: ClipRRect(
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(10)),
//                             child: Container(
//                               width: width,
//                               color: Colors.white,
//                               child: Image.asset(
//                                 e.sponsorlogo,
//                                 fit: BoxFit.fill,
//                               ),
//                             )),
//                       );
//                     }).toList(),
//                     options: CarouselOptions(
//                         autoPlay: false,
//                         viewportFraction: 1,
//                         height: height * .3),
//                   ))
//               : const Center(child: CircularProgressIndicator());
//         });
//   }
//
//   Widget subListOfCategories(ProductList productList) {
//     return Container(
//         height: 300,
//         width: double.infinity,
//         alignment: Alignment.center,
//         color: ThemeApp.whiteColor,
//         child: /*ListView.builder(
//           shrinkWrap: true,
//           scrollDirection: Axis.horizontal,
//           itemCount: productList!.simpleSubCats!.length,*/
//             GridView.builder(
//           itemCount: productList.simpleSubCats!.length,
//           scrollDirection: Axis.vertical,
//           gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//               maxCrossAxisExtent: 150,
//               childAspectRatio: 3 / 2.5,
//               crossAxisSpacing: 20,
//               mainAxisSpacing: 20),
//           itemBuilder: (BuildContext context, int index) {
//             return InkWell(
//               onTap: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => ProductListByCategoryActivity(),
//                   settings: RouteSettings(
//                       arguments: ProductDataPass(
//                           productList.simpleSubCats![index].id ?? 0,
//                           productList.simpleSubCats![index].id ?? 0)),
//                 ));
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 8.0, bottom: 8),
//                 child: Container(
//                     // width: width * .25,
//                     width: 98,
//                     height: 59,
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                             color: ThemeApp.containerColor, width: 1.5),
//                         color: ThemeApp.containerColor),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: CircleAvatar(
//                                 radius: 30,
//                                 backgroundImage: NetworkImage(productList
//                                     .simpleSubCats![index].imageUrl!),
//                               ) ??
//                               SizedBox(),
//                           /* ClipRRect(
//                           borderRadius: const BorderRadius.all(
//                               Radius.circular(50)),
//                           child: Image.network(
//                             productList.simpleSubCats![index]
//                                 .imageUrl! ??
//                                 '',
//                             fit: BoxFit.fill,
//                             height:
//                             MediaQuery.of(context).size.height *
//                                 .07,
//                           )??SizedBox(),
//                         ),*/
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: Center(
//                             child: subCategoryListFont(
//                                 productList.simpleSubCats![index].name!,
//                                 context),
//                           ),
//                         )
//                       ],
//                     )),
//               ),
//             );
//           },
//         ));
//
//     /*Container(
//         height: 200,
//         alignment: Alignment.center,color: ThemeApp.whiteColor,
//         child: GridView.builder(
//           itemCount: productList!.simpleSubCats!.length,
//           physics: const AlwaysScrollableScrollPhysics(),
//           gridDelegate:
//           const SliverGridDelegateWithFixedCrossAxisCount(
//             mainAxisSpacing: 20,
//             crossAxisSpacing: 10,
//             childAspectRatio: 1.5,
//             crossAxisCount: 3,
//           ),
//           itemBuilder: (BuildContext context, int index) {
//             return InkWell(
//               onTap: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => ProductListByCategoryActivity(
//                       productList: productList!.simpleSubCats![index]),
//                 ));
//               },
//               child: Container(
//                   padding: const EdgeInsets.all(3.0),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                         color: ThemeApp.containerColor,
//                         width: 1.5),color: ThemeApp.containerColor
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: ClipRRect(
//                           borderRadius: const BorderRadius.all(
//                               Radius.circular(50)),
//                           child: Image.network(
//                             productList.simpleSubCats![index]
//                                 .imageUrl! ??
//                                 '',
//                             fit: BoxFit.fill,
//                             height:
//                             MediaQuery.of(context).size.height *
//                                 .07,
//                           )??SizedBox(),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Center(
//                           child: TextFieldUtils().dynamicText(
//                               productList.simpleSubCats![index].name!,
//                               context,
//                               TextStyle(fontFamily: 'Roboto',
//                                 color: ThemeApp.blackColor,
//                                 // fontWeight: FontWeight.w500,
//                                 fontSize: height * .02,
//                               )),
//                         ),
//                       )
//                     ],
//                   )),
//             );
//           },
//         ));*/
//   }
//
// /*
//   Widget subListOfCategories(ProductList productList) {
//     return Container(
//         height: 230,
//         alignment: Alignment.center,
//         child: GridView.builder(
//           itemCount: productList!.simpleSubCats!.length,
//           physics: const AlwaysScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             mainAxisSpacing: 20,
//             crossAxisSpacing: 10,
//             childAspectRatio: 1.1,
//             crossAxisCount: 3,
//           ),
//           itemBuilder: (BuildContext context, int index) {
//             return InkWell(
//               onTap: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => ProductListByCategoryActivity(
//                       productList: productList!.simpleSubCats![index]),
//                 ));
//               },
//               child: Container(
//                   padding: const EdgeInsets.all(3.0),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                         color: ThemeApp.textFieldBorderColor, width: 1.5),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: CircleAvatar(
//                           child: ClipRRect(
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(50)),
//                             child: Image.network(
//                                   productList.simpleSubCats![index].imageUrl! ??
//                                       '',
//                                   fit: BoxFit.fill,
//                                   // height:
//                                   //     MediaQuery.of(context).size.height * .07,
//                                 ) ??
//                                 SizedBox(),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Center(
//                           child: TextFieldUtils().dynamicText(
//                               productList.simpleSubCats![index].name!,
//                               context,
//                               TextStyle(fontFamily: 'Roboto',
//                                 color: ThemeApp.darkGreyColor,
//                                 // fontWeight: FontWeight.w500,
//                                 fontSize: height * .02,
//                               )),
//                         ),
//                       )
//                     ],
//                   )),
//             );
//           },
//         ));
//
// */
// /*
//     return ChangeNotifierProvider<ProductSpecificListViewModel>(
//         value:  productViewModel,
//
//     child: Consumer<ProductSpecificListViewModel>(
//     builder: (context, productSubCategories, child) {
//             return Container(
//                 height: 250,
//                 alignment: Alignment.center,
//                 child: GridView.builder(
//                   itemCount: widget.shopByCategoryList!.length,
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   gridDelegate:
//                   const SliverGridDelegateWithFixedCrossAxisCount(
//                     mainAxisSpacing: 10,
//                     crossAxisSpacing: 10,
//                     childAspectRatio: 1,
//                     crossAxisCount: 3,
//                   ),
//                   itemBuilder: (BuildContext context, int index) {
//                     return InkWell(
//                       onTap: () {
//
//                         // Navigator.of(context).push(
//                         //   MaterialPageRoute(
//                         //     builder: (context) =>
//                         //         ProductListByCategoryActivity(productList: widget.shopByCategoryList![index],
//                         //         ),
//                         //   ),
//                         // );
//                       },
//                       child: Container(
//                           padding: const EdgeInsets.all(2.0),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(
//                                 color: ThemeApp.textFieldBorderColor,
//                                 width: 1.5),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.only(bottom: 1.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//
//                                 ClipRRect(
//                                   borderRadius: const BorderRadius.all(
//                                       Radius.circular(50)),
//                                   child: Image.network(
//                                     // width: double.infinity,
//                                     widget
//                                         .shopByCategoryList![index].productCategoryImageId!,                                  fit: BoxFit.fill,
//
//                                     height: MediaQuery.of(context)
//                                         .size
//                                         .height *
//                                         .07,
//                                   ),
//                                 ),
//
//                                 SizedBox(
//                                   height:
//                                   MediaQuery.of(context).size.height *
//                                       .01,
//                                 ),TextFieldUtils().dynamicText(
//                                     widget.shopByCategoryList![index].name!,
//                                     context,
//                                     TextStyle(fontFamily: 'Roboto',
//                                       color: ThemeApp.darkGreyColor,
//                                       // fontWeight: FontWeight.w500,
//                                       fontSize: height * .02,
//                                     )),
//                                 */ /*
//
// */
// /*  Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 60.0,
//                                           height: 60.0,
//                                           decoration: const BoxDecoration(
//                                             shape: BoxShape.circle,color: Colors.cyanAccent
//                                           ),
//                                           child: Image.network(
//                                             widget
//                                                 .shopByCategoryList![index].imageUrl!,
//                                             fit: BoxFit.fitWidth,
//                                             // height:
//                                             //     MediaQuery.of(context).size.height *
//                                             //         .07,
//                                           ),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         // flex: 1,
//                                         child: TextFieldUtils().dynamicText(
//                                             widget
//                                                 .shopByCategoryList![index].name!,
//                                             context,
//                                             TextStyle(fontFamily: 'Roboto',
//                                               color: ThemeApp.darkGreyColor,
//                                               // fontWeight: FontWeight.w500,
//                                               fontSize: height * .02,
//                                             )),
//                                       )*/ /*
//  */
// /*
//
//                               ],
//                             ),
//                           )),
//                     );
//                   },
//                 ));
//           }
//     )
//     );
// */ /*
//
//   }
// */
// }
