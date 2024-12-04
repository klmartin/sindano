import 'dart:io';
import 'package:dio/dio.dart';
import 'package:SindanoShow/model/bannermodel.dart';
import 'package:SindanoShow/model/categorymodel.dart';
import 'package:SindanoShow/model/generalsettingmodel.dart';
import 'package:SindanoShow/model/languagemodel.dart';
import 'package:SindanoShow/model/loginmodel.dart';
import 'package:SindanoShow/model/newsdetailsmodel.dart';
import 'package:SindanoShow/model/newsmodel.dart';
import 'package:SindanoShow/model/notificationmodel.dart';
import 'package:SindanoShow/model/pagesmodel.dart';
import 'package:SindanoShow/model/paymentoptionmodel.dart';
import 'package:SindanoShow/model/paytmmodel.dart';
import 'package:SindanoShow/model/profilemodel.dart';
import 'package:SindanoShow/model/searchmodel.dart';
import 'package:SindanoShow/model/sociallinkmodel.dart';
import 'package:SindanoShow/model/subscriptionmodel.dart';
import 'package:SindanoShow/model/successmodel.dart';
import 'package:SindanoShow/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  String baseUrl = Constant().baseurl;

  late Dio dio;

  ApiService() {
    dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
      ),
    );
  }

  Future<GeneralSettingModel> genaralSetting() async {
    GeneralSettingModel responseModel;
    String generalsetting = "general_setting";
    Response response = await dio.post('$baseUrl$generalsetting');
    responseModel = GeneralSettingModel.fromJson((response.data));
    return responseModel;
  }

  // get_pages API
  Future<PagesModel> getPages() async {
    PagesModel responseModel;
    String getPagesAPI = "get_pages";
    Response response = await dio.post(
      '$baseUrl$getPagesAPI',
    );
    responseModel = PagesModel.fromJson(response.data);
    return responseModel;
  }

  // get_social_link API
  Future<SocialLinkModel> getSocialLink() async {
    SocialLinkModel responseModel;
    String socialLinkAPI = "get_social_link";
    Response response = await dio.post(
      '$baseUrl$socialLinkAPI',
    );
    responseModel = SocialLinkModel.fromJson(response.data);
    return responseModel;
  }

  /* type => 1=OTP, 2=Google, 3=Apple, 4=Normal */
  Future<LoginModel> login(
      String email, String name, String type, String deviceToken) async {
    LoginModel responseModel;
    String apiName = "login";
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        "email": email,
        "type": type,
        "device_token": deviceToken,
      }),
    );
    responseModel = LoginModel.fromJson((response.data));
    return responseModel;
  }

  Future<LoginModel> loginWithOtp(String mobile, String deviceToken) async {
    LoginModel responseModel;
    String apiName = 'login';
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        "mobile_number": mobile,
        "type": "1",
        "device_token": deviceToken,
      }),
    );
    responseModel = LoginModel.fromJson((response.data));
    return responseModel;
  }

  Future<ProfileModel> userProfile() async {
    ProfileModel responseModel;
    String apiName = 'get_profile';
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        "user_id": Constant.userID,
      }),
    );
    responseModel = ProfileModel.fromJson(response.data);
    return responseModel;
  }

  Future<SuccessModel> updateProfile(
      fullname, email, mobile, File image) async {
    debugPrint("updateProfile fullname ===> $fullname");
    debugPrint("updateProfile email ======> $email");
    debugPrint("updateProfile mobile =====> $mobile");
    debugPrint("updateProfile image ======> $image");
    SuccessModel responseModel;
    String apiName = 'update_profile';
    Response response = await dio.post('$baseUrl$apiName',
        data: FormData.fromMap({
          "user_id": Constant.userID,
          "full_name": fullname,
          "email": email,
          "mobile_number": mobile,
          if (image.path.isNotEmpty)
            "image": MultipartFile.fromFileSync(image.path,
                filename: basename(image.path))
        }));
    debugPrint(response.statusCode.toString());
    responseModel = SuccessModel.fromJson((response.data));
    return responseModel;
  }

  Future<CategoryModel> categoryList() async {
    CategoryModel responseModel;
    String apiName = "get_category_list";
    Response response = await dio.post('$baseUrl$apiName');
    responseModel = CategoryModel.fromJson((response.data));
    return responseModel;
  }

  Future<LanguageModel> getAllLanguages() async {
    LanguageModel responseModel;
    String apiName = 'get_language_list';
    Response response = await dio.post('$baseUrl$apiName');
    responseModel = LanguageModel.fromJson((response.data));
    return responseModel;
  }

  Future<BannerModel> bannerList(catId, type) async {
    BannerModel responseModel;
    String apiName = "get_banner_list";
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        "category_id": catId,
        "type": type,
        "user_id": Constant.userID,
      }),
    );
    responseModel = BannerModel.fromJson((response.data));
    return responseModel;
  }

  Future<NewsModel> getTopsNews(categoryID) async {
    NewsModel responseModel;
    String apiName = "top_news";
    Response response = await dio.post(
      "$baseUrl$apiName",
      data: FormData.fromMap({
        "user_id": Constant.userID,
        "category_id": categoryID,
      }),
    );
    responseModel = NewsModel.fromJson((response.data));
    return responseModel;
  }

  Future<NewsModel> recentNews(categoryID) async {
    NewsModel responseModel;
    String apiName = 'recent_news';
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        "user_id": Constant.userID,
        "category_id": categoryID,
      }),
    );
    responseModel = NewsModel.fromJson((response.data));
    return responseModel;
  }

  Future<NewsModel> getNewsByLanguageId(categoryID, languageID) async {
    NewsModel responseModel;
    String apiName = 'get_news_by_language_id';
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        "user_id": Constant.userID,
        "category_id": categoryID,
        "language_id": languageID,
      }),
    );
    responseModel = NewsModel.fromJson((response.data));
    return responseModel;
  }

  Future<NewsModel> lastWeekNews(categoryID) async {
    NewsModel responseModel;
    String apiName = 'last_week_news';
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        "user_id": Constant.userID,
        "category_id": categoryID,
      }),
    );
    responseModel = NewsModel.fromJson((response.data));
    return responseModel;
  }

  Future<NotificationModel> getNotification() async {
    NotificationModel responseModel;
    String apiName = "get_notification";
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        "user_id": Constant.userID,
      }),
    );
    responseModel = NotificationModel.fromJson((response.data));
    return responseModel;
  }

  Future<SuccessModel> readNotification(notificationId) async {
    SuccessModel responseModel;
    String apiName = "read_notification";
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        "user_id": Constant.userID,
        "notification_id": notificationId,
      }),
    );
    responseModel = SuccessModel.fromJson((response.data));
    return responseModel;
  }

  Future<SuccessModel> addArticleBookmark(articleid) async {
    SuccessModel successModel;
    String apiName = "add_remove_bookmark";
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        "user_id": Constant.userID,
        "article_id": articleid,
      }),
    );
    successModel = SuccessModel.fromJson((response.data));
    return successModel;
  }

  Future<NewsModel> relatedNews(categoryID) async {
    NewsModel responseModel;
    String apiName = 'related_news';
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        "user_id": Constant.userID,
        "category_id": categoryID,
      }),
    );
    responseModel = NewsModel.fromJson((response.data));
    return responseModel;
  }

  Future<NewsModel> getBookmarkArticle() async {
    NewsModel responseModel;
    String apiName = 'get_bookmark_article';
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        "user_id": Constant.userID,
      }),
    );
    responseModel = NewsModel.fromJson((response.data));
    return responseModel;
  }

  /* type = 1-Image, 2-Video */
  Future<NewsModel> videoNews(categoryID) async {
    NewsModel responseModel;
    String apiName = 'video_news';
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        "user_id": Constant.userID,
        "category_id": categoryID,
      }),
    );
    responseModel = NewsModel.fromJson((response.data));
    return responseModel;
  }

  Future<NewsDetailsModel> articleDetails(articalId) async {
    NewsDetailsModel responseModel;
    String apiName = "article_details";
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        "user_id": Constant.userID,
        "article_id": articalId,
      }),
    );
    responseModel = NewsDetailsModel.fromJson((response.data));
    return responseModel;
  }

  Future<SuccessModel> addView(articleId) async {
    SuccessModel responseModel;
    String apiName = "add_view";
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        "user_id": Constant.userID,
        "article_id": articleId,
      }),
    );
    responseModel = SuccessModel.fromJson((response.data));
    return responseModel;
  }

  Future<SearchModel> searchArticle(String name) async {
    SearchModel responseModel;
    String apiName = 'search_article';
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        "user_id": Constant.userID,
        "name": name,
      }),
    );
    responseModel = SearchModel.fromJson((response.data));
    return responseModel;
  }

  Future<SubscriptionModel> getPackages() async {
    SubscriptionModel responseModel;
    String apiName = "get_subsription";
    Response response = await dio.post(
      '$baseUrl$apiName',
      data: FormData.fromMap({
        "user_id": Constant.userID,
      }),
    );
    responseModel = SubscriptionModel.fromJson(response.data);
    return responseModel;
  }

  // get_payment_option API
  Future<PaymentOptionModel> getPaymentOption() async {
    PaymentOptionModel paymentOptionModel;
    String paymentOption = "get_payment_option";
    debugPrint("paymentOption API :==> $baseUrl$paymentOption");
    Response response = await dio.post(
      '$baseUrl$paymentOption',
    );

    paymentOptionModel = PaymentOptionModel.fromJson(response.data);
    return paymentOptionModel;
  }

  // get_payment_token API
  Future<PayTmModel> getPaytmToken(merchantID, orderId, custmoreID, channelID,
      txnAmount, website, callbackURL, industryTypeID) async {
    PayTmModel payTmModel;
    String paytmToken = "get_payment_token";
    debugPrint("paytmToken API :==> $baseUrl$paytmToken");
    Response response = await dio.post(
      '$baseUrl$paytmToken',
      data: {
        'MID': merchantID,
        'order_id': orderId,
        'CUST_ID': custmoreID,
        'CHANNEL_ID': channelID,
        'TXN_AMOUNT': txnAmount,
        'WEBSITE': website,
        'CALLBACK_URL': callbackURL,
        'INDUSTRY_TYPE_ID': industryTypeID,
      },
    );

    payTmModel = PayTmModel.fromJson(response.data);
    return payTmModel;
  }

  // add_transaction API
  Future<SuccessModel> addTransaction(packageId, description, amount, paymentId,
      currencyCode, couponCode) async {
    debugPrint('addTransaction userID ==>>> ${Constant.userID}');
    debugPrint('addTransaction packageId ==>>> $packageId');
    debugPrint('addTransaction description ==>>> $description');
    debugPrint('addTransaction amount ==>>> $amount');
    debugPrint('addTransaction paymentId ==>>> $paymentId');
    debugPrint('addTransaction currencyCode ==>>> $currencyCode');
    debugPrint('addTransaction couponCode ==>>> $couponCode');
    SuccessModel successModel;
    String transaction = "add_transaction";
    Response response = await dio.post(
      '$baseUrl$transaction',
      data: {
        'user_id': Constant.userID,
        'package_id': packageId,
        'description': description,
        'amount': amount,
        'payment_id': paymentId,
        'currency_code': currencyCode,
        'unique_id': couponCode,
      },
    );
    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  Future<void> makePayment(String userId, String amount, String phoneNumber) async {
    print("make payment begin");
    const String apiUrl = 'https://www.sindanoshow.com/public/api/payments/flutterwave';
    // Create Dio instance
    Dio dio = Dio();
    try {
      // Prepare the request body
      final Map<String, String> requestBody = {
        'user_id': userId,
        'amount': amount,
        'phone_number': phoneNumber,
      };
      // Send POST request
      Response response = await dio.post(
        apiUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: requestBody,
      );
      print(response);
      print("make payment response");
      // Handle response
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['status'] == 200) {
          final paymentData = responseData['response']['data'];
          print('Payment Success: ${paymentData['message']}');
          print('Transaction Reference: ${paymentData['tx_ref']}');
        } else {
          print('Payment Failed: ${responseData['response']['message']}');
        }
      } else {
        print('Server Error: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Error: ${e.response?.statusCode} ${e.response?.data}');
      } else {
        print('Error: ${e.message}');
      }
    } catch (e) {
      print('Unexpected Error: $e');
    }
  }

}
