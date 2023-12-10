import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:quickad_it_solutions/controller/auth_controller.dart';
import 'package:quickad_it_solutions/controller/cart_controller.dart';
import 'package:quickad_it_solutions/controller/location_controller.dart';
import 'package:quickad_it_solutions/controller/splash_controller.dart';
import 'package:quickad_it_solutions/controller/wishlist_controller.dart';
import 'package:quickad_it_solutions/data/model/body/notification_body.dart';
import 'package:quickad_it_solutions/helper/route_helper.dart';
import 'package:quickad_it_solutions/util/app_constants.dart';
import 'package:quickad_it_solutions/util/dimensions.dart';
import 'package:quickad_it_solutions/util/images.dart';
import 'package:quickad_it_solutions/view/base/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBody? body;
  const SplashScreen({Key? key, required this.body}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? const SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    Get.find<SplashController>().initSharedData();
    if ((Get.find<AuthController>().getGuestId().isNotEmpty ||
            Get.find<AuthController>().isLoggedIn()) &&
        Get.find<SplashController>().cacheModule != null) {
      Get.find<CartController>().getCartData();
    }
    _route();
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if (isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          double? minimumVersion = 0;
          if (GetPlatform.isAndroid) {
            minimumVersion = Get.find<SplashController>()
                .configModel!
                .appMinimumVersionAndroid;
          } else if (GetPlatform.isIOS) {
            minimumVersion =
                Get.find<SplashController>().configModel!.appMinimumVersionIos;
          }
          if (AppConstants.appVersion < minimumVersion! ||
              Get.find<SplashController>().configModel!.maintenanceMode!) {
            Get.offNamed(RouteHelper.getUpdateRoute(
                AppConstants.appVersion < minimumVersion));
          } else {
            if (widget.body != null) {
              if (widget.body!.notificationType == NotificationType.order) {
                Get.offNamed(RouteHelper.getOrderDetailsRoute(
                    widget.body!.orderId,
                    fromNotification: true));
              } else if (widget.body!.notificationType ==
                  NotificationType.general) {
                Get.offNamed(
                    RouteHelper.getNotificationRoute(fromNotification: true));
              } else {
                Get.offNamed(RouteHelper.getChatRoute(
                    notificationBody: widget.body,
                    conversationID: widget.body!.conversationId,
                    fromNotification: true));
              }
            } else {
              if (Get.find<AuthController>().isLoggedIn()) {
                Get.find<AuthController>().updateToken();
                if (Get.find<LocationController>().getUserAddress() != null) {
                  if (Get.find<SplashController>().module != null) {
                    await Get.find<WishListController>().getWishList();
                  }
                  Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true));
                } else {
                  Get.find<LocationController>()
                      .navigateToLocationScreen('splash', offNamed: true);
                }
              } else {
                if (Get.find<SplashController>().showIntro()!) {
                  if (AppConstants.languages.length > 1) {
                    Get.offNamed(RouteHelper.getLanguageRoute('splash'));
                  } else {
                    Get.offNamed(RouteHelper.getOnBoardingRoute());
                  }
                } else {
                  if (Get.find<AuthController>().isGuestLoggedIn()) {
                    if (Get.find<LocationController>().getUserAddress() !=
                        null) {
                      Get.offNamed(
                          RouteHelper.getInitialRoute(fromSplash: true));
                    } else {
                      Get.find<LocationController>()
                          .navigateToLocationScreen('splash', offNamed: true);
                    }
                  } else {
                    Get.offNamed(
                        RouteHelper.getSignInRoute(RouteHelper.splash));
                  }
                }
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>().initSharedData();
    if (Get.find<LocationController>().getUserAddress() != null &&
        Get.find<LocationController>().getUserAddress()!.zoneIds == null) {
      Get.find<AuthController>().clearSharedAddress();
    }

    return Scaffold(
      key: _globalKey,
      body: GetBuilder<SplashController>(builder: (splashController) {
        return Center(
          child: splashController.hasConnection
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(Images.splash, width: 280),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    // Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: 25)),
                  ],
                )
              : NoInternetScreen(child: SplashScreen(body: widget.body)),
        );
      }),
    );
  }
}
