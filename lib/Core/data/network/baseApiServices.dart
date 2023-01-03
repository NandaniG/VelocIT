abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url);

  Future<dynamic> getPostApiResponse(String url, dynamic data);
  Future<dynamic> getGetApiResponseWithBody(String url, dynamic data);

  Future<dynamic> getPutApiResponse(String url, dynamic data);
}
