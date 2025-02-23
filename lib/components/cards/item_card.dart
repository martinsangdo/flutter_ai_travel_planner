import 'package:ai_travel_planner/screens/details/attractions_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

//used to show hotel or attractions in city detail page (tab region)
class ItemCard extends StatefulWidget {
  const ItemCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    this.price,
    this.url,
    this.rating,
    this.duration
  });

  final String? title, description, image, url, price;
  final int? duration;
  final double? rating;
  @override
  State<ItemCard> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<ItemCard> {
  @override
  void initState() {
      super.initState();
  } 

  @override
  void dispose() {
    super.dispose();
  }
  //depend on which tab, we process when user clicks on each item
  _processItemClicked() async{
    if (widget.url != null){
      //open new web browser
      if (!await launchUrlString(widget.url!, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $widget.url');
      }
    } else {
      debugPrint('aaa');
      if (context.mounted) {
        //navigate to attraction detail page
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AttractionDetailsScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.labelLarge!.copyWith(
          color: titleColor.withOpacity(0.64),
          fontWeight: FontWeight.normal,
        );
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      onTap: _processItemClicked,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 110,
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Image.network(
                    widget.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title!,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 14),
                    ),
                    Text(
                      widget.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        if (widget.rating != null)...[
                          SvgPicture.asset(
                            "assets/icons/rating.svg",
                            height: 20,
                            width: 20,
                            colorFilter: const ColorFilter.mode(
                              primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text("Rating: $widget.rating", style: const TextStyle(color: Colors.black),),
                        ],
                        if (widget.duration != null)...[
                          SvgPicture.asset(
                            "assets/icons/clock.svg",
                            height: 20,
                            width: 20,
                            colorFilter: const ColorFilter.mode(
                              primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text("$widget.duration min", style: const TextStyle(color: Colors.black),),
                        ],
                        const Spacer(),
                        Text(
                          widget.price??'',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: primaryColor),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
