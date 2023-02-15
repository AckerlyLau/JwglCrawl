import 'package:jwgl_crawl_dart/web_spider.dart';

main() async {
  WebSpider spider = WebSpider();

  spider.getLoginPage().then((value) {
    print(spider.loginSid);
    // sleep(Duration(seconds: 30));
    spider.login();
  });
}
