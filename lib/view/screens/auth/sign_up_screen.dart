import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quickad_it_solutions/controller/auth_controller.dart';
import 'package:quickad_it_solutions/controller/splash_controller.dart';
import 'package:quickad_it_solutions/data/model/body/signup_body.dart';
import 'package:quickad_it_solutions/helper/responsive_helper.dart';
import 'package:quickad_it_solutions/helper/route_helper.dart';
import 'package:quickad_it_solutions/util/dimensions.dart';
import 'package:quickad_it_solutions/util/images.dart';
import 'package:quickad_it_solutions/util/styles.dart';
import 'package:quickad_it_solutions/view/base/custom_snackbar.dart';
import 'package:quickad_it_solutions/view/base/custom_text_field.dart';
import 'package:quickad_it_solutions/view/base/footer_view.dart';
import 'package:quickad_it_solutions/view/base/menu_drawer.dart';
import 'package:quickad_it_solutions/view/base/web_menu_bar.dart';

class SignUpScreen extends StatefulWidget {
  String? otp;
  String? phone;
  SignUpScreen({
    Key? key,
    this.otp,
    this.phone,
  }) : super(key: key);
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  late String _countryDialCode;

  @override
  void initState() {
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(
            Get.find<SplashController>().configModel!.country!)
        .dialCode!;

    widget.phone = widget.phone!.startsWith('+')
        ? widget.phone
        : '+${widget.phone!.substring(1, widget.phone!.length)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
      endDrawer: const MenuDrawer(),
      body: SafeArea(
          child: Scrollbar(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.isDesktop(context)
              ? EdgeInsets.zero
              : const EdgeInsets.all(Dimensions.paddingSizeSmall),
          physics: const BouncingScrollPhysics(),
          child: FooterView(
            child: Center(
              child: Container(
                width: context.width > 700 ? 700 : context.width,
                padding: context.width > 700
                    ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
                    : null,
                margin: context.width > 700
                    ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
                    : null,
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
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(children: [
                        const SizedBox(height: 50),
                        Text(
                          'Registration'.tr,
                          style: robotoRegular.copyWith(
                              fontSize: 20,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 50),
                        (Get.find<SplashController>()
                                    .configModel!
                                    .refEarningStatus ==
                                1)
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      "Do you have a ",
                                      style: robotoRegular.copyWith(
                                          color: Colors.grey),
                                    ),
                                    Text("Referal Code", style: robotoMedium)
                                  ],
                                ))
                            : const SizedBox(),
                        (Get.find<SplashController>()
                                    .configModel!
                                    .refEarningStatus ==
                                1)
                            ? CustomTextField(
                                hintText: 'refer_code'.tr,
                                controller: _referCodeController,
                                focusNode: _referCodeFocus,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.text,
                                capitalization: TextCapitalization.words,
                                prefixImage: Images.referCode,
                                divider: false,
                                prefixSize: 14,
                                radius: BorderRadius.circular(20),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Please enter your personal information",
                            style: robotoRegular.copyWith(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(children: [
                            CustomTextField(
                              hintText: 'first_name'.tr,
                              controller: _firstNameController,
                              focusNode: _firstNameFocus,
                              nextFocus: _lastNameFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                              prefixImage: Images.user,
                              divider: true,
                              radius: BorderRadius.circular(20),
                            ),
                            CustomTextField(
                              hintText: 'last_name'.tr,
                              controller: _lastNameController,
                              focusNode: _lastNameFocus,
                              nextFocus: _emailFocus,
                              inputType: TextInputType.name,
                              capitalization: TextCapitalization.words,
                              prefixImage: Images.user,
                              divider: true,
                              radius: BorderRadius.circular(20),
                            ),
                            CustomTextField(
                              hintText: 'email'.tr,
                              controller: _emailController,
                              focusNode: _emailFocus,
                              inputType: TextInputType.emailAddress,
                              prefixImage: Images.mail,
                              divider: false,
                            ),
                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        InkWell(
                            onTap: () {
                              //Get.toNamed(RouteHelper.getSignUpRoute());
                              _register(authController, "");
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  vertical: authController.isLoading ? 5 : 15),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                          "COFIRM",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                            )),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("By Signing up you agree to our ,"),
                            InkWell(
                              child: const Text(
                                "Terms of Use",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () {
                                Get.toNamed(RouteHelper.getHtmlRoute(
                                    'terms-and-condition'));
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                      ]));
                }),
              ),
            ),
          ),
        ),
      )),
    );
  }

  void _register(AuthController authController, String countryCode) async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String referCode = _referCodeController.text.trim();

    if (firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
      // } else if (_lastName.isEmpty) {
      //   showCustomSnackBar('enter_your_last_name'.tr);
      // } else if (_email.isEmpty) {
      //   showCustomSnackBar('enter_email_address'.tr);
      // } else if (!GetUtils.isEmail(_email)) {
      //   showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else if (referCode.isNotEmpty && referCode.length != 10) {
      showCustomSnackBar('invalid_refer_code'.tr);
    } else {
      SignUpBody signUpBody = SignUpBody(
          fName: firstName,
          email: email,
          refCode: referCode,
          phone: widget.phone!,
          lName: lastName);
      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
          // Get.toNamed(RouteHelper.getAccessLocationRoute(RouteHelper.signUp));
          Get.toNamed(RouteHelper.getVerificationRoute(
              widget.phone!, status.message, RouteHelper.signUp));
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
