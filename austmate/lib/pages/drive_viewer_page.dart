import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DriveViewerPage extends StatefulWidget {
  final String driveUrl;
  final String title;

  const DriveViewerPage({
    super.key,
    required this.driveUrl,
    required this.title,
  });

  @override
  State<DriveViewerPage> createState() => _DriveViewerPageState();
}

class _DriveViewerPageState extends State<DriveViewerPage> {
  late WebViewController controller;
  bool loading = true;

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
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => loading = true),
          onPageFinished: (_) => setState(() => loading = false),
        ),
      )
      ..loadRequest(Uri.parse(getEmbedUrl(widget.driveUrl)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFFE1625F),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
