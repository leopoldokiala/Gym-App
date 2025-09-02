import 'package:flutter/material.dart';
import 'package:gym_app/_comum/minhas_cores.dart';

InputDecoration getAuthenticationInputDecoration(String label, {Icon? icon}) {
  return InputDecoration(
    icon: icon,
    hintText: label,
    fillColor: Colors.white,
    filled: true,
    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(64.0)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(64.0),
      borderSide: BorderSide(color: Colors.black),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(64.0),
      borderSide: BorderSide(color: MinhasCores.azulEscuro, width: 4.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(64.0),
      borderSide: BorderSide(color: Colors.red, width: 2.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(64.0),
      borderSide: BorderSide(color: Colors.red, width: 4.0),
    ),
  );
}
