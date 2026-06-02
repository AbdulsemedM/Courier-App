import 'package:courier_app/core/update/force_update_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateGate extends StatefulWidget {
  final Widget child;

  const ForceUpdateGate({super.key, required this.child});

  @override
  State<ForceUpdateGate> createState() => _ForceUpdateGateState();
}

class _ForceUpdateGateState extends State<ForceUpdateGate> {
  final ForceUpdateService _service = const ForceUpdateService();

  bool _isLoading = true;
  ForceUpdateCheckResult _result =
      const ForceUpdateCheckResult(shouldBlock: false);

  @override
  void initState() {
    super.initState();
    _checkUpdate();
  }

  Future<void> _checkUpdate() async {
    final result = await _service.checkForRequiredUpdate();
    if (!mounted) return;
    setState(() {
      _result = result;
      _isLoading = false;
    });
  }

  Future<void> _openStore() async {
    final url = _result.storeUrl;
    if (url == null || url.isEmpty) return;

    final uri = Uri.tryParse(url);
    if (uri == null) return;

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open store link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_result.shouldBlock) {
      return widget.child;
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.system_update, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Update Required',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A newer version is available. Please update to continue using the app.',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  if (_result.storeVersion != null &&
                      _result.localVersion != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Installed: ${_result.localVersion}  |  Latest: ${_result.storeVersion}',
                      style: TextStyle(color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _openStore,
                      child: const Text('Update now'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
