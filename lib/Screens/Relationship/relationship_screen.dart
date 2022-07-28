import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skoolfame/Routes/routes.dart';
import 'package:skoolfame/Utils/app_colors.dart';
import 'package:skoolfame/Utils/app_strings.dart';
import 'package:skoolfame/Widgets/custom_relationship_tile.dart';
import 'package:skoolfame/Widgets/custom_widget.dart';
import 'package:skoolfame/Widgets/wrapper.dart';

class RelationshipScreen extends StatefulWidget {
  const RelationshipScreen({Key? key}) : super(key: key);

  @override
  State<RelationshipScreen> createState() => _RelationshipScreenState();
}

class _RelationshipScreenState extends State<RelationshipScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: AppStrings.relationship,
      centerTitle: true,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            CustomRelationshipTile(
                title: "My Relationships", onTap: () => Navigator.pushNamed(context, Routes.MY_RELATIONSHIP_ROUTE)),
            SizedBox(
              height: 2.h,
            ),
            CustomRelationshipTile(
                title: "Relationship Requests",
                onTap: () => Navigator.pushNamed(context, Routes.RELATIONSHIP_REQUEST_ROUTE)),
          ],
        ),
      ),
    );
  }
}
