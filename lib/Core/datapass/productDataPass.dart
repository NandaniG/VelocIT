class ProductDataPass {
  final String fromScreen;
  final int productCategoryId;
  final int productSpecificId;
  final String searchText;
  final int serviceCategoryId;
  final int serviceSpecificId;

  ProductDataPass(
      this.fromScreen, this.productCategoryId, this.productSpecificId, this.searchText, this.serviceCategoryId, this.serviceSpecificId);
}

class NavigationScreen {
  //for productdetail route
  static const String fromDashboardRoute = 'fromDashboardRoute';
  static const String fromProductListingRoute = 'fromProductListingRoute';
  static const String fromOfferPageListingRoute = 'fromOfferPageListingRoute';
  static const String fromSearchListingRoute = 'fromOfferListingRoute';

  //service list

  static const String fromServiceListingRoute = 'fromServiceListingRoute';

}
