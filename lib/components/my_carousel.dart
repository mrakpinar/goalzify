// components/my_carousel.dart

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:ui'; // Blur efekti için gerekli

class MyCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> contentList;
  final Function(Map<String, dynamic>) onItemTap;

  const MyCarousel(
      {super.key, required this.contentList, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 250,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 10),
        autoPlayAnimationDuration: const Duration(milliseconds: 2000),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      items: contentList.map((content) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () => onItemTap(content),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Image.network(
                          content['imageUrl'],
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 1),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        content['title'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
