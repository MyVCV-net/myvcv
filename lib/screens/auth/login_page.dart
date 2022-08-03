import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/screens/screens.dart';
import 'package:myvcv/widget/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/LoginPage';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => LoginPage(),
    );
  }

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(toolbarHeight: 0, elevation: 0),
          body: SingleChildScrollView(
            child: SizedBox(
              height: Get.height,
              child: GetBuilder<AuthController>(
                init: AuthController(),
                builder: (authController) => SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * .2,
                          child: Image.asset('assets/Logo_Name.png')),
                      Image.asset('assets/LoginPageChart.png'),
                      //Login Form
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1,
                              height: MediaQuery.of(context).size.height * .08,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, right: 40),
                                child: TextFormField(
                                  controller: email,
                                  validator: (emailValue) => emailValue !=
                                              null &&
                                          !EmailValidator.validate(emailValue)
                                      ? 'Enter a valid email'
                                      : null,
                                  autofillHints: const [AutofillHints.email],
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: buildInputDecoration(
                                      Icons.email, "Email"),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1,
                              height: MediaQuery.of(context).size.height * .08,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, right: 40),
                                child: TextFormField(
                                  controller: password,
                                  validator: (passwordValue) =>
                                      passwordValue == ''
                                          ? 'Enter a valid password'
                                          : null,
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  decoration: buildInputDecoration(
                                      Icons.lock, "Password"),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                          width: MediaQuery.of(context).size.width * .5,
                          child: ElevatedButton(
                            child: const Text("Continue"),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xFFD0AB37)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),
                            onPressed: () async {
                              final form = formKey.currentState!;
                              if (form.validate()) {
                                EasyLoading.show(
                                  status: 'loading...',
                                  maskType: EasyLoadingMaskType.black,
                                );
                                var result = await authController
                                    .loginWithEmailAndPassword(
                                        email.text, password.text);
                                EasyLoading.dismiss();
                                if (result) {
                                  Get.offAll(() => HomePage());
                                }
                              }
                            },
                          )),
                      Column(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Center(
                                  child: GestureDetector(
                                      child: const Text("Forget Password?"),
                                      onTap: () {
                                        Get.to(() => ForgetPassword());
                                      }))),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: const Center(
                                  child: Divider(color: Colors.black))),
                        ],
                      ), //All Auth Button

                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .7,
                            child: SignInButton(
                              Buttons.Google,
                              text: "Sign up with Google",
                              onPressed: () async {
                                try {
                                  EasyLoading.show(
                                    status: 'loading...',
                                    maskType: EasyLoadingMaskType.black,
                                  );
                                  var googleResult =
                                      await authController.googleSignAuth();
                                  EasyLoading.dismiss();
                                  if (googleResult == "true") {
                                    Get.offAll(() => HomePage());
                                  } else if (googleResult == "new") {
                                    Get.to(() => SignUpPage());
                                  }
                                } on PlatformException catch (err) {
                                  print(err);
                                  EasyLoading.dismiss();
                                } catch (e) {
                                  print(e);
                                  EasyLoading.dismiss();
                                }
                              },
                            ),
                          ),

                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * .7,
                          //   child: SignInButton(
                          //     Buttons.AppleDark,
                          //     text: "Sign up with Apple",
                          //     onPressed: () {
                          //       // porvider.appleLogin();
                          //     },
                          //   ),
                          // ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .7,
                            child: SignInButton(
                              Buttons.Facebook,
                              text: "Sign up with Facebook",
                              onPressed: () async {
                                EasyLoading.show(
                                  status: 'loading...',
                                  maskType: EasyLoadingMaskType.black,
                                );
                                var facebookResult =
                                    await authController.facebookLogin();
                                print(facebookResult);
                                EasyLoading.dismiss();
                                if (facebookResult == "true") {
                                  Get.offAll(() => HomePage());
                                } else if (facebookResult == "new") {
                                  Get.to(() => SignUpPage());
                                }
                              },
                            ),
                          ),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * .7,
                          //   child: SignInButton(
                          //     Buttons.Twitter,
                          //     text: "Sign up with Twitter",
                          //     onPressed: () {
                          //       // porvider.twitterLoginSaleh();
                          //     },
                          //   ),
                          // ),
                          Center(
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width * .7,
                                  child: ElevatedButton(
                                    child: const Text(
                                      "Create new account",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0xFF14917A)),
                                    ),
                                    onPressed: () {
                                      Get.to(() => SignUpPage());
                                    },
                                  ))),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
