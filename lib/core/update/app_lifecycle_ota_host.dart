import 'package:courier_app/core/update/ota_patch_service.dart';
import 'package:courier_app/core/update/remote_config_service.dart';
import 'package:flutter/material.dart';

/// Hosts silent Shorebird patch checks on start and resume.
/// Never blocks the child UI.
class AppLifecycleOtaHost extends StatefulWidget {
  final Widget child;
  final RemoteConfigService remoteConfigService;

  const AppLifecycleOtaHost({
    super.key,
    required this.child,
    required this.remoteConfigService,
  });

  @override
  State<AppLifecycleOtaHost> createState() => _AppLifecycleOtaHostState();
}

class _AppLifecycleOtaHostState extends State<AppLifecycleOtaHost>
    with WidgetsBindingObserver {
  late final OtaPatchService _otaPatchService;
  bool _isChecking = false;
  bool _noticeShownThisSession = false;

  @override
  void initState() {
    super.initState();
    _otaPatchService = OtaPatchService(
      remoteConfigService: widget.remoteConfigService,
    );
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runCheck();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _runCheck();
    }
  }

  Future<void> _runCheck() async {
    if (_isChecking) return;
    _isChecking = true;
    try {
      final outcome = await _otaPatchService.checkAndDownloadIfAvailable();
      if (!mounted) return;

      final shouldNotify = outcome == OtaPatchOutcome.downloaded ||
          outcome == OtaPatchOutcome.restartRequired;
      if (shouldNotify && !_noticeShownThisSession) {
        _noticeShownThisSession = true;
        _showUpdateNotice();
      }
    } finally {
      _isChecking = false;
    }
  }

  void _showUpdateNotice() {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text(
            'An update will apply next time you open the app',
          ),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: messenger.hideCurrentSnackBar,
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 8),
        ),
      );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
