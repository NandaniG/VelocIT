import 'package:flutter/material.dart';
import 'package:velocit/Core/Model/ProductCategoryModel.dart';

import '../../../../utils/styles.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/textFormFields.dart';
import '../../Product_Activities/Products_List.dart';

class AllProductDetailScreen extends StatefulWidget {
  final ProductList productList;

  AllProductDetailScreen({Key? key, required this.productList}) : super(key: key);

  @override
  State<AllProductDetailScreen> createState() => _AllProductDetailScreenState();
}

class _AllProductDetailScreenState extends State<AllProductDetailScreen> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;  return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .12),
        child: AppBarWidget(
          context:    context,
          titleWidget:    searchBar(context),
          location: const AddressWidgets(),     ),
      ),
      bottomNavigationBar: bottomNavigationBarWidget(context,0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(10,20,10,10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldUtils()
                  .headingTextField(widget.productList.name.toString(), context),

              SizedBox(
                height: 10,
              ),
              subListOfCategories()
            ],
          ),
        ),
      ),
    );
  }

  Widget subListOfCategories() {
   return Expanded(
      // width: MediaQuery.of(context).size.width,
      child: widget.productList.simpleSubCats!.isEmpty
          ? Center(
              child: Text(
              "Match not found",
              style: TextStyle(fontSize: 20),
            ))
          : GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 30,
                // childAspectRatio: 1.0,
                childAspectRatio: MediaQuery.of(context).size.height / 900,
              ),
              shrinkWrap: true,
              children: List.generate(
                widget.productList.simpleSubCats!.length,
                (index) {
                  return Stack(
                    children: [
                      index == widget.productList.simpleSubCats!.length
                          ? Container(
                              // width: constrains.minWidth,
                              height: 20,
                              // height: MediaQuery.of(context).size.height * .08,
                              // alignment: Alignment.center,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ThemeApp.blackColor,
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                print(
                                    "Id ........${widget.productList.simpleSubCats![index].id}");

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductListByCategoryActivity(
                                      productList: widget
                                          .productList.simpleSubCats![index],

                                      // productList: subProductList[index],
                                      // productSpecificListViewModel:
                                      //     productSpecificListViewModel,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
// height: 205,
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /*   Expanded(
                                            flex: 2,
                                            child:*/
                                  Container(
                                    height: 143,
                                    width: 191,
                                    /* height: SizeConfig.orientations !=
                                                      Orientation.landscape
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .25
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .1,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,*/
                                    decoration: const BoxDecoration(
                                      color: ThemeApp.whiteColor,
                                    ),
                                    child: ClipRRect(
                                      child: widget
                                              .productList
                                              .simpleSubCats![index]
                                              .imageUrl!
                                              .isNotEmpty
                                          ? Image.network(
                                              widget
                                                  .productList
                                                  .simpleSubCats![index]

                                                  .imageUrl!,
                                              // fit: BoxFit.fill,
                                              height: (MediaQuery.of(context)
                                                          .orientation ==
                                                      Orientation.landscape)
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .26
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .1,
                                            )
                                          : SizedBox(
                                              // height: height * .28,
                                              width: MediaQuery.of(context).size.width,
                                              child: Icon(
                                                Icons.image_outlined,
                                                size: 50,
                                              )),
                                    ),
                                  ),
                                  // ),
                                  Container(
                                    color: ThemeApp.tealButtonColor,
                                    width: 191,
                                    height: 46,
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFieldUtils()
                                            .listNameHeadingTextField(
                                            widget
                                                .productList
                                                .simpleSubCats![index]
                                                    .name!,
                                                context),
                                        SizedBox(height: 10),

                                      ],
                                    ),
                                  ),
                                ],
                              )),
                            ),
                      index == widget
                          .productList
                          .simpleSubCats!.length
                          ? Container(
                              // width: constrains.minWidth,
                              height: 20,
                              // height: MediaQuery.of(context).size.height * .08,
                              // alignment: Alignment.center,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ThemeApp.blackColor,
                                ),
                              ),
                            )
                          : SizedBox()
                    ],
                  );
                  /*else {
                        return  Container(
                          // width: constrains.minWidth,
                          height: 80,
                          // height: MediaQuery.of(context).size.height * .08,
                          // alignment: Alignment.center,
                          child: TextFieldUtils().dynamicText(
                              'Nothing more to load',
                              context,
                              TextStyle(fontFamily: 'Roboto',
                                  color: ThemeApp.blackColor,
                                  fontSize: height * .03,
                                  fontWeight: FontWeight.bold)),
                        );
                      }*/
                },
              )),
    );
  }

}
