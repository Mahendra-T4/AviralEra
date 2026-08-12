import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:online_course/core/service/logger/logger.dart';

class InternetConnectivityChecker {
  static final InternetConnectivityChecker _instance =
      InternetConnectivityChecker.internal();

  factory InternetConnectivityChecker() => _instance;

  InternetConnectivityChecker.internal();

  final Connectivity _connectivity = Connectivity();

  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();

  StreamSubscription? subscription;

  Timer? _periodicTimer;

  Stream<bool> get connectionStream => _connectionController.stream;

  void startMonitoring() {
    subscription?.cancel();

    subscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) async {
      final connectivityType = result.isNotEmpty
          ? result.first
          : ConnectivityResult.none;

      final hashInternat = await _hashActualInternetConnection(
        connectivityType,
      );

      _connectionController.add(hashInternat);
    });

    _checkAndSet();

    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _checkAndSet(),
    );
  }

  /// Stop monitoring (call on app exit)
  void stopMonitoring() {
    subscription?.cancel();
    subscription = null;
    _periodicTimer?.cancel();
    // _connectionController.close(); // Only close if app is exiting
  }

  Future<void> _checkAndSet() async {
    final hasInternate = await _hashActualInternetConnection();
    _connectionController.add(hasInternate);
    logger.e(
      'Internet Connectivity Checker ${hasInternate ? 'Connected' : 'Disconnected'}',
    );
  }

  Future<bool> _hashActualInternetConnection([
    ConnectivityResult? connectivityResult,
  ]) async {
    if (connectivityResult == null) {
      final result = await _connectivity.checkConnectivity();
      connectivityResult = result.isNotEmpty
          ? result.first
          : ConnectivityResult.none;
    }
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    try {
      final result = await InternetAddress.lookup('8.8.8.8');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      logger.e('Internet Connectivity Checker Error => $e');
      return false;
    }
  }
}
