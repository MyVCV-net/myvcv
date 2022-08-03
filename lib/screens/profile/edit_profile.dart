import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/repositories/firebase_controller.dart';
import 'package:myvcv/widget/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditProfile extends StatefulWidget {
  static const String routeName = '/EditProfile';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => EditProfile(),
    );
  }

  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController majorController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var genderControllerValue;
  DateTime? dobControllerValue = DateTime.now();
  var imageFile;
  XFile? pickedFile;
  @override
  void initState() {
    super.initState();
    final AuthController authController = Get.find();
    nameController.text = authController.username;
    majorController.text = authController.major;
    genderControllerValue = authController.user[0].gender != null &&
            authController.user[0].gender != ''
        ? authController.user[0].gender
        : null;
    genderController.text = genderControllerValue ?? '';
    dobController.text = authController.user[0].dob;
    countryController.text = authController.user[0].country != null &&
            authController.user[0].country != ''
        ? authController.user[0].country
        : 'US';
    cityController.text = authController.user[0].city;
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    final FirebaseController firebaseController = Get.find();

    return Scaffold(
      appBar: CustomAppBar(
        title: "Edit Profile",
        chatIcon: false,
        searchIcon: false,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            Center(
                child: InkWell(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text('Profile Picture'),
                    content: Column(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .5,
                            child: ElevatedButton(
                              child: const Text("Pick Image"),
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
                                EasyLoading.show(
                                  status: 'loading...',
                                  maskType: EasyLoadingMaskType.black,
                                );
                                try {
                                  final ImagePicker _picker = ImagePicker();
                                  pickedFile = await _picker.pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (pickedFile == null) {
                                    EasyLoading.dismiss();
                                    return;
                                  }
                                  if (pickedFile != null) {
                                    setState(() {
                                      imageFile = File(pickedFile!.path);
                                    });
                                    EasyLoading.dismiss();
                                  }
                                  Get.back();
                                } on PlatformException catch (e) {
                                  print(e);
                                  EasyLoading.dismiss();
                                } catch (e) {
                                  EasyLoading.dismiss();
                                  print(e);
                                }
                              },
                            )),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .5,
                            child: ElevatedButton(
                              child: const Text("Camera"),
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
                                final ImagePicker _picker = ImagePicker();
                                pickedFile = await _picker.pickImage(
                                  source: ImageSource.camera,
                                );
                                if (imageFile != null) {
                                  setState(() {
                                    imageFile = File(pickedFile!.path);
                                    print(imageFile);
                                  });
                                }

                                Get.back();
                              },
                            )),
                      ],
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  imageFile != null
                      ? Container(
                          child: CircleAvatar(
                            radius: 60.0,
                            backgroundImage: Image.file(
                              imageFile,
                              fit: BoxFit.cover,
                            ).image,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                          ),
                        )
                      : authController.user[0].userImageUrl != '' ||
                              authController.user[0].userImageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: authController.userImageUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(60)),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/account.png',
                                height: 120,
                                width: 120,
                              ),
                            )
                          : Image.asset(
                              'assets/account.png',
                              height: 120,
                              width: 120,
                            ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Icon(
                      Icons.camera_alt_outlined,
                    ),
                  )
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Card(
                      color: Theme.of(context).primaryColor,
                      child: TextFormField(
                        // maxLength: 50,
                        controller: nameController,
                        validator: (nameValue) =>
                            nameValue == '' || nameValue == null
                                ? 'Enter a valid username'
                                : null,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          labelText: authController.isJobSeeker
                              ? 'Your Name'
                              : 'Company Name',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      color: Theme.of(context).primaryColor,
                      child: TextFormField(
                        controller: majorController,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          labelText: 'Job Title',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    authController.isJobSeeker
                        ? Card(
                            color: Theme.of(context).primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: DropdownButton(
                                value: genderControllerValue,
                                items: const [
                                  DropdownMenuItem(
                                    child: Text("Male"),
                                    value: "Male",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Female"),
                                    value: "Female",
                                  )
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    genderController.text = value.toString();
                                    genderControllerValue = value;
                                  });
                                },
                                hint: const Text("Gender"),
                                disabledHint: const Text("Disabled"),
                                elevation: 8,
                                // style: TextStyle(color: Colors.white, fontSize: 16),
                                icon: const Icon(Icons.arrow_drop_down_circle),
                                iconDisabledColor: Colors.red,
                                iconEnabledColor: const Color(0xFF0A6077),
                                isExpanded: true,
                                // dropdownColor: Colors.deepOrange,
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        child: TextFormField(
                          controller: dobController,
                          readOnly: true,
                          onTap: () async {
                            DateTime? newDateTime = await showRoundedDatePicker(
                                context: context,
                                initialDate: dobControllerValue,
                                theme: Get.theme,
                                height: Get.height / 2,
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now());
                            print(newDateTime);
                            if (newDateTime != null) {
                              setState(() {
                                dobControllerValue = newDateTime;
                                var month;
                                if (newDateTime.month < 10) {
                                  month = "0${newDateTime.month}";
                                } else {
                                  month = "${newDateTime.month}";
                                }

                                var day;
                                if (newDateTime.day < 10) {
                                  day = "0${newDateTime.day}";
                                } else {
                                  day = "${newDateTime.day}";
                                }

                                dobController.text =
                                    "${newDateTime.year}/$month/$day";
                              });
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            labelText: authController.isJobSeeker
                                ? 'Date of birth'
                                : 'Date of Creation',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      color: Theme.of(context).primaryColor,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Country')),
                          ),
                          CountryCodePicker(
                            onChanged: (value) {
                              countryController.text = value.code.toString();
                            },
                            dialogSize: Size.square(350),
                            dialogBackgroundColor:
                                Theme.of(context).primaryColor,
                            initialSelection:
                                authController.user[0].country != null &&
                                        authController.user[0].country != ''
                                    ? authController.user[0].country
                                    : 'US',
                            showCountryOnly: true,
                            showOnlyCountryWhenClosed: true,
                            alignLeft: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      color: Theme.of(context).primaryColor,
                      child: TextFormField(
                        controller: cityController,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          labelText: 'City',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: GestureDetector(
                          onTap: () async {
                            final form = formKey.currentState!;
                            if (form.validate()) {
                              if (nameController.text !=
                                      authController.username ||
                                  majorController.text !=
                                      authController.major ||
                                  genderController.text !=
                                      authController.user[0].gender ||
                                  dobController.text !=
                                      authController.user[0].dob ||
                                  countryController.text !=
                                      authController.user[0].country ||
                                  cityController.text !=
                                      authController.user[0].city ||
                                  imageFile != null) {
                                EasyLoading.show(
                                  status: 'loading...',
                                  maskType: EasyLoadingMaskType.black,
                                );
                                var updateResult =
                                    await firebaseController.changeUserProfile(
                                        imagePath: pickedFile,
                                        username: nameController.text,
                                        major: majorController.text,
                                        gender: genderController.text,
                                        dob: dobController.text,
                                        country: countryController.text,
                                        city: cityController.text);
                                if (updateResult) {
                                  EasyLoading.dismiss();
                                  Get.back();
                                } else {
                                  EasyLoading.dismiss();
                                }
                              } else {
                                print('image: ${imageFile}');
                                print('username: ${nameController.text}');
                                print('major: ${majorController.text}');
                                print('gender: ${genderController.text}');
                                print('dob: ${dobController.text}');
                                print('county: ${countryController.text}');
                                print('city: ${cityController.text}');
                                Get.snackbar("Nothing Change",
                                    "Change Your Profile Data To Update it");
                              }
                            }
                          },
                          child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0A6077),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 7,
                                    offset: const Offset(
                                        2, 2), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: const Center(
                                  child: Text("Update Changes",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      )))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
