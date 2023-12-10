// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:quickad_it_solutions/controller/auth_controller.dart';
// import 'package:quickad_it_solutions/controller/localization_controller.dart';
// import 'package:quickad_it_solutions/controller/splash_controller.dart';
// import 'package:quickad_it_solutions/helper/responsive_helper.dart';
// import 'package:quickad_it_solutions/helper/route_helper.dart';
// import 'package:quickad_it_solutions/util/dimensions.dart';
// import 'package:quickad_it_solutions/util/images.dart';
// import 'package:quickad_it_solutions/util/styles.dart';
// import 'package:quickad_it_solutions/view/base/custom_button.dart';
// import 'package:quickad_it_solutions/view/base/custom_snackbar.dart';
// import 'package:quickad_it_solutions/view/base/custom_text_field.dart';
// import 'package:quickad_it_solutions/view/base/footer_view.dart';
// import 'package:quickad_it_solutions/view/base/menu_drawer.dart';
// import 'package:quickad_it_solutions/view/base/web_menu_bar.dart';
// import 'package:quickad_it_solutions/view/screens/auth/widget/condition_check_box.dart';
// import 'package:quickad_it_solutions/view/screens/auth/widget/guest_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:phone_number/phone_number.dart';
// import 'package:quickad_it_solutions/view/screens/auth/widget/social_login_widget.dart';
//
// class SignInScreen extends StatefulWidget {
//   final bool exitFromApp;
//   const SignInScreen({Key? key, required this.exitFromApp}) : super(key: key);
//
//   @override
//   SignInScreenState createState() => SignInScreenState();
// }
//
// class SignInScreenState extends State<SignInScreen> {
//   final FocusNode _phoneFocus = FocusNode();
//   final FocusNode _passwordFocus = FocusNode();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   String? _countryDialCode;
//   bool _canExit = GetPlatform.isWeb ? true : false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _countryDialCode = Get.find<AuthController>().getUserCountryCode().isNotEmpty ? Get.find<AuthController>().getUserCountryCode()
//         : CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
//     _phoneController.text =  Get.find<AuthController>().getUserNumber();
//     _passwordController.text = Get.find<AuthController>().getUserPassword();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if(widget.exitFromApp) {
//           if (_canExit) {
//             if (GetPlatform.isAndroid) {
//               SystemNavigator.pop();
//             } else if (GetPlatform.isIOS) {
//               exit(0);
//             } else {
//               Navigator.pushNamed(context, RouteHelper.getInitialRoute());
//             }
//             return Future.value(false);
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: Text('back_press_again_to_exit'.tr, style: const TextStyle(color: Colors.white)),
//               behavior: SnackBarBehavior.floating,
//               backgroundColor: Colors.green,
//               duration: const Duration(seconds: 2),
//               margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
//             ));
//             _canExit = true;
//             Timer(const Duration(seconds: 2), () {
//               _canExit = false;
//             });
//             return Future.value(false);
//           }
//         }else {
//           return true;
//         }
//       },
//       child: Scaffold(
//         appBar: (ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : !widget.exitFromApp ? AppBar(leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: Icon(Icons.arrow_back_ios_rounded, color: Theme.of(context).textTheme.bodyLarge!.color),
//         ), elevation: 0, backgroundColor: Colors.transparent) : null) as PreferredSizeWidget?,
//         endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
//         body: SafeArea(child: Center(
//           child: Scrollbar(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: FooterView(child: Center(
//                 child: Container(
//                   width: context.width > 700 ? 700 : context.width,
//                   padding: context.width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : const EdgeInsets.all(Dimensions.paddingSizeSmall),
//                   margin: context.width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : EdgeInsets.zero,
//                   decoration: context.width > 700 ? BoxDecoration(
//                     color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//                     boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, blurRadius: 5, spreadRadius: 1)],
//                   ) : null,
//                   child: GetBuilder<AuthController>(builder: (authController) {
//
//                     return Column(children: [
//
//                       Image.asset(Images.logo, width: 200),
//                       // SizedBox(height: Dimensions.paddingSizeSmall),
//                       // Center(child: Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge))),
//                       const SizedBox(height: Dimensions.paddingSizeExtraLarge),
//
//                       Text('sign_in'.tr.toUpperCase(), style: robotoBlack.copyWith(fontSize: 30)),
//                       const SizedBox(height: 50),
//
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//                           color: Theme.of(context).cardColor,
//                           boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
//                         ),
//                         child: Column(children: [
//
//                           Row(children: [
//                             CountryCodePicker(
//                               onChanged: (CountryCode countryCode) {
//                                 _countryDialCode = countryCode.dialCode;
//                               },
//                               initialSelection: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
//                                   : Get.find<LocalizationController>().locale.countryCode,
//                               favorite: [CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code!],
//                               showDropDownButton: true,
//                               padding: EdgeInsets.zero,
//                               showFlagMain: true,
//                               flagWidth: 30,
//                               dialogBackgroundColor: Theme.of(context).cardColor,
//                               textStyle: robotoRegular.copyWith(
//                                 fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color,
//                               ),
//                             ),
//                             Expanded(flex: 1, child: CustomTextField(
//                               hintText: 'phone'.tr,
//                               controller: _phoneController,
//                               focusNode: _phoneFocus,
//                               nextFocus: _passwordFocus,
//                               inputType: TextInputType.phone,
//                               divider: false,
//                             )),
//                           ]),
//                           const Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge), child: Divider(height: 1)),
//
//                           CustomTextField(
//                             hintText: 'password'.tr,
//                             controller: _passwordController,
//                             focusNode: _passwordFocus,
//                             inputAction: TextInputAction.done,
//                             inputType: TextInputType.visiblePassword,
//                             prefixIcon: Images.lock,
//                             isPassword: true,
//                             onSubmit: (text) => (GetPlatform.isWeb && authController.acceptTerms)
//                                 ? _login(authController, _countryDialCode!) : null,
//                           ),
//
//                         ]),
//                       ),
//                       const SizedBox(height: 10),
//
//                       Row(children: [
//                         Expanded(
//                           child: ListTile(
//                             onTap: () => authController.toggleRememberMe(),
//                             leading: Checkbox(
//                               activeColor: Theme.of(context).primaryColor,
//                               value: authController.isActiveRememberMe,
//                               onChanged: (bool? isChecked) => authController.toggleRememberMe(),
//                             ),
//                             title: Text('remember_me'.tr),
//                             contentPadding: EdgeInsets.zero,
//                             dense: true,
//                             horizontalTitleGap: 0,
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () => Get.toNamed(RouteHelper.getForgotPassRoute(false, null)),
//                           child: Text('${'forgot_password'.tr}?'),
//                         ),
//                       ]),
//                       const SizedBox(height: Dimensions.paddingSizeLarge),
//
//                       ConditionCheckBox(authController: authController),
//                       const SizedBox(height: Dimensions.paddingSizeSmall),
//
//                       !authController.isLoading ? Row(children: [
//                         Expanded(child: CustomButton(
//                           buttonText: 'sign_up'.tr,
//                           transparent: true,
//                           onPressed: () => Get.toNamed(RouteHelper.getSignUpRoute()),
//                         )),
//                         Expanded(child: CustomButton(
//                           buttonText: 'sign_in'.tr,
//                           onPressed: authController.acceptTerms ? () => _login(authController, _countryDialCode!) : null,
//                         )),
//                       ]) : const Center(child: CircularProgressIndicator()),
//                       const SizedBox(height: 30),
//
//                       const SocialLoginWidget(),
//
//                       const GuestButton(),
//
//                     ]);
//                   }),
//                 ),
//               )),
//             ),
//           ),
//         )),
//       ),
//     );
//   }
//
//   void _login(AuthController authController, String countryDialCode) async {
//     String phone = _phoneController.text.trim();
//     String password = _passwordController.text.trim();
//     String numberWithCountryCode = countryDialCode+phone;
//     bool isValid = GetPlatform.isAndroid ? false : true;
//     if(GetPlatform.isAndroid) {
//       try {
//         PhoneNumber phoneNumber = await PhoneNumberUtil().parse(numberWithCountryCode);
//         numberWithCountryCode = '+${phoneNumber.countryCode}${phoneNumber.nationalNumber}';
//         isValid = true;
//       } catch (_) {}
//     }
//     if (phone.isEmpty) {
//       showCustomSnackBar('enter_phone_number'.tr);
//     }else if (!isValid) {
//       showCustomSnackBar('invalid_phone_number'.tr);
//     }else if (password.isEmpty) {
//       showCustomSnackBar('enter_password'.tr);
//     }else if (password.length < 6) {
//       showCustomSnackBar('password_should_be'.tr);
//     }else {
//       authController.login(numberWithCountryCode, password).then((status) async {
//         if (status.isSuccess) {
//           if (authController.isActiveRememberMe) {
//             authController.saveUserNumberAndPassword(phone, password, countryDialCode);
//           } else {
//             authController.clearUserNumberAndPassword();
//           }
//           String token = status.message!.substring(1, status.message!.length);
//           if(Get.find<SplashController>().configModel!.customerVerification! && int.parse(status.message![0]) == 0) {
//             List<int> encoded = utf8.encode(password);
//             String data = base64Encode(encoded);
//             Get.toNamed(RouteHelper.getVerificationRoute(numberWithCountryCode, token, RouteHelper.signUp, data));
//           }else {
//             Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
//           }
//         }else {
//           showCustomSnackBar(status.message);
//         }
//       });
//     }
//   }
// }

import 'dart:async';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';
import 'package:quickad_it_solutions/controller/auth_controller.dart';
import 'package:quickad_it_solutions/controller/localization_controller.dart';
import 'package:quickad_it_solutions/controller/splash_controller.dart';
import 'package:quickad_it_solutions/helper/route_helper.dart';
import 'package:quickad_it_solutions/util/dimensions.dart';
import 'package:quickad_it_solutions/util/images.dart';
import 'package:quickad_it_solutions/util/styles.dart';
import 'package:quickad_it_solutions/view/base/code_picker_widget.dart';
import 'package:quickad_it_solutions/view/base/custom_snackbar.dart';
import 'package:quickad_it_solutions/view/base/custom_text_field.dart';
import 'package:quickad_it_solutions/view/base/footer_view.dart';
import 'package:quickad_it_solutions/view/base/menu_drawer.dart';
import 'package:quickad_it_solutions/view/screens/auth/widget/guest_button.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  final bool backFromThis;

  const SignInScreen(
      {super.key, required this.exitFromApp, required this.backFromThis});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  late String _countryDialCode;
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();
    init();
    _countryDialCode =
        (Get.find<AuthController>().getUserCountryCode().isNotEmpty
            ? Get.find<AuthController>().getUserCountryCode()
            : CountryCode.fromCountryCode(
                    Get.find<SplashController>().configModel!.country!)
                .dialCode)!;
    _phoneController.text = Get.find<AuthController>().getUserNumber() ?? '';
  }

//next page not showing
  init() async {
    await Get.find<SplashController>().getConfigData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.exitFromApp) {
          if (_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            } else {
              Navigator.pushNamed(context, RouteHelper.getInitialRoute());
            }
            return Future.value(false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('back_press_again_to_exit'.tr,
                  style: const TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            ));
            _canExit = true;
            Timer(const Duration(seconds: 2), () {
              _canExit = false;
            });
            return Future.value(false);
          }
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar:
            // ResponsiveHelper.isDesktop(context)
            //     ? WebMenuBar()
            //     : !widget.exitFromApp
            //         ?
            AppBar(
                leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.arrow_back_ios_rounded,
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent),
        // : null,
        endDrawer: const MenuDrawer(),
        body: SafeArea(
            child: Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: FooterView(
                child: Container(
              width: context.width > 700 ? 700 : context.width,
              padding: context.width > 700
                  ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
                  : const EdgeInsets.all(Dimensions.paddingSizeSmall),
              margin: context.width > 700
                  ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
                  : EdgeInsets.zero,
              decoration: context.width > 700
                  ? BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                            blurRadius: 5,
                            spreadRadius: 1)
                      ],
                    )
                  : null,
              child: GetBuilder<AuthController>(builder: (authController) {
                return Column(children: [
                  Image.asset(Images.logo, width: 250),
                  const SizedBox(height: 80),
                  // Center(child: Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge))),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(color: Colors.grey[200]!),
                      color: Colors.transparent,
                    ),
                    child: Column(children: [
                      Row(children: [
                        CodePickerWidget(
                          onChanged: (CountryCode countryCode) {
                            _countryDialCode = countryCode.dialCode!;
                          },
                          initialSelection: _countryDialCode != null
                              ? CountryCode.fromCountryCode(
                                      Get.find<SplashController>()
                                          .configModel!
                                          .country!)
                                  .code
                              : Get.find<LocalizationController>()
                                  .locale
                                  .countryCode,
                          favorite: [
                            CountryCode.fromCountryCode(
                                        Get.find<SplashController>()
                                            .configModel!
                                            .country!)
                                    .code ??
                                "in"
                          ],
                          showDropDownButton: true,
                          padding: EdgeInsets.zero,
                          showFlagMain: true,
                          flagWidth: 30,
                          dialogBackgroundColor: Theme.of(context).cardColor,
                          textStyle: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: CustomTextField(
                              hintText: 'phone'.tr,
                              controller: _phoneController,
                              focusNode: _phoneFocus,
                              inputType: TextInputType.phone,
                              divider: false,
                              bgColor: Colors.transparent,
                              showBorder: false,
                            )),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                      onTap: () {
                        if (authController.acceptTerms) {
                          _login(authController, _countryDialCode);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: authController.isLoading ? 5 : 15),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Center(
                            child: authController.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "CONTINUE",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                      )),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            shape: BoxShape.circle),
                        child: const Text(
                          "OR",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),

                  //ConditionCheckBox(authController: authController),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("By Signing up you agree to our ,"),
                      InkWell(
                        child: const Text(
                          "Terms of Use",
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                        onTap: () {
                          Get.toNamed(
                              RouteHelper.getHtmlRoute('terms-and-condition'));
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 30),
                  // SocialLoginWidget(),

                  const GuestButton(),
                ]);
              }),
            )),
          ),
        )),
      ),
    );
  }

  void _login(AuthController authController, String countryDialCode) async {
    String phone = _phoneController.text.trim();
    String numberWithCountryCode = countryDialCode + phone;
    bool isValid = GetPlatform.isWeb ? true : false;
    if (!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber =
            await PhoneNumberUtil().parse(numberWithCountryCode);
        numberWithCountryCode =
            '+${phoneNumber.countryCode}${phoneNumber.nationalNumber}';
        isValid = true;
      } catch (e) {}
    }
    if (phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else {
      authController.login(numberWithCountryCode).then((status) async {
        if (status!.isSuccess) {
          if (authController.isActiveRememberMe) {
            authController.saveUserNumberAndPassword(phone, countryDialCode);
          } else {
            authController.clearUserNumberAndPassword();
          }
          String token = status.message!.substring(1, status.message!.length);
          print('going to otp');
          Get.toNamed(RouteHelper.getVerificationRoute(
              numberWithCountryCode, token, RouteHelper.signUp));
          /*
        if (Get.find<SplashController>().configModel.customerVerification &&
            int.parse(status.message[0]) == 0) {

        } else {
          Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
        }*/
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
