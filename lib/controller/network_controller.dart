import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  bool _isCheckingConnectivity = false;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(
      List<ConnectivityResult> connectivityResults) async {
    if (connectivityResults.contains(ConnectivityResult.none)) {
      if (!_isCheckingConnectivity) {
        _isCheckingConnectivity = true;
        Get.dialog(
          Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        await Future.delayed(Duration(seconds: 2));

        // Check connectivity again after the delay
        final currentConnectivity = await _connectivity.checkConnectivity();
        print(
            'Current connectivity after delay: $currentConnectivity'); // Debugging log
        if (currentConnectivity.contains(ConnectivityResult.none)) {
          Get.back(); // Close the loading indicator
          Get.rawSnackbar(
            messageText: Text('Connect to the internet'),
            isDismissible: false,
            duration: Duration(days: 1),
          );
        } else {
          Get.back(); // Close the loading indicator
        }
        _isCheckingConnectivity = false;
      }
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
      if (_isCheckingConnectivity) {
        Get.back(); // Close the loading indicator
        _isCheckingConnectivity = false;
      }
    }
  }
}
