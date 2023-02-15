class WrongUsernamePasswordException implements Exception {
  String _errMsg = "";
  WrongUsernamePasswordException([dynamic message]) {
    if (message != null) {
      _errMsg = message;
    } else {
      _errMsg = '用户名或密码错误';
    }
  }
  String errMsg() => _errMsg;
}
