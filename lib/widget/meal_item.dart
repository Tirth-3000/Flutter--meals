import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'dart:typed_data';

// import 'package:meals/models/category.dart';
// import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';
// import 'package:meals/screen/meal_details.dart';

import 'package:meals/widget/meal_item_trait.dart';
// import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatefulWidget {
  const MealItem({super.key, required this.meal, required this.onSelectMeal});

  final Meal meal;
  final void Function(Meal meal) onSelectMeal;

  @override
  State<MealItem> createState() => _MealItemState();
}

class _MealItemState extends State<MealItem> {
  // Uint8List? _placeholderImage;
  bool _hasConnection = false;

  @override
  void initState() {
    super.initState();
    //  _loadPlaceholderImage();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    setState(() {
      _hasConnection = result != ConnectivityResult.none;
    });
  }

  // Future<void> _loadPlaceholderImage() async {
  //   final Uint8List? imageData = await loadImage();
  //   if (imageData != null) {
  //     setState(
  //       () {
  //         _placeholderImage = imageData;
  //       },
  //     );
  //   } else {
  //     _placeholderImage = await loadFallbackImage();
  //     setState(() {});
  //   }
  // }

  // Future<Uint8List?> loadImage() async {
  //   try {
  //     final ByteData data = await rootBundle.load('assets/Spinner-2.gif');
  //     return data.buffer.asUint8List();
  //   } catch (e) {
  //     print('error catching error : $e');
  //     return null;
  //   }
  // }

  // Future<Uint8List?> loadFallbackImage() async {
  //   try {
  //     final ByteData data = await rootBundle.load('assets/download.png');
  //     return data.buffer.asUint8List();
  //   } catch (e) {
  //     print('Error loading fallback image: $e');
  //     return null;
  //   }
  // }

  String get complexityText {
    return widget.meal.complexity.name[0].toUpperCase() +
        widget.meal.complexity.name.substring(1);
  }

  String get affordabilityText {
    return widget.meal.affordability.name[0].toUpperCase() +
        widget.meal.affordability.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.hardEdge,
        elevation: 2,
        child: InkWell(
          onTap: () {
            widget.onSelectMeal(widget.meal);
          },
          child: Stack(
            children: [
              Hero(
                tag: widget.meal.id,
                child: Stack(
                  children: [
                    // const Center(
                    //   child: CircularProgressIndicator(),
                    // ),
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: _hasConnection
                          ? CachedNetworkImage(
                              placeholder: (context, url) => const SizedBox(
                                height: 150,
                                width: 150,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              imageUrl: widget.meal.imageUrl,
                              errorWidget: (context, url, error) {
                                print('error occured  $error');
                                return const Icon(Icons.error);
                              },
                              fit: BoxFit.cover,
                              height: 200,
                              width: double.infinity,
                              fadeInDuration: const Duration(milliseconds: 300),
                            )
                          //  FadeInImage.memoryNetwork(
                          //     placeholder: _placeholderImage!,
                          //     placeholderFit: BoxFit.values[1],
                          //     image: widget.meal.imageUrl,
                          //     fit: BoxFit.cover,
                          //     height: 200,
                          //     width: double.infinity,
                          //     fadeInDuration: const Duration(milliseconds: 300),
                          //     imageErrorBuilder: (context, error, stackTrace) {
                          //       return const Center(
                          //         child: Icon(Icons.error),
                          //       );
                          //     },
                          //   )
                          : FadeInImage(
                              placeholder:
                                  const AssetImage('assets/Spinner-2.gif'),
                              placeholderFit: BoxFit.values[1],
                              image: AssetImage(
                                'assets/images/${widget.meal.localImage}',
                              ),
                              fit: BoxFit.cover,
                              height: 200,
                              width: double.infinity,
                              fadeInDuration: const Duration(milliseconds: 300),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.error),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54,
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 44),
                  child: Column(
                    children: [
                      Text(
                        widget.meal.title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MealItemTrait(
                            icon: Icons.schedule,
                            label: '${widget.meal.duration} min',
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          MealItemTrait(
                            icon: Icons.work,
                            label: complexityText,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          MealItemTrait(
                            icon: Icons.money,
                            label: affordabilityText,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
