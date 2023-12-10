import 'package:quickad_it_solutions/data/model/response/language_model.dart';
import 'package:quickad_it_solutions/util/app_constants.dart';
import 'package:flutter/material.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }
}
