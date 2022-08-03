import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/screens/home/home_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class JobSeekerPage extends StatefulWidget {
  static const String routeName = '/JobSeekerPage';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => JobSeekerPage(),
    );
  }

  const JobSeekerPage({Key? key}) : super(key: key);

  @override
  _JobSeekerPageState createState() => _JobSeekerPageState();
}

class _JobSeekerPageState extends State<JobSeekerPage> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    var authController = Get.put(AuthController());
    // print(authController.user.length);
    var usernameValue = authController.isFromSource.value
        ? authController.user.isNotEmpty
            ? authController.user[0].username
            : null
        : null;

    var emailValue = authController.isFromSource.value
        ? authController.user.isNotEmpty
            ? authController.user[0].email
            : null
        : null;
    // print(emailValue);
    setState(() {
      if (usernameValue != null) {
        var splitValue = usernameValue.split(" ");
        if (splitValue.length == 2) {
          firstName.text = splitValue[0];
          lastName.text = splitValue[1];
        } else {
          firstName.text = usernameValue;
        }
      }
      if (emailValue != null) {
        email.text = emailValue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var authController = Get.put(AuthController());
    return Scaffold(
      extendBody: true,
      appBar: AppBar(elevation: 0),
      body: SizedBox(
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                  child: SizedBox(
                      width: 100, child: Image.asset('assets/Logo_Name.png'))),
              SizedBox(
                height: 20,
              ),
              const Center(
                  child: SizedBox(
                      width: 250,
                      child: Center(
                          child: Text("Job Seeker",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A6077)))))),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Center(
                    child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        width: 380,
                        height: 430,
                        child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: firstName,
                                      validator: (firstNameValue) =>
                                          firstNameValue!.isEmpty
                                              ? 'Enter a valid first name'
                                              : null,
                                      decoration: InputDecoration(
                                        labelText: "First Name",
                                        fillColor: Colors.white,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: lastName,
                                      validator: (lastNameValue) =>
                                          lastNameValue!.isEmpty
                                              ? 'Enter a valid last name'
                                              : null,
                                      decoration: InputDecoration(
                                        labelText: "Last Name",
                                        fillColor: Colors.white,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: email,
                                      validator: (emailValue) =>
                                          emailValue != null &&
                                                  !EmailValidator.validate(
                                                      emailValue)
                                              ? 'Enter a valid email'
                                              : null,
                                      autofillHints: const [
                                        AutofillHints.email
                                      ],
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        labelText: "Email",
                                        fillColor: Colors.white,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: password,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Enter a valid password";
                                        }
                                        if (val.length < 6) {
                                          return "Password must be atleast 6 characters long";
                                        }
                                        if (val.length > 20) {
                                          return "Password must be less than 20 characters";
                                        }
                                        if (!val.contains(RegExp(r'[0-9]'))) {
                                          return "Password must contain a number";
                                        }
                                      },
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText: "Password",
                                        fillColor: Colors.white,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )))),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: SizedBox(
                      width: 250,
                      height: 45,
                      child: ElevatedButton(
                          child: const Text("Register"),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFFD0AB37)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ))),
                          onPressed: () async {
                            final form = formKey.currentState!;
                            // if (authController.isFromSource.value) {
                            //   print(authController.loginTypeValue.value);
                            //   var linkResult = await authController
                            //       .linkWithCredentialJobSeeker(
                            //           username:
                            //               "${firstName.text} ${lastName.text}",
                            //           password: password.text,
                            //           email: email.text,
                            //           isJobSeeker: true);

                            //   if (linkResult) {
                            //     Get.offAll(HomePage());
                            //   }
                            // } else {

                            if (form.validate()) {
                              EasyLoading.show(
                                status: 'loading...',
                                maskType: EasyLoadingMaskType.black,
                              );
                              var result = await authController
                                  .createUserWithEmailAndPassword(
                                      username:
                                          "${firstName.text} ${lastName.text}",
                                      password: password.text,
                                      email: email.text,
                                      isJobSeeker: true,
                                      businessModel: '');
                              if (result) {
                                EasyLoading.dismiss();
                                Get.offAll(HomePage());
                              } else {
                                EasyLoading.dismiss();
                                Get.snackbar(
                                    "Error", "Somthing wrong please try again");
                              }
                            }
                          }
                          // },
                          ))),
            ],
          ),
        ),
      ),
    );
  }
}
