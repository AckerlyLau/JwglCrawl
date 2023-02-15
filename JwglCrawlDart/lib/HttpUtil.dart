import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio/dio.dart';
import 'api.dart';

class HttpUtil {
  //BaseOptions 基类请求配置
  //Options单次请求配置
  //RequestOptions实际请求配置

  BaseOptions options = BaseOptions(
    //请求基地址，可以包含子路径
    baseUrl: API.mobileLoginUrl,
    //合法的返回状态值
    validateStatus: (status) {
      return status != null && status < 405;
      // return true;
    },

    //连接服务器超时时间，单位是毫秒
    connectTimeout: 10000,
    //响应流上前后两次接受数据的间隔，单位为毫秒
    receiveTimeout: 5000,
    sendTimeout: 5000,
    //Http请求头
    headers: {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36 Edg/110.0.1587.41',
      'Accept-Encoding': "gzip, deflate, br",
      'Accept': "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
      'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
    },
    //请求的Content-Type
    contentType: Headers.formUrlEncodedContentType,
    //表示期望以哪种格式(方式)接受响应数据，接受4种数据类型 json stream plain bytes,默认值json
    responseType: ResponseType.json,
  );
  Dio dio = Dio();
  CookieJar cookieJar = CookieJar();
  CancelToken calaelToken = CancelToken();

  HttpUtil() {
    dio = Dio(options);
    // dio = Dio(options);
    dio.interceptors.add(CookieManager(cookieJar));
  }

  setToken(token) {
    dio.options.headers["token"] = token;
  }

  ///get请求
  ///url：请求地址
  ///data：请求参数
  ///options：请求配置
  ///cancelToken：取消标识
  get(url, {data}) async {
    try {
      Response response = await dio.get(url, queryParameters: data
          // , options: options, cancelToken: cancelToken
          );
      print(await cookieJar.loadForRequest(Uri.parse(url)));

      print('get success--------${response.statusCode}');
      print('get success--------${response.data}');

      //response.data;//响应体
      //response.headers;//响应头
      //response.request;//请求体
      //response.statusCode;//状态码
      return response;
    } on DioError catch (e) {
      print('get error----------#$e');
      formatError(e);
      rethrow;
    }
  }

  //添加cookie
  addCookie(String name, String value) {
    dio.interceptors.add(CookieManager(CookieJar()));
  }

  ///post请求
  post(url, {data, options, cancelToken}) async {
    Response? response;
    try {
      Response response = await dio.post(url, queryParameters: data
          // , options: options, cancelToken: cancelToken
          );
      print('post success--------${response.statusCode}');
      print('post success----------${response.data}');

      //response.headers.forEach(f){

      //}
      //dio.interceptors.add(CookieManager(response.headers.))
      return response;
    } on DioError catch (e) {
      print('post error----------$e');
      formatError(e);
      rethrow;
    }
  }

  void clearCookie() {
    dio.interceptors.clear();
    dio.close();
    print("cookie清理完成");
  }

  /*
   * error统一处理
   */
  void formatError(DioError e) {
    if (e.type == DioErrorType.connectTimeout) {
      // It occurs when url is opened timeout.
      print("连接超时");
    } else if (e.type == DioErrorType.sendTimeout) {
      // It occurs when url is sent timeout.
      print("请求超时");
    } else if (e.type == DioErrorType.receiveTimeout) {
      //It occurs when receiving timeout
      print("响应超时");
    } else if (e.type == DioErrorType.response) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
    } else if (e.type == DioErrorType.cancel) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误");
    }
  }
}
