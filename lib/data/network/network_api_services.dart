import 'dart:convert';
import 'dart:io';

import 'package:hire_mate/data/network/base_api_services.dart';
import 'package:hire_mate/data/network_exception.dart';
import 'package:http/http.dart' as http;

class NetworkApiServices extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 3));
      responseJson = returnResponse(response);
    } on SocketException {
      //on socketexception is an internet exception
      throw FetchDataExceptions("No Internet Connection");
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responsejson = jsonDecode(response.body);
        return responsejson;
//another type exception with status code 400
      case 400:
        throw BadRequestException(response.statusCode.toString());
      case 500:
        throw InvalidinputException(response.statusCode.toString());
      default:
        throw FetchDataExceptions(
            // ignore: prefer_adjacent_string_concatenation
            "Error Occured While communicating with ServerWith status code${response.statusCode}");
    }
  }
}
