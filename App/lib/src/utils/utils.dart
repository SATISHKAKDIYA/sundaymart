import 'package:connectivity_plus/connectivity_plus.dart';

mixin Utils {
  static Future<bool> checkInternetConnectivity() async {
    //bool connection = await DataConnectionChecker().hasConnection;

    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return false;
    }
  }
}
