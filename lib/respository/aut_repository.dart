import 'package:hire_mate/data/network/network_api_services.dart';

class AuthRepository {
  NetworkApiServices _apiServices = NetworkApiServices();

  Future<dynamic> loginApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
