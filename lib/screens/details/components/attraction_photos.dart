import 'package:ai_travel_planner/screens/details/components/photo_item_card.dart';
import 'package:ai_travel_planner/screens/details/components/tab_items.dart';
import 'package:ai_travel_planner/screens/photo_gallery_fullscreen.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

//used in Attraction detail screen
class AttractionPhotos extends StatefulWidget {
  List<String> photoUrls = [];

  AttractionPhotos({
    super.key, required this.photoUrls
  });

  @override
  State<AttractionPhotos> createState() =>
      _State();
}

class _State extends State<AttractionPhotos> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Text("Photos",
              style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: defaultPadding / 2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                widget.photoUrls.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: PhotoItemCard(
                    image: widget.photoUrls[index],
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => 
                          //const PlannerFormScreen(),
                          PhotoGalleryFullscreen(
                            imageUrls: widget.photoUrls,
                            initialIndex: index, // Optional: start at a specific image
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding),
            ],
          ),
        ),
      ],
    );
  }
}
