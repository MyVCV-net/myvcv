import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/models/models.dart';

class RecruiterForm extends GetxController {
  List<FormModel> jobCategoryData = <FormModel>[].obs;
  List<DropdownMenuItem<String>> jobCategory = <DropdownMenuItem<String>>[].obs;
  List<FormModel> academicSpecializationData = <FormModel>[].obs;
  List<DropdownMenuItem<String>> academicSpecialization =
      <DropdownMenuItem<String>>[].obs;
  List<FormModel> genderData = <FormModel>[].obs;
  List<DropdownMenuItem<String>> gender = <DropdownMenuItem<String>>[].obs;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  void onInit() async {
    super.onInit();
    await getJobCategory();
    await getAcademicSpecialization();
    await getGender();
  }

  Future getJobCategory() async {
    DocumentSnapshot ds = await _firebaseFirestore
        .collection('recruiter_form')
        .doc('job_category')
        .get();
    var businessModel = ds.data() as Map<String, dynamic>;
    for (var typeList in businessModel['data']) {
      jobCategoryData
          .add(FormModel(id: typeList['id'], name: typeList['name']));
      jobCategory.add(DropdownMenuItem(
          value: typeList['id'], child: Text(typeList['name'])));
      update();
    }
  }

  Future getAcademicSpecialization() async {
    DocumentSnapshot ds = await _firebaseFirestore
        .collection('recruiter_form')
        .doc('academic_specialisation')
        .get();
    var businessModel = ds.data() as Map<String, dynamic>;
    for (var typeList in businessModel['data']) {
      academicSpecializationData
          .add(FormModel(id: typeList['id'], name: typeList['name']));
      academicSpecialization.add(DropdownMenuItem(
          value: typeList['id'], child: Text(typeList['name'])));
      update();
    }
  }

  Future getGender() async {
    DocumentSnapshot ds = await _firebaseFirestore
        .collection('recruiter_form')
        .doc('gender')
        .get();
    var businessModel = ds.data() as Map<String, dynamic>;
    for (var typeList in businessModel['data']) {
      genderData.add(FormModel(id: typeList['id'], name: typeList['name']));
      gender.add(DropdownMenuItem(
          value: typeList['id'], child: Text(typeList['name'])));
      update();
    }
  }
}
