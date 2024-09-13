import 'dart:io';

import 'package:flutter/material.dart';

class PostFormController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  File? image;

  void dispose() {
    nameController.dispose();
    breedController.dispose();
    typeController.dispose();
    weightController.dispose();
    ageController.dispose();
    locationController.dispose();
  }

  bool validateInputs() {
    return nameController.text.isNotEmpty &&
        breedController.text.isNotEmpty &&
        typeController.text.isNotEmpty &&
        weightController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        image != null &&
        locationController.text.isNotEmpty;
  }

  void clearInputs() {
    nameController.clear();
    breedController.clear();
    typeController.clear();
    weightController.clear();
    ageController.clear();
    locationController.clear();
    image = null;
  }
}
