import 'package:flutter/material.dart';

class LocationListTile  extends StatelessWidget{

  const LocationListTile({
    Key? key,
    required this.location,
    required this.press,
}) : super(key:key);

  final String location;
  final VoidCallback press;

  @override

  Widget build(BuildContext context) {
    return Container(

            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,

              children:[
                ListTile(
                  onTap: press,
                  horizontalTitleGap: 0,
                  title: Text(
                    location,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Divider(
                  height: 2,
                  thickness: 2,
                  color: Colors.grey,
                )
              ],
            ),
          );

  }


}