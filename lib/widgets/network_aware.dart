import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkAware extends StatefulWidget {
  final Widget onlineChild;
  final Widget? offlineChild;
  final VoidCallback? reload;

  const NetworkAware({
    super.key,
    this.reload,
    this.offlineChild,
    required this.onlineChild,
  });

  @override
  State<NetworkAware> createState() => _NetworkAwareState();
}

class _NetworkAwareState extends State<NetworkAware> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _updateConnectionStatusList,
    );
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      if (!mounted) return;
      setState(() => _connectionStatus = result as ConnectivityResult);
    } catch (e) {
      debugPrint('Could not check connectivity status: $e');
    }
  }

  void _updateConnectionStatusList(List<ConnectivityResult> results) {
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    setState(() => _connectionStatus = result);
    if (result != ConnectivityResult.none) {
      widget.reload?.call();
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _connectionStatus != ConnectivityResult.none
        ? widget.onlineChild
        : widget.offlineChild ?? const SizedBox();
  }
}
