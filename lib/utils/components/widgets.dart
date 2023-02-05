import 'package:catcher/handlers/snackbar_handler.dart';
import 'package:flutter/material.dart';

Widget buildItemPrice(crypto, isLoadingCompleteData) {
  return isLoadingCompleteData
      ? const Text(
          "\$",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20, color: Colors.blue),
        )
      : Text(
          "${crypto.priceInUSD().toStringAsFixed(2)}\$",
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20, color: Colors.blue),
        );
}

SnackbarHandler catcherHandler() {
  return SnackbarHandler(
    const Duration(seconds: 5),
    backgroundColor: const Color.fromRGBO(158, 42, 43, 1),
    elevation: 2,
    customMessage: "",
    printLogs: false,
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    behavior: SnackBarBehavior.floating,
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
  );
}
