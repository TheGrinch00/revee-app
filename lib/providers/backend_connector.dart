// ignore: use_build_context_synchronously
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:revee/providers/auth_provider.dart';
import 'package:revee/providers/feedback_provider.dart';

class BackendConnector with ChangeNotifier {
  static const stagingUrl =
      'https://umqsibuzzz.us-east-2.awsapprunner.com/revee/api';
  late AuthProvider _auth;
  late FeedbackProvider _feedback;

  void update(AuthProvider auth, FeedbackProvider feedback) {
    _auth = auth;
    _feedback = feedback;
    notifyListeners();
  }

  Future<T> getRequest<T>(
    String uri, {
    List<String>? filters,
    List<Map<String, dynamic>>? jsonFilters,
    bool isJson = false,
  }) async {
    final StringBuffer url = StringBuffer(
      "$stagingUrl/$uri?access_token=${_auth.accessToken}",
    );

    if (!isJson) {
      if (filters != null) {
        for (final filter in filters) {
          url.write("&filter$filter");
        }
      }
    } else {
      if (jsonFilters != null) {
        final filterObject = {};
        for (final jsonFilter in jsonFilters) {
          filterObject.addAll(jsonFilter);
        }
        url.write("&filter=${jsonEncode(filterObject)}");
      }
    }

    final response = await http.get(
      Uri.parse(url.toString()),
      headers: {
        "platform-identifier": "app",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as T;
    } else {
      throw Exception('Failed to Data');
    }
  }

  Future<T> getResource<T>(
    String resource, {
    List<String>? filters,
    List<Map<String, dynamic>>? jsonFilters,
    bool isJson = false,
  }) async {
    final StringBuffer url =
        StringBuffer("$stagingUrl/$resource?access_token=${_auth.accessToken}");

    if (!isJson) {
      if (filters != null) {
        for (final filter in filters) {
          url.write("&filter$filter");
        }
      }
    } else {
      if (jsonFilters != null) {
        final filterObject = {};
        for (final jsonFilter in jsonFilters) {
          filterObject.addAll(jsonFilter);
        }
        url.write("&filter=${jsonEncode(filterObject)}");
      }
    }

    final response = await http.get(
      Uri.parse(url.toString()),
      headers: {
        "platform-identifier": "app",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body as T;
    } else {
      dev.log(response.statusCode.toString());
      /*
      print(response.body);
      print(response.headers);
      print(response.reasonPhrase);
      print(response.request);
      */
      throw Exception('Failed to load resource');
    }
  }

  Future<T> getResourceWithoutHeader<T>(
    String resource, {
    List<String>? filters,
    List<Map<String, dynamic>>? jsonFilters,
    bool isJson = false,
  }) async {
    final StringBuffer url =
        StringBuffer("$stagingUrl/$resource?access_token=${_auth.accessToken}");

    if (!isJson) {
      if (filters != null) {
        for (final filter in filters) {
          url.write("&filter$filter");
        }
      }
    } else {
      if (jsonFilters != null) {
        final filterObject = {};
        for (final jsonFilter in jsonFilters) {
          filterObject.addAll(jsonFilter);
        }
        url.write("&filter=${jsonEncode(filterObject)}");
      }
    }

    final response = await http.get(
      Uri.parse(url.toString()),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body as T;
    } else {
      dev.log(response.statusCode.toString());
      /*
      print(response.body);
      print(response.headers);
      print(response.reasonPhrase);
      print(response.request);
      */
      throw Exception('Failed to load resource');
    }
  }

  Future<T> postResource<T>(String resource, Map<String, dynamic> body) async {
    //print(Uri.parse("$stagingUrl/$resource"));
    final response = await http.post(
      Uri.parse("$stagingUrl/$resource?access_token=${_auth.accessToken}"),
      headers: {
        "platform-identifier": "app",
        "Content-Type": "application/json",
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body as T;
    } else {
      throw Exception('Failed to load resource');
    }
  }

  Future<T> postResourceId<T>(
    String resource,
    Map<String, dynamic> body,
    int id,
  ) async {
    //print(Uri.parse("$stagingUrl/$resource"));
    final response = await http.post(
      Uri.parse("$stagingUrl/$resource/$id?access_token=${_auth.accessToken}"),
      headers: {
        "platform-identifier": "app",
        "Content-Type": "application/json",
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body as T;
    } else {
      throw Exception('Failed to load resource');
    }
  }

  Future<T?> postRequest<T>(
    BuildContext context,
    String uri, {
    required Map<String, dynamic> body,
  }) async {
    final response = await http.post(
      Uri.parse("$stagingUrl/$uri?access_token=${_auth.accessToken}"),
      headers: {
        "platform-identifier": "app",
        "Content-Type": "application/json",
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body as T;
    } else {
      switch (response.statusCode) {
        case 400:
          // ignore: use_build_context_synchronously
          _feedback.showFailFeedback(
            context,
            "La richiesta ha un formato errato",
          );
          break;
        case 404:
          // ignore: use_build_context_synchronously
          _feedback.showFailFeedback(
            context,
            "Alcune risorse sono inesistenti",
          );
          break;
        case 422:
          // ignore: use_build_context_synchronously
          _feedback.showFailFeedback(
            context,
            "Questi dati sono già presenti nel DataBase",
          );
          break;
        default:
          // ignore: use_build_context_synchronously
          _feedback.showFailFeedback(
            context,
            "Il server ha risposto con errore ${response.statusCode}",
          );
      }

      return null;
    }
  }

  String getImageUrl(String nameFile) {
    return "$stagingUrl/revee-storage-images/images/download/$nameFile?access_token=${_auth.accessToken}";
  }

  Future<String?> uploadImage(File picture) async {
    final FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        picture.path,
        filename: 'img.png',
      ),
    });

    final Dio dio = Dio();

    final response = await dio
        .post(
      "$stagingUrl/revee-storage-images/images/upload?access_token=${_auth.accessToken}",
      data: data,
    )
        .catchError((error) {
      dev.log(error.toString());
    });

    // ignore: unnecessary_null_comparison
    if (response == null) {
      return null;
    } else {
      return response.data['result']['files']['file'][0]['name'] as String;
    }
    /*
    final dio = Dio();
    final response = await dio
        .post(
          "$stagingUrl/revee-storage-images/images/download/$nameFile?access_token=${_auth.accessToken}",
          data: FormData.fromMap({
            'file': await MultipartFile.fromFile(
              picture.path,
              filename: nameFile,
            ), //Non lo so se funziona, copio da picture vecchia App
          }),
        )
        .catchError((e) => print(e));*/
  }

  /*
  ///Function to edit visit!!!!
  Future<T> patchResource<T>(
    String resource,
    Map<String, dynamic> body,
    int visitId,
    int sampleId,
    int productId,
  ) async {
    late http.Response response;
    //Edit visitId (no samples and products)
    if (visitId != -1) {
      if (sampleId == -2) {
        print(
          Uri.parse(
            "$stagingUrl/$resource/$productId?access_token=${_auth.accessToken}",
          ),
        );
        response = await http.delete(
          Uri.parse(
            "$stagingUrl/$resource/$productId?access_token=${_auth.accessToken}",
          ),
          headers: {
            "platform-identifier": "app",
            "Content-Type": "application/json",
          },
        );

        print("${response.statusCode}");
      } else {
        response = await http.patch(
          Uri.parse(
            "$stagingUrl/$resource/$visitId?access_token=${_auth.accessToken}",
          ),
          headers: {
            "platform-identifier": "app",
            "Content-Type": "application/json",
          },
          body: json.encode(body),
        );
      }
    } else {
      //Edit samples of visit

      //IF sampleId -1 MEANS THAT IT IS FOR PRODUCT
      if (sampleId == -1) {
        if (productId != -1) {
        } else {
          response = await http.patch(
            Uri.parse(
              "$stagingUrl/$resource/$productId?access_token=${_auth.accessToken}",
            ),
            headers: {
              "platform-identifier": "app",
              "Content-Type": "application/json",
            },
            body: json.encode(body),
          );
        }
      } else {
        // IT IS FOR SAMPLES
        response = await http.patch(
          Uri.parse(
            "$stagingUrl/$resource/$sampleId?access_token=${_auth.accessToken}",
          ),
          headers: {
            "platform-identifier": "app",
            "Content-Type": "application/json",
          },
          body: json.encode(body),
        );
      }
    }

    print("${json.encode(body)}");
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body as T;
    } else {
      throw Exception('Failed to load resource');
    }
  }*/

  Future<T> patch<T>(
    String resource,
    Map<String, dynamic> body,
    int id,
  ) async {
    final http.Response response = await http.patch(
      Uri.parse(
        "$stagingUrl/$resource/$id?access_token=${_auth.accessToken}",
      ),
      headers: {
        "platform-identifier": "app",
        "Content-Type": "application/json",
      },
      body: json.encode(body),
    );

    print(json.encode(body));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body as T;
    } else {
      throw Exception('Failed to load resource');
    }
  }

  Future<T> delete<T>(
    String resource,
    int id,
  ) async {
    print(
      Uri.parse(
        "$stagingUrl/$resource/$id?access_token=${_auth.accessToken}",
      ),
    );
    final http.Response response = await http.delete(
      Uri.parse(
        "$stagingUrl/$resource/$id?access_token=${_auth.accessToken}",
      ),
      headers: {
        "platform-identifier": "app",
        "Content-Type": "application/json",
      },
    );
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body as T;
    } else {
      throw Exception('Failed to load resource');
    }
  }
}
