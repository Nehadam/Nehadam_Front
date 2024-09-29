import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageGalleryScreen extends StatefulWidget {
  final String email;

  const ImageGalleryScreen({required this.email, super.key});

  @override
  _ImageGalleryScreenState createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  late Future<List<dynamic>> _images;
  String? _selectedImageId;
  String? _selectedImageUrl;

  @override
  void initState() {
    super.initState();
    _images = _fetchImages();
  }

  Future<List<dynamic>> _fetchImages() async {
    try {
      final response = await http.get(Uri.parse(
          'http://4hadam.ddns.net:8080/api/${widget.email}/images/list'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<void> _deleteImage(String imageId) async {
    try {
      final uri = Uri.parse(
              'http://4hadam.ddns.net:8080/api/${widget.email}/images/delete')
          .replace(queryParameters: {'imageId': imageId});

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _images = _fetchImages();
            _selectedImageId = null;
          });
        }
      } else {
        print(
            'Failed to delete image. Server responded with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _setRepresentativeImage(String imageId) async {
    try {
      final uri = Uri.parse(
              'http://4hadam.ddns.net:8080/api/${widget.email}/images/set-representative-image')
          .replace(queryParameters: {'imageId': imageId});

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Representative image set successfully');
        Navigator.pop(context, _selectedImageUrl);
      } else {
        print(
            'Failed to set representative image. Server responded with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이미지 갤러리'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _images,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('이미지를 불러오는데 실패했습니다.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('저장된 이미지가 없습니다.'));
          } else {
            return Stack(
              children: [
                GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final image = snapshot.data![index];
                    final imageId = image['id'].toString();
                    final imageUrl = image['fileurl'];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImageId = imageId;
                          _selectedImageUrl = imageUrl; // 이미지 URL 저장
                        });
                      },
                      child: Stack(
                        children: [
                          Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          if (_selectedImageId == imageId)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: FloatingActionButton.extended(
                    onPressed: _selectedImageId != null
                        ? () {
                            _setRepresentativeImage(_selectedImageId!);
                          }
                        : null,
                    backgroundColor:
                        _selectedImageId != null ? Colors.blue : Colors.white,
                    label: const Text('대표 프로필 사진으로 변경'),
                    icon: const Icon(Icons.check),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton.extended(
                    onPressed: _selectedImageId != null
                        ? () {
                            _deleteImage(_selectedImageId!);
                          }
                        : null,
                    backgroundColor:
                        _selectedImageId != null ? Colors.red : Colors.white,
                    label: const Text('이미지 삭제'),
                    icon: const Icon(Icons.delete),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
