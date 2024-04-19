import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon prefixIcon;
  String? inputType;
  Function? validator;
  String? preDefinedText;
  //Icon? suffixIcon;
  void Function(String)? onChanged;

  MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
    this.validator,
    this.onChanged,
    this.inputType,
    this.preDefinedText,
    //this.suffixIcon
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: const [AutofillHints.email],
      validator: (text) {
        if (widget.inputType == 'email') {
          if (!isEmail(text!.trim())) {
            return 'Enter valid email';
          }
        } else if (widget.inputType == 'password') {
          if (!isLength(text!, 6)) {
            return 'password must be atleast 6 characters long\npassword must contain numbers and alphabets ';
          }
          if (!isAlphanumeric(text)) {
            return 'password must be atleast 6 characters long\npassword must contain numbers and alphabets ';
          }
        } else if (widget.inputType == "username") {
          if (!isAlphanumeric(text!)) {
            return 'username should contain only \nalphabets and numbers';
          }
        }
        return null;
      },
      onChanged: widget.onChanged,
      //onTapOutside: (event) {},
    
      maxLines: 1,
      controller: widget.controller,
      decoration: InputDecoration(
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        isDense: true,
        fillColor: Colors.white,
        filled: true,
        prefixIcon: widget.prefixIcon,
        prefixIconColor: const Color(0xffFF8911),
        //suffixIcon: widget.suffixIcon!=null? widget.suffixIcon:null,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 2.0),
            borderRadius: BorderRadius.circular(10)),
        hintText: widget.hintText,
        hintStyle:
            const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
        focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color(0xffFF8911), width: 2.0),
            borderRadius: BorderRadius.circular(10)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.circular(10)),
      ),
      obscureText: widget.obscureText,
    );
  }
}
