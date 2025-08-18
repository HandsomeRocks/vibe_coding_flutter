import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

class WebEmbedScreen extends StatefulWidget {
  final String title;
  final String url;
  final Map<String, String>? parameters;

  const WebEmbedScreen({
    super.key,
    required this.title,
    required this.url,
    this.parameters,
  });

  @override
  State<WebEmbedScreen> createState() => _WebEmbedScreenState();
}

class _WebEmbedScreenState extends State<WebEmbedScreen> {
  bool _isLoading = true;
  String _finalUrl = '';

  @override
  void initState() {
    super.initState();
    _buildUrl();
    // Simulate loading
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _buildUrl() {
    // Build the final URL with parameters
    String finalUrl = widget.url;
    if (widget.parameters != null && widget.parameters!.isNotEmpty) {
      final queryParams = widget.parameters!.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
      finalUrl += finalUrl.contains('?') ? '&$queryParams' : '?$queryParams';
    }
    _finalUrl = finalUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Open in browser button
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () {
              if (kIsWeb) {
                html.window.open(_finalUrl, '_blank');
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening ${widget.url} in browser...'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Open in Browser',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading preview...'),
                ],
              ),
            )
          : _buildPreviewContent(),
    );
  }

  Widget _buildPreviewContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Preview Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.web,
              size: 80,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Web Content Preview',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Preview the embedded web content by opening it in a new tab.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Text(
                  'URL to Preview:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  _finalUrl,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blue[600],
                        fontFamily: 'monospace',
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  if (kIsWeb) {
                    html.window.open(_finalUrl, '_blank');
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening $_finalUrl in new tab...'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open in New Tab'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (kIsWeb) {
                    html.window.open(_finalUrl, '_self');
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening $_finalUrl in current tab...'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.launch),
                label: const Text('Open in Current Tab'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '💡 Tip: Use "Open in New Tab" to keep the app open while viewing the content',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
