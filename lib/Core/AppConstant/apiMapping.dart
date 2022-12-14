import '../Enum/apiEndPointEnums.dart';

class ApiMapping {
  static String baseProtocol = "https";
  // static String baseDomain = "velocitapi.fulgorithmapi.com";
  static String baseDomain = "velocitapiqa.fulgorithmapi.com";
  static String basePort = "443";
  static String apiVersion = "api/v1";
  // static String username = "/v2/IAM/authenticateWithUID";
static String baseAPI = 'https://velocitapiqa.fulgorithmapi.com:443/api/v1';


  static String ConstructURI(String path) {
    return baseProtocol +
        "://" +
        baseDomain +
        ":" +
        basePort +
        "/" +
        apiVersion +
        path;
  }



  static String BASEAPI = baseProtocol +
      "://" +
      baseDomain +
      ":" +
      basePort +
      "/" +
      apiVersion;
//https://velocitapiqa.fulgorithmapi.com:443/v1/IAM/authenticate

 static String consumerBasket = '/consumerbasket/findby_consumer';

  static String getURI(apiEndPoint ep) {
    String retVal = "";

    switch (ep) {
      case apiEndPoint.signIn_authenticate_get:
        retVal = ConstructURI("/IAM/authenticate");
        break;

      // case apiEndPoint.signIn_authenticateWithUID_post:
      //   retVal = ConstructURI("/IAM/authenticateWithUID");
      //   break;

      case apiEndPoint.user_get:
        retVal = ConstructURI("/users");
        break;
      case apiEndPoint.user_post:
        retVal = ConstructURI("/users");
        break;

        case apiEndPoint.get_shopByCategories:
        retVal = ConstructURI("/categories");
        break;

      // case apiEndPoint.get_productsListing:
      //   retVal = ConstructURI("/products/specificList");
      //   break;

        case apiEndPoint.get_bookOurServices:
        retVal = ConstructURI("/serviceCategories");
        break;
        case apiEndPoint.get_products:
        retVal = ConstructURI("/products");
        break;
        case apiEndPoint.put_carts:
        retVal = ConstructURI("/carts");
///new apis
        break; case apiEndPoint.auth_signIn_using_post:
        retVal = ConstructURI("/auth/signin");
        break;
        case apiEndPoint.auth_signUp_using_post:
        retVal = ConstructURI("/auth/signup");
        break;
        case apiEndPoint.get_product_categories:
        retVal = ConstructURI("/product-category");
        break;
        // case apiEndPoint.get_product_by_sub_categories:
        // retVal = ConstructURI("/product/findBySubCategoryId");
        // break;
        case apiEndPoint.cart_create_retrive:
        retVal = ConstructURI("/cart/createOrRetrieve");
        break;
        case apiEndPoint.cart_update:
        retVal = ConstructURI("/cart/updateCart");
        break;
        case apiEndPoint.cart_by_ID:
        retVal = ConstructURI("/cart/");
        break;
        case apiEndPoint.cart_by_Embedded_ID:
        retVal = ConstructURI("/cart/embedded/");
        break;
        case apiEndPoint.send_Cart_For_Payment:
        retVal = ConstructURI("/cart/sendCartForPayment/");
        break;
        case apiEndPoint.address_list:
        retVal = ConstructURI("/address/user/");
        break;
        case apiEndPoint.add_address:
        retVal = ConstructURI("/address/user/");
        break;

        case apiEndPoint.single_product_scanner:
        retVal = ConstructURI("/product/findByFmcgCode");
        break;

        case apiEndPoint.single_product_scanner:
        retVal = ConstructURI("/product/findByFmcgCode");
        break;
        case apiEndPoint.single_product:
        retVal = ConstructURI("/product/");
        break;

      default:
        retVal = "Error";
    }
    return retVal;
  }
}
