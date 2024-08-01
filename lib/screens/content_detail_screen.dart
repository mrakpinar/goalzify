import 'package:flutter/material.dart';
import 'package:goalzify/services/motivation_service.dart';

class ContentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> content;
  final MotivationService _motivationService = MotivationService();

  ContentDetailScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            (content['title'] ?? 'Content Detail').toString().toUpperCase()),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              content['imageUrl'],
              width: double.infinity,
              height: 250,
              fit: BoxFit.scaleDown,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      content['title'] ?? 'No Title',
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    child: Text(
                      content['content'] ?? 'No content available',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          String contentId = content['id'] ?? '';
                          if (contentId.isNotEmpty) {
                            await _motivationService
                                .increaseMotivation(contentId);
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: const Text(
                                      'İçerik tanımlanamadı. Lütfen daha sonra tekrar deneyin.')),
                            );
                          }
                        },
                        child: const Text('İçeriği Okudum'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getContentId() {
    // Öncelikle 'id' alanını kontrol et
    if (content['id'] != null) {
      return content['id'].toString();
    }
    // Eğer 'id' yoksa, 'title' kullan (veya başka bir benzersiz alan)
    else if (content['title'] != null) {
      return content['title'].toString();
    }
    // Hiçbir benzersiz tanımlayıcı bulunamazsa boş string döndür
    return '';
  }
}
