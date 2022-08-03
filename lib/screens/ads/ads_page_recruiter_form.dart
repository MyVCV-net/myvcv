import 'package:country_code_picker/country_code_picker.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:myvcv/repositories/ads/recruiter_controller.dart';
import 'package:myvcv/repositories/firebase_controller.dart';
import 'package:myvcv/widget/widgets.dart';

class AdsPageRecruiterForm extends StatefulWidget {
  const AdsPageRecruiterForm({Key? key}) : super(key: key);
  static const String routeName = '/AdsPageRecruiterForm';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => AdsPageRecruiterForm(),
    );
  }

  @override
  _AdsPageRecruiterFormState createState() => _AdsPageRecruiterFormState();
}

class _AdsPageRecruiterFormState extends State<AdsPageRecruiterForm> {
  //define the controller and variables
  DateTime? firstDateValue = DateTime.now();
  TextEditingController firstDateController = TextEditingController();
  DateTime? lastDateValue = DateTime.now();
  TextEditingController lastDateController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController jobCategoryController = TextEditingController();
  var jobCategoryValue;
  TextEditingController academicSpecializationController =
      TextEditingController();
  var academicSpecializationValue;
  TextEditingController genderController = TextEditingController();
  var genderValue;
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController experienceYearsController = TextEditingController();
  TextEditingController jobDescriptionPointTwo = TextEditingController();
  TextEditingController jobDescriptionPointOne = TextEditingController();
  TextEditingController ageController = TextEditingController();
  RangeLabels labels = RangeLabels('18', "88");
  RangeValues values = RangeValues(18, 88);

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final RecruiterForm recruiterForm =
        Get.put(RecruiterForm(), permanent: true);
    return Scaffold(
        appBar: CustomAppBar(
          title: "Ads",
          searchIcon: false,
          chatIcon: false,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                controller: jobTitleController,
                                maxLength: 50,
                                validator: (jobTitle) => jobTitle == ''
                                    ? 'Enter a valid job title'
                                    : null,
                                decoration: InputDecoration(
                                  labelText: 'Job Title*',
                                ),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Job Description*')),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: TextFormField(
                              controller: jobDescriptionPointOne,
                              validator: (jobDescOne) => jobDescOne == ''
                                  ? 'Enter first job description'
                                  : null,
                              maxLength: 150,
                              maxLines: 2,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                              validator: (jobDescTwo) => jobDescTwo == ''
                                  ? 'Enter second job description'
                                  : null,
                              controller: jobDescriptionPointTwo,
                              maxLength: 150,
                              maxLines: 2,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            width: Get.width,
                            height: 70,
                            child: DropdownButtonFormField(
                              validator: (value) => value == null
                                  ? 'Please select job category'
                                  : null,
                              value: jobCategoryValue,
                              items: recruiterForm.jobCategory,
                              onChanged: (value) {
                                setState(() {
                                  jobCategoryValue = value.toString();
                                  jobCategoryController.text = value.toString();
                                });
                              },
                              hint: const Text("Select job category"),
                              disabledHint: const Text("Disabled"),
                              elevation: 8,
                              icon: const Icon(Icons.arrow_drop_down_circle),
                              iconDisabledColor: Colors.red,
                              iconEnabledColor: const Color(0xFF0A6077),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            width: Get.width,
                            height: 70,
                            child: DropdownButtonFormField(
                              validator: (value) => value == null
                                  ? 'Please select academic specialization'
                                  : null,
                              value: academicSpecializationValue,
                              items: recruiterForm.academicSpecialization,
                              onChanged: (value) {
                                setState(() {
                                  academicSpecializationValue =
                                      value.toString();
                                  academicSpecializationController.text =
                                      value.toString();
                                });
                              },
                              hint: const Text("Academic specialization"),
                              disabledHint: const Text("Disabled"),
                              elevation: 8,
                              icon: const Icon(Icons.arrow_drop_down_circle),
                              iconDisabledColor: Colors.red,
                              iconEnabledColor: const Color(0xFF0A6077),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                controller: experienceYearsController,
                                keyboardType: TextInputType.number,
                                validator: (expValue) =>
                                    expValue == null || expValue == ''
                                        ? 'Enter a valid experience years'
                                        : int.parse(expValue) > 35
                                            ? 'less than 35'
                                            : null,
                                decoration: InputDecoration(
                                  labelText: 'Experience years',
                                ),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Age category')),
                          RangeSlider(
                              divisions: 88,
                              activeColor: Colors.red[700],
                              inactiveColor: Colors.red[300],
                              min: 18,
                              max: 88,
                              values: values,
                              labels: labels,
                              onChanged: (value) {
                                // print(
                                //     "START: ${value.start.toInt()}, End: ${value.end.toInt()}");
                                setState(() {
                                  values = value;
                                  labels = RangeLabels(
                                      "${value.start.toInt().toString()}",
                                      "${value.end.toInt().toString()}");
                                  ageController.text =
                                      '${values.start.toInt()}-${values.end.toInt()}';
                                });
                                // print(labels);
                              }),
                          Text('${values.start.toInt()}-${values.end.toInt()}'),
                          Container(
                            padding: const EdgeInsets.all(8),
                            width: Get.width,
                            height: 70,
                            child: DropdownButtonFormField(
                              validator: (value) =>
                                  value == null ? 'Please select gender' : null,
                              value: genderValue,
                              items: recruiterForm.gender,
                              onChanged: (value) {
                                setState(() {
                                  genderValue = value.toString();
                                  genderController.text = value.toString();
                                });
                              },
                              hint: const Text("Gender"),
                              disabledHint: const Text("Disabled"),
                              elevation: 8,
                              icon: const Icon(Icons.arrow_drop_down_circle),
                              iconDisabledColor: Colors.red,
                              iconEnabledColor: const Color(0xFF0A6077),
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Country'),
                                ),
                              ),
                              CountryCodePicker(
                                onChanged: (value) {
                                  print(value.name.toString());
                                  countryController.text =
                                      value.name.toString();
                                },
                                dialogSize: Size.square(350),
                                dialogBackgroundColor:
                                    Theme.of(context).primaryColor,
                                initialSelection: 'US',
                                showCountryOnly: true,
                                showOnlyCountryWhenClosed: true,
                                alignLeft: true,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                              controller: cityController,
                              validator: (value) =>
                                  value == '' ? 'Enter a valid city' : null,
                              decoration: const InputDecoration(
                                labelText: 'City',
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 200,
                                  padding: const EdgeInsets.all(8),
                                  child: TextFormField(
                                    controller: salaryController,
                                    validator: (value) => value == ''
                                        ? 'Enter a valid salary'
                                        : null,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Salary',
                                    ),
                                  )),
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue.shade200),
                                  ),
                                  onPressed: () {
                                    showCurrencyPicker(
                                      context: context,
                                      showFlag: true,
                                      showCurrencyName: true,
                                      showCurrencyCode: true,
                                      onSelect: (Currency currency) {
                                        print(
                                            'Select currency: ${currency.name}');
                                        setState(() {
                                          currencyController.text =
                                              currency.code;
                                        });
                                      },
                                      favorite: ['SEK'],
                                    );
                                  },
                                  child: currencyController.text != null &&
                                          currencyController.text != ''
                                      ? Text('${currencyController.text}')
                                      : Text('Currency'),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {},
                            child: TextFormField(
                              controller: firstDateController,
                              readOnly: true,
                              validator: (firstDate) =>
                                  firstDate == '' ? 'Enter valid date' : null,
                              onTap: () async {
                                DateTime? newDateTime =
                                    await showRoundedDatePicker(
                                        context: context,
                                        initialDate: firstDateValue,
                                        theme: Get.theme,
                                        height: Get.height / 2,
                                        firstDate:
                                            DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day - 1),
                                        lastDate: DateTime(
                                            DateTime.now().year + 1,
                                            DateTime.now().month,
                                            DateTime.now().day));
                                if (newDateTime != null) {
                                  setState(() {
                                    firstDateValue = newDateTime;
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

                                    firstDateController.text =
                                        "${newDateTime.year}-$month-$day";
                                    lastDateValue = DateTime(
                                        firstDateValue!.year,
                                        firstDateValue!.month,
                                        firstDateValue!.day + 7);
                                  });
                                }
                              },
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                labelText: 'First day for offer*',
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: TextFormField(
                              controller: lastDateController,
                              readOnly: true,
                              // validator: (lastDate) =>
                              //     lastDate == '' ? 'Enter valid date' : null,
                              onTap: () async {
                                DateTime? newDateTime =
                                    await showRoundedDatePicker(
                                  context: context,
                                  initialDate: lastDateValue,
                                  theme: Get.theme,
                                  height: Get.height / 2,
                                  firstDate: DateTime(
                                      firstDateValue!.year,
                                      firstDateValue!.month,
                                      firstDateValue!.day + 7),
                                  lastDate: DateTime(
                                      firstDateValue!.year,
                                      firstDateValue!.month + 1,
                                      firstDateValue!.day + 7),
                                );
                                if (newDateTime != null) {
                                  setState(() {
                                    lastDateValue = newDateTime;
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

                                    lastDateController.text =
                                        "${newDateTime.year}-$month-$day";
                                  });
                                }
                              },
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                labelText: 'Last day for offer*',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        child: ElevatedButton(
                          child: const Text("Add",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              )),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF0A6077)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                          onPressed: () async {
                            final form = formKey.currentState!;
                            if (form.validate()) {
                              if (currencyController.text == '' ||
                                  currencyController.text == null) {
                                Get.snackbar(
                                    "Currancy", "Please select currency");
                              } else {
                                EasyLoading.show(
                                  status: 'loading...',
                                  maskType: EasyLoadingMaskType.black,
                                );

                                final firebaseController =
                                    Get.put(FirebaseController());
                                var addResult = await firebaseController.addAds(
                                    title: jobTitleController.text,
                                    descOne: jobDescriptionPointOne.text,
                                    descTwo: jobDescriptionPointTwo.text,
                                    jobCategory: jobCategoryController.text,
                                    academicSpecialization:
                                        academicSpecializationController.text,
                                    experianceYears:
                                        experienceYearsController.text,
                                    ageCategory: ageController.text,
                                    gender: genderController.text,
                                    country: countryController.text,
                                    city: cityController.text,
                                    salary: salaryController.text,
                                    currency: currencyController.text,
                                    firstDate: firstDateController.text,
                                    lastDate: lastDateController.text);
                                if (addResult) {
                                  EasyLoading.dismiss();
                                  Get.back();
                                  Get.snackbar("Added", "Add ads successfully");
                                } else {
                                  EasyLoading.dismiss();
                                  Get.snackbar("Error",
                                      "Something wrong please try again");
                                }
                              }
                            }
                          },
                        )),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
