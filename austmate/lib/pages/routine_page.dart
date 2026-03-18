import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  bool isWebLoading = true;
  late WebViewController _webController;
  final String driveLink =
      'https://drive.google.com/file/d/14FqJqiB5ewlhnhsPu7s2DVzISUmczdxV/view';

  @override
  void initState() {
    super.initState();
    _initWebController();
  }

  void _initWebController() {
    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => isWebLoading = true),
          onPageFinished: (_) => setState(() => isWebLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(getEmbedUrl(driveLink)));
  }

  String getEmbedUrl(String url) {
    if (url.contains("/folders/")) {
      final id = url.split("/folders/")[1].split("?")[0];
      return "https://drive.google.com/embeddedfolderview?id=$id#list";
    }

    if (url.contains("/file/d/")) {
      final id = url.split("/file/d/")[1].split("/")[0];
      return "https://drive.google.com/file/d/$id/preview";
    }

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Class Routine'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _webController.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _webController),
          if (isWebLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
