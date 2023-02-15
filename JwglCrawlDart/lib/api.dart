class API {
  //移动教务系统
  static const String mobileRetrieveUrl = "https://jwgl.ustb.edu.cn/njwhd/retrievePwd?type=cx";
  //登录，返回一串json，说你登录成功
  static const String mobileLoginUrl = "https://jwgl.ustb.edu.cn/njwhd/login"; //https://jwgl.ustb.edu.cn/njwhd/login?userNo=41824187&pwd=THkxMjQ1MjAxNDU=&encode=1&captchaData=&codeVal=
  //访问以下获取cookie，似乎没什么卵用
  static const String mobileGetCookieUrl = "https://jwgl.ustb.edu.cn/favicon.ico";
  //查询功能列表
  static const String mobileGetFunctionListUrl = "https://jwgl.ustb.edu.cn/njwhd/FindSch_Int?xx0101id=10008&type=0&isqy=&key=qzkj";
  //查询节次模式，貌似没什么卵用,需要先登录获取token
  static const String mobileGetSubjectsUrl = "https://jwgl.ustb.edu.cn/njwhd/Get_sjkbms";
  //获取课程表,参数week=all,kbjcmsid= //[空]
  static const String mobileGetCourseListUrl = "https://jwgl.ustb.edu.cn/njwhd/student/curriculum";
  //Web教务系统
  //登录二维码
  static const String webQrcodeRequestUrl = "https://sis.ustb.edu.cn/connect/qrpage";
  //登录url
  //method=randToken 获取 token
  //method = weCharLogin 登录
  static const String webLoginUrl = "https://jwgl.ustb.edu.cn/glht/Logon.do";

  //查询成绩，前置页面
  static const String webTermUrl = "https://jwgl.ustb.edu.cn/kscj/cjcx_query";
  //学业进度
  static const String webCareerUrl = "https://jwgl.ustb.edu.cn/pyfa/toxywcqk";
  //每学期成绩
  static const String webScoreUrl = "https://jwgl.ustb.edu.cn/kscj/cjcx_list";
  //微信扫码登录，二维码地址
  //https://sis.ustb.edu.cn/connect/qrimg?sid=fa63a35928895fd0c7b2bb9eba8b2889
  static const String webQrCodeUrl = "https://sis.ustb.edu.cn/connect/qrimg";
  //微信扫码登录后，微信端跳转链接
  //https://sis.ustb.edu.cn/auth?sid=6620ac067e4d485415178e9662d29e82
  static const String webWeChatAuthUrl = "https://sis.ustb.edu.cn/auth";
  //扫码状态验证
  //未扫码会请求超时
  //已扫码json.state 102
  //已确认json.state 200
  static const String webScanningStateUrl = "https://sis.ustb.edu.cn/connect/state";
}
