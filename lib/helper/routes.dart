import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uydu/model/category.dart';
import 'package:uydu/model/chat.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/splash_screen.dart';
import 'package:uydu/view/artisan/home/artisan_home_page.dart';
import 'package:uydu/view/auth/login/login_page.dart';
import 'package:uydu/view/auth/register/register_page.dart';
import 'package:uydu/view/chats_page/chats_page.dart';
import 'package:uydu/view/chats_page/conversation_page.dart';
import 'package:uydu/view/customer/home/customer_home_page.dart';
import 'package:uydu/view/customer/requests/customer_all_request_page.dart';
import 'package:uydu/view/customer/requests/send_request_to_artisan_page.dart';
import 'package:uydu/view/edit_profile_page.dart';
import 'package:uydu/view/list_artisan_by_category/list_artisan_by_category.dart';
import 'package:uydu/view/pay_page/check_out_page.dart';
import 'package:uydu/view/pay_page/pay_page.dart';
import 'package:uydu/view/profile_page.dart';
import 'package:uydu/view_model/artisan_home_view_model.dart';
import 'package:uydu/view_model/auth_view_model.dart';
import 'package:uydu/view_model/chats_view_model/chats_view_model.dart';
import 'package:uydu/view_model/chats_view_model/conversation_view_model.dart';
import 'package:uydu/view_model/customer_all_request_view_model.dart';
import 'package:uydu/view_model/customer_home_view_model.dart';
import 'package:uydu/view_model/list_artisan_by_category_view_model.dart';
import 'package:uydu/view_model/profile_view_model.dart';
import 'package:uydu/view_model/send_request_to_artisan_view_model.dart';
import 'package:uydu/view_model/splash_screen_view_model.dart';
import 'package:uydu/widgets/image_review_page.dart';

class Routes {
  static const String SPLASH_PAGE = '/splash_page';
  static const String LOGIN_PAGE = '/login_page';
  static const String REGISTER_PAGE = '/register_page';
  static const String MAIN_PAGE = '/main_page';
  static const String ONBOARDING_PAGE = '/onboarding_page';

  static const String WALLET_RECIVED_DETAIL_PAGE =
      '/wallet_received_detail_page';
  static const String WALLET_QR_CODE_PAGE = '/wallet_qr_code_page';
  static const String NEARBY_USERS_PAGE = '/nearby_users_page';
  static const String MY_CREDITS_PAGE = '/my_credits_page';

  static openImageDetail(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageReviewPage(url: url),
      ),
    );
  }

  static openArtisanHomePage(BuildContext context, User? user) {
    Get.offAll(
      () => ChangeNotifierProvider<ArtisanHomeViewModel>(
        create: (context) => ArtisanHomeViewModel(user, ""),
        child: ArtisanHomePage(),
      ),
    );
  }

  static openCustomerHomePage(BuildContext context, User? user) {
    Get.offAll(
      () => ChangeNotifierProvider<CustomerHomeViewModel>(
        create: (context) => CustomerHomeViewModel(user: user),
        child: CustomerHomePage(
          user: user,
        ),
      ),
    );
  }

  static openPayPage(BuildContext context, List<CategoryModel?> categories) {
    Get.to(() => PayPage(categories: categories));
  }

  static openCheckOutPage(BuildContext context, CategoryModel? categoryModel) {
    Get.to(() => CheckOutPage(categoryModel: categoryModel));
  }

  static openProfilePage(bool? isOwnProfie, String? userId) {
    Get.to(
      () => MultiProvider(
        providers: [
          ChangeNotifierProvider<ProfilePageViewModel>(
            create: (context) => ProfilePageViewModel(isOwnProfie, userId!),
          ),
          ChangeNotifierProvider<CustomerAllRequestViewModel>(
            create: (context) => CustomerAllRequestViewModel(userId!),
          ),
          ChangeNotifierProvider<ChatsViewModel>(
            create: (context) => ChatsViewModel(),
          )
        ],
        child: ProfilePage(),
      ),
    );
  }

  static openAllRequestesPage(BuildContext context, isOff, user, isArtisan) {
    isArtisan
        ? Get.off(() => ChangeNotifierProvider<ArtisanHomeViewModel>(
              create: (context) => ArtisanHomeViewModel(user, ""),
              child: ArtisanHomePage(),
            ))
        : isOff
            ? Get.off(
                () => MultiProvider(
                  providers: [
                    ChangeNotifierProvider<CustomerAllRequestViewModel>(
                      create: (context) =>
                          CustomerAllRequestViewModel(user.userId),
                    ),
                    ChangeNotifierProvider<SendRequestToArtisanViewModel>(
                      create: (context) =>
                          SendRequestToArtisanViewModel(null, null),
                    )
                  ],
                  child: CustomerAllRequestPage(),
                ),
              )
            : Get.to(
                () => MultiProvider(
                  providers: [
                    ChangeNotifierProvider<CustomerAllRequestViewModel>(
                      create: (context) =>
                          CustomerAllRequestViewModel(user.userId),
                    ),
                    ChangeNotifierProvider<SendRequestToArtisanViewModel>(
                      create: (context) =>
                          SendRequestToArtisanViewModel(null, null),
                    )
                  ],
                  child: CustomerAllRequestPage(),
                ),
              );
  }

  static openSentRequestToArtisanPage(
      BuildContext context, CategoryModel? categoryModel, User? user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChangeNotifierProvider<SendRequestToArtisanViewModel>(
          create: (context) =>
              SendRequestToArtisanViewModel(categoryModel, user),
          child: SendRequestToArtisanPage(),
        ),
      ),
    );
  }

  static openRegisterPage(BuildContext context, bool isArtisan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(),
          child: RegisterPage(
            isArtisan: isArtisan,
          ),
        ),
      ),
    );
  }

  static openLoginPage(BuildContext context, bool deleteUntilPage) {
    deleteUntilPage
        ? Get.offAll(() => ChangeNotifierProvider<AuthViewModel>(
              create: (context) => AuthViewModel(),
              child: LoginPage(),
            ))
        : Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider<AuthViewModel>(
                create: (context) => AuthViewModel(),
                child: LoginPage(),
              ),
            ),
          );
  }

  static openSplashScreen(BuildContext context) {
    Get.offAll(() => ChangeNotifierProvider<SplashViewModel>(
          create: (context) => SplashViewModel(),
          child: SplashPage(),
        ));
  }

  static openProfileEditScreen(BuildContext context, name, phone, adres) {
    Get.to(() => ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(),
          child: EditProfile(
            name: name,
            phone: phone,
            adress: adres,
          ),
        ));
  }

  static openListArtisanByCategory(BuildContext context, String? category) {
    Get.to(
      () => MultiProvider(
        providers: [
          ChangeNotifierProvider<ListArtisanByCategorViewModel>(
              create: (context) =>
                  ListArtisanByCategorViewModel(category: category)),
          ChangeNotifierProvider<ChatsViewModel>(
            create: (context) => ChatsViewModel(),
          )
        ],
        child: ListArtisanByCategory(),
      ),
    );
  }

  static openProfileImageReveviewPage(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => ConversationViewModel(),
          child: ImageReviewPage(
            url: url,
          ),
        ),
      ),
    );
  }

  static openImageReveviewPage(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => ConversationViewModel(),
          child: ImageReviewPage(
            url: url,
          ),
        ),
      ),
    );
  }

  static openConversationPage(BuildContext context, Chat? chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => ConversationViewModel(),
          child: ConversationPage(
            chat: chat,
          ),
        ),
      ),
    );
  }

  static openAllChatsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => ChatsViewModel(),
          child: AllChatsPage(),
        ),
      ),
    );
  }
}
