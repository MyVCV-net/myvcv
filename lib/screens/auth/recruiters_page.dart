import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/screens/screens.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RecruitersPage extends StatefulWidget {
  static const String routeName = '/RecruitersPage';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => RecruitersPage(),
    );
  }

  const RecruitersPage({Key? key}) : super(key: key);

  @override
  _RecruitersPageState createState() => _RecruitersPageState();
}

class _RecruitersPageState extends State<RecruitersPage> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController businessModel = TextEditingController();
  var businessModelValue;
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
    setState(() {
      if (usernameValue != null) {
        username.text = usernameValue;
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
      appBar: AppBar(elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
                child: SizedBox(
                    width: 100, child: Image.asset('assets/Logo_Name.png'))),
            SizedBox(height: 15),
            const Center(
                child: SizedBox(
                    width: 250,
                    child: Center(
                        child: Text("Recruiters",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A6077)))))),
            SizedBox(height: 15),
            Form(
              key: formKey,
              child: Center(
                  child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      width: 380,
                      height: 400,
                      child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: username,
                                    validator: (companyNameValue) =>
                                        companyNameValue!.isEmpty
                                            ? 'Enter a valid company name'
                                            : null,
                                    decoration: InputDecoration(
                                      labelText: "Company Name",
                                      fillColor: Colors.white,
                                      disabledBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: DropdownButton(
                                    value: businessModelValue,
                                    items: const [
                                      DropdownMenuItem(
                                          value: '1', child: Text('Private')),
                                      DropdownMenuItem(
                                          value: '2', child: Text('Public'))
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        businessModel.text = value.toString();
                                        businessModelValue = value;
                                      });
                                    },
                                    hint: const Text("Business Model"),
                                    disabledHint: const Text("Disabled"),
                                    elevation: 8,
                                    icon: const Icon(
                                        Icons.arrow_drop_down_circle),
                                    iconDisabledColor: Colors.red,
                                    iconEnabledColor: const Color(0xFF0A6077),
                                    isExpanded: true,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: email,
                                    validator: (emailValue) => emailValue !=
                                                null &&
                                            !EmailValidator.validate(emailValue)
                                        ? 'Enter a valid email'
                                        : null,
                                    autofillHints: const [AutofillHints.email],
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
            SizedBox(height: 15),
            Center(
                child: SizedBox(
                    width: 250,
                    height: 45,
                    child: ElevatedButton(
                      child: const Text("Register"),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFD0AB37)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ))),
                      onPressed: () async {
                        //  businessModel
                        final form = formKey.currentState!;
                        if (form.validate() && businessModelValue != null) {
                          EasyLoading.show(
                            status: 'loading...',
                            maskType: EasyLoadingMaskType.black,
                          );
                          var result = await authController
                              .createUserWithEmailAndPassword(
                                  username: username.text,
                                  email: email.text,
                                  password: password.text,
                                  isJobSeeker: false,
                                  businessModel: businessModel.text);
                          if (result) {
                            EasyLoading.dismiss();
                            Get.offAll(HomePage());
                          }
                        } else if (businessModelValue == null) {
                          EasyLoading.dismiss();
                          Get.snackbar("Error", "Please Select Business Model");
                        } else {
                          EasyLoading.dismiss();
                          Get.snackbar(
                              "Error", "Somthing wrong please try again");
                        }
                      },
                    ))),
          ],
        ),
      ),
    );
  }
}
