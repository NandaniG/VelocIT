

// import 'dart:convert';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart'as http;
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:velocit/pages/Activity/Product_Activities/ProductDetails_activity.dart';
// import 'package:velocit/utils/constants.dart';
// import 'package:velocit/utils/styles.dart';
// import 'package:velocit/widgets/global/textFormFields.dart';
//
// import 'Core/AppConstant/apiMapping.dart';
// import 'Core/Model/FindProductBySubCategoryModel.dart';
// import 'Core/ViewModel/product_listing_view_model.dart';
// import 'Core/data/responses/status.dart';
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final _baseUrl = 'https://jsonplaceholder.typicode.com/posts';
//
//   int _page = 0;
//
//   final int _limit = 20;
//
//   bool _isFirstLoadRunning = false;
//   bool _hasNextPage = true;
//
//   bool _isLoadMoreRunning = false;
//
//   FindProductBySubCategoryModel _posts =FindProductBySubCategoryModel();
//   ProductSpecificListViewModel productSpecificListViewModel =
//   ProductSpecificListViewModel();
//
//   var url = '/product/findBySubCategoryId';
//
//   Future<FindProductBySubCategoryModel>  _loadMore() async {
//     dynamic fetchedPosts;
//
//     if (_hasNextPage == true &&
//         _isFirstLoadRunning == false &&
//         _isLoadMoreRunning == false &&
//         _controller.position.extentAfter < 300
//     ) {
//       setState(() {
//         _isLoadMoreRunning = true; // Display a progress indicator at the bottom
//       });
//
//       _page += 1; // Increase _page by 1
//
//       Map<String, String> productData = {
//         'page': _page.toString(),
//         'size': _limit.toString(),
//         'sub_category_id':'4',
//       };
//
//       String queryString = Uri(queryParameters: productData).query;
//
//       var requestUrl = ApiMapping.BaseAPI +url + '?' + queryString!;
//       try {
//         final res =
//         await http.get(Uri.parse(requestUrl));
//
//         fetchedPosts = json.decode(res.body);
//         if (kDebugMode) {
//           print('fetchedPosts'+fetchedPosts.length.toString());
//         }
//         if (fetchedPosts.isNotEmpty) {
//           setState(() {            fetchedPosts = FindProductBySubCategoryModel.fromJson(fetchedPosts);
//
//           _posts = FindProductBySubCategoryModel.fromJson(fetchedPosts) ;
//             _posts.payload!.content!.addAll(fetchedPosts);
//           });
//         } else {
//
//           setState(() {
//             _hasNextPage = false;
//           });
//         }
//       } catch (err) {
//         if (kDebugMode) {
//           print('Something went wrong!');
//         }
//       }
//
//
//       setState(() {
//         _isLoadMoreRunning = false;
//       });
//     }return fetchedPosts= FindProductBySubCategoryModel.fromJson(fetchedPosts);
//
//   }
//
//   Future<FindProductBySubCategoryModel> _firstLoad() async {
//     dynamic res;
//     setState(() {
//       _isFirstLoadRunning = true;
//     });
//
//     try {
//       Map<String, String> productData = {
//         'page': '0',
//         'size': '10',
//         'sub_category_id': '4',
//       };
//
//       String queryString = Uri(queryParameters: productData).query;
//
//       var requestUrl = ApiMapping.BaseAPI + url + '?' + queryString!;
//       res = await http.get(Uri.parse(requestUrl));
//       setState(() {
//         dynamic responseJson = jsonDecode(res.body);
//         // print('Something went wrong..'+responseJson .toString());
//         _posts = json.decode(res.body);
//         // res = FindProductBySubCategoryModel.fromJson(responseJson);
//         print('Something went wrong..' + res.toString());
//       });
//
//       return res;
//     } catch (err) {
//       if (kDebugMode) {
//         print('Something went wrong');
//       }
//       print(err.toString());
//       setState(() {
//         _isFirstLoadRunning = false;
//       });
//
//       throw err.toString();
//     }
//   }
//
//   late ScrollController _controller;
//   @override
//   void initState() {
//     super.initState();
//     _firstLoad();
//     _controller = ScrollController()..addListener(_loadMore);
//         productSpecificListViewModel.productBySubCategoryWithGet(
//           0,
//           4,
//         4,
//         );
//   }
//   final indianRupeesFormat = NumberFormat.currency(
//     name: "INR",
//     locale: 'en_IN',
//     decimalDigits: 0, // change it to get decimal places
//     symbol: '₹',
//   );
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Your news', style: TextStyle(fontFamily: 'Roboto',color: Colors.white),),
//         ),
//         body:_isFirstLoadRunning?const Center(
//           child: CircularProgressIndicator(),
//         ):Column(
//           children: [
//             FutureBuilder(future: _firstLoad(),
//               builder: (context,dfs) {
//                 return Expanded(
//                   child: ListView.builder(
//                     itemCount: _posts.payload!.content!.length,
//                     controller: _controller,
//                     itemBuilder: (_, index) => Card(
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 8, horizontal: 10),
//                       child: ListTile(
//                         title: Text(_posts.payload!.content![index].shortName!),
//                         subtitle: Text(_posts.payload!.content![index].productCode!),
//                       ),
//                     ),
//                   ),
//                 );
//               }
//             ),
//             if (_isLoadMoreRunning == true)
//               const Padding(
//                 padding: EdgeInsets.only(top: 10, bottom: 40),
//                 child: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               ),
//
//             if (_hasNextPage == false)
//               Container(
//                 padding: const EdgeInsets.only(top: 30, bottom: 40),
//                 color: Colors.amber,
//                 child: const Center(
//                   child: Text('You have fetched all of the content'),
//                 ),
//               ),
//           ],
//         )
//     );
//   }
//   Widget productListView() {
//     return LayoutBuilder(builder: (context, constrains) {
//       return ChangeNotifierProvider<ProductSpecificListViewModel>.value(
//         value:  productSpecificListViewModel,
//         child: Consumer<ProductSpecificListViewModel>(
//             builder: (context, productSubCategoryProvider, child) {
//               switch (productSubCategoryProvider.productSubCategory.status) {
//                 case Status.LOADING:
//                   print("Api load");
//
//                   return TextFieldUtils().circularBar(context);
//                 case Status.ERROR:
//                   print("Api error");
//
//                   return Text(productSubCategoryProvider
//                       .productSubCategory.message
//                       .toString());
//                 case Status.COMPLETED:
//                   print("Api calll");
//                   List<Content>? subProductList = productSubCategoryProvider
//                       .productSubCategory.data!.payload!.content;
//                   print("subProductList length.......${subProductList!.length}");
//                   return Container(
//                     height: MediaQuery.of(context).size.height,
//                     // width: MediaQuery.of(context).size.width,
//                     child: Stack(
//                       children: [
//                         GridView.builder(
//                           itemCount: subProductList!.length,
//                           // physics:  AlwaysScrollableScrollPhysics(),
//                           gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             mainAxisSpacing: 30,
//                             crossAxisSpacing: 10,
//                             // width / height: fixed for *all* items
//                             childAspectRatio: 0.75,
//
//                             crossAxisCount: 2,
//                           ),
//                           itemBuilder: (BuildContext context, int index) {
//                             if (index < 100) {
//                               return InkWell(
//                                 onTap: () {
//                                   print(
//                                       "Id ........${subProductList[index].id}");
//
//                                   Navigator.of(context).push(
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           ProductDetailsActivity(
//                                             id: subProductList[index].id,
//                                             // productList: subProductList[index],
//                                             // productSpecificListViewModel:
//                                             //     productSpecificListViewModel,
//                                           ),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                     decoration: const BoxDecoration(
//                                         color: ThemeApp.tealButtonColor,
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(10))),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                           flex: 2,
//                                           child: Container(
//                                             height: SizeConfig
//                                                 .orientations !=
//                                                 Orientation.landscape
//                                                 ? MediaQuery.of(context)
//                                                 .size
//                                                 .height *
//                                                 .25
//                                                 : MediaQuery.of(context)
//                                                 .size
//                                                 .height *
//                                                 .1,
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width,
//                                             decoration: const BoxDecoration(
//                                                 color: ThemeApp.whiteColor,
//                                                 borderRadius:
//                                                 BorderRadius.only(
//                                                   topRight:
//                                                   Radius.circular(10),
//                                                   topLeft:
//                                                   Radius.circular(10),
//                                                 )),
//                                             child: ClipRRect(
//                                               borderRadius:
//                                               const BorderRadius.only(
//                                                 topRight:
//                                                 Radius.circular(10),
//                                                 topLeft:
//                                                 Radius.circular(10),
//                                               ),
//                                               child: Image.network(
//                                                 subProductList[index]
//                                                     .imageUrls![0]
//                                                     .imageUrl!,
//                                                 // fit: BoxFit.fill,
//                                                 height: (MediaQuery.of(
//                                                     context)
//                                                     .orientation ==
//                                                     Orientation
//                                                         .landscape)
//                                                     ? MediaQuery.of(context)
//                                                     .size
//                                                     .height *
//                                                     .26
//                                                     : MediaQuery.of(context)
//                                                     .size
//                                                     .height *
//                                                     .1,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           // flex: 1,
//                                           child: Container(
//                                             padding: const EdgeInsets.only(
//                                                 left: 12, right: 12),
//                                             child: Column(
//                                               mainAxisAlignment:
//                                               MainAxisAlignment
//                                                   .spaceAround,
//                                               crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                     subProductList[index]
//                                                         .shortName!,
//                                                     style: TextStyle(fontFamily: 'Roboto',
//                                                         color: ThemeApp
//                                                             .whiteColor,
//                                                         fontSize:
//                                                         MediaQuery.of(context).size.height * .022,
//                                                         fontWeight:
//                                                         FontWeight
//                                                             .w400)),
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                                   children: [
//                                                     TextFieldUtils().dynamicText(
//                                                         indianRupeesFormat.format(
//                                                             subProductList[
//                                                             index]
//                                                                 .defaultSellPrice ??
//                                                                 0.0),
//                                                         context,
//                                                         TextStyle(fontFamily: 'Roboto',
//                                                             color: ThemeApp
//                                                                 .whiteColor,
//                                                             fontSize:
//                                                             MediaQuery.of(context).size. height *
//                                                                 .023,
//                                                             fontWeight:
//                                                             FontWeight
//                                                                 .w500)),
//                                                     TextFieldUtils().dynamicText(
//                                                         indianRupeesFormat.format(
//                                                             subProductList[
//                                                             index]
//                                                                 .defaultMrp ??
//                                                                 0.0),
//                                                         context,
//                                                         TextStyle(fontFamily: 'Roboto',
//                                                             color: ThemeApp
//                                                                 .whiteColor,
//                                                             decoration:
//                                                             TextDecoration
//                                                                 .lineThrough,
//                                                             fontSize:
//                                                             MediaQuery.of(context).size. height *
//                                                                 .022,
//                                                             fontWeight:
//                                                             FontWeight
//                                                                 .bold)),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     )),
//                               );
//                             } else {
//                               return Container(
//                                 // width: constrains.minWidth,
//                                 height: 80,
//                                 // height: MediaQuery.of(context).size.height * .08,
//                                 // alignment: Alignment.center,
//                                 child: TextFieldUtils().dynamicText(
//                                     'Nothing more to load',
//                                     context,
//                                     TextStyle(fontFamily: 'Roboto',
//                                         color: ThemeApp.blackColor,
//                                         fontSize:        MediaQuery.of(context).size.height * .03,
//                                         fontWeight: FontWeight.bold)),
//                               );
//                             }
//                           },
//                         ),
//
//
//                       ],
//                     ),
//                   );
//               }
//               return Container(
//                 height:        MediaQuery.of(context).size.height * .08,
//                 alignment: Alignment.center,
//                 child: Center(
//                     child: Text(
//                       "Match not found",
//                       style: TextStyle(fontSize: 20),
//                     )),
//               );
//             }),
//       );
//     });
//   }
//
// }
