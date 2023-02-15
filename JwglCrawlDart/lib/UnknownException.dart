class UnknownException implements Exception {
  String _errMsg = "";
  UnknownException([dynamic message]) {
    if (message != null) {
      _errMsg = message;
    } else {
      _errMsg = '未知异常';
    }
  }
  String errMsg() => _errMsg;
}
