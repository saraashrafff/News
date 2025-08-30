import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news/shared/app_theme.dart';

class HomeDrawer extends StatelessWidget {
  VoidCallback onGoToHomeClicked;
  HomeDrawer({required this.onGoToHomeClicked});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Size screenSize = MediaQuery.sizeOf(context);
    return Container(
      color: AppTheme.black,
      width: screenSize.width * 0.7,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: screenSize.height * 0.2,
            width: double.infinity,
            color: AppTheme.white,
            child: Text(
              'News App',
              style: textTheme.titleLarge!.copyWith(
                color: AppTheme.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () {
                onGoToHomeClicked();
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  SvgPicture.asset('assets/icons/home.svg'),
                  SizedBox(width: 8),
                  Text('Go To Home', style: textTheme.labelLarge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
