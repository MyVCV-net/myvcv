import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/widget/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ForgetPassword extends StatefulWidget {
  static const String routeName = '/ForgetPassword';
  const ForgetPassword({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => ForgetPassword(),
    );
  }

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController email = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var authController = Get.put(AuthController());
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(elevation: 0, title: Text('Forget Password')),
          body: SingleChildScrollView(
            child: SizedBox(
                height: Get.height,
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .2,
                        child: Image.asset('assets/Logo_Name.png')),
                    SizedBox(height: 30),
                    Form(
                      key: formKey,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * .08,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40, right: 40),
                          child: TextFormField(
                            controller: email,
                            validator: (emailValue) => emailValue != null &&
                                    !EmailValidator.validate(emailValue)
                                ? 'Enter a valid email'
                                : null,
                            autofillHints: const [AutofillHints.email],
                            keyboardType: TextInputType.emailAddress,
                            decoration:
                                buildInputDecoration(Icons.email, "Email"),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .5,
                        child: ElevatedButton(
                          child: const Text("Continue"),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
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
                              var result = await authController.forgetPassword(
                                  email: email.text);
                              if (result) {
                                Get.back();
                                Get.snackbar("Rest Password Successfully",
                                    "Send Rest Email Successfully");
                              }
                              EasyLoading.dismiss();
                            }
                          },
                        )),
                  ],
                )),
          ),
        ));
  }
}
