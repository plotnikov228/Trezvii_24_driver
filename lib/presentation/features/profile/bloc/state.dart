import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trezvii_24_driver/presentation/utils/status_enum.dart';

class ProfileState {
  final Status status;
  final TextEditingController? name;
  final TextEditingController? email;
  final String? imageUrl;
  final File? imageFile;

  ProfileState( {this.imageUrl, this.imageFile, this.status = Status.Success, this.name,  this.email});

}