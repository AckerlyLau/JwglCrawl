import 'dart:io';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import "dart:convert";
import 'package:jwgl_crawl_dart/HttpUtil.dart';
import 'package:html/parser.dart' show parse;
import 'package:jwgl_crawl_dart/api.dart';

const header = {
  'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36 Edg/110.0.1587.41',
};

class WebSpider {
  //目标URL

  String _loginToken = "";
  String _appid = "";
  String _loginSid = "";
  String _randToken = "";
  String _termData = "";
  String _qrcodeUrl = "";
  String _entranceUrl = "";
  bool _isSignedIn = false;
  final HttpUtil _httpUtil = HttpUtil();

  get loginSid => _loginSid;
  get isSignedIn => _isSignedIn;
  Future<void> getLoginPage() async {
    RegExp sidPattern = RegExp(r'sid = "(.*?)",');
    Map<String, String> tokenData = {"method": "randToken"};
    Response tokenResponse = await _httpUtil.post(API.webLoginUrl, data: tokenData);

    Map tokenJson = json.decode(tokenResponse.data);

    // String qrcodeHtmlUrl = qrcodeApiUrl + "?appid=" + tokenJson["appid"] + "&return_url=" + parse.quote(API.webReturnUrl) + "&rand_token=" + tokenJson["rand_token"] + "&embed_flag=1";
    _randToken = tokenJson["rand_token"];
    _appid = tokenJson["appid"];
    Map<String, String> qrcodeRequestJson = {
      "appid": _appid,
      "return_url": API.webLoginUrl,
      "rand_token": _randToken,
      "embed_flag": "1",
    };
    Response qrcodeResponse = await _httpUtil.get(API.webQrcodeRequestUrl, data: qrcodeRequestJson);
    RegExpMatch? match = sidPattern.firstMatch(qrcodeResponse.data);
    //断言，不符合条件就抛异常
    // 只在调试模式有用
    // assert(match != null && match![0] != null, "WebSpider-getQrCodeUrl : 正则表达式没有匹配到SID");
    if (match == null || match![0] == null) {
      throw Exception("WebSpider-getQrCodeUrl : 正则表达式没有匹配到SID");
    }
    String sidExpr = match![0]!;
    _loginSid = sidExpr.split('"')[1];
    _qrcodeUrl = "${API.webQrCodeUrl}?sid=$_loginSid";
    // 其实不用解析img标签，知道sid就行
    // //获取二维码下载链接
    // Document document = parse(qrcodeResponse.data);
    // Element? imgElement = document.querySelector("img#qrimg");
    // //断言，不符合条件抛出异常
    // assert(imgElement != null, "WebSpider-getQrCodeUrl : 未获取到登录二维码标签");
    // assert(imgElement!.attributes["src"] != null, "WebSpider-getQrCodeUrl : 二维码标签不包含地址");
    // _qrcodeUrl = API.webQrcodeBaseUrl + imgElement!.attributes["src"]!;

    //----------------DEBUG:打印获得数据-----------------------------
    print("qrcode URL:$_qrcodeUrl");
    print("sid:$_loginSid");
    print("appid:$_appid");
    print("randToken:$_randToken");
  }

  Future<bool> login() async {
    // assert(_loginSid != "", "WebSpider-login : 未获取到sid,可能还未请求登录页面");
    if (_loginSid == "") {
      throw Exception("WebSpider-login : 未获取到sid,可能还未请求登录页面");
    }
    //只检查1分钟
    for (int i = 0; i < 30; i++) {
      Map<String, String> stateData = {"sid": _loginSid};
      print("${API.webScanningStateUrl}?sid=$_loginSid");
      print("${API.webWeChatAuthUrl}?sid=$_loginSid");
      // Response stateResponse = await _httpUtil.get("${API.webScanningStateUrl}?sid=$_loginSid");
      Response stateResponse;
      try {
        stateResponse = await _httpUtil.get(API.webScanningStateUrl, data: stateData);
      } on DioError catch (e) {
        //如果没有扫码，则请求超时，继续下一轮循环
        print(e.type);
        if (e.type == DioErrorType.receiveTimeout) {
          continue;
        }
        rethrow;
      }
      Map stateJson = stateResponse.data;
      if (stateJson['state'] == 102) {
        print("微信二维码已扫码");
      } else if (stateJson['state'] == 200) {
        Map<String, String> returnRequestData = {"method": "weCharLogin", "appid": _appid, "auth_code": stateJson["data"], "rand_token": _randToken};
        //登录获取cookie
        // String requestUrl = "${API.webLoginUrl}?method=weCharLogin&appid=$_appid&auth_code=${stateJson['data']}&rand_token=$_randToken";

        //请求登录，会有两级跳转，第0次跳转链接为万能登录链接，不需要cookie，但是有时效
        Response loginResponse = await _httpUtil.get(API.webLoginUrl, data: returnRequestData);

        print("获取主页入口链接");
        _entranceUrl = loginResponse.redirects[0].location.toString();
        print(_entranceUrl);
        // _httpUtil.get(requestUrl);
        _isSignedIn = true;
        return true;
      } else {
        print("未识别的状态码");
      }
      sleep(const Duration(milliseconds: 500));
    }
    return false;
  }
}
