import 'package:flutter/material.dart';

import '../../../constants/style.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color topColor;
  bool isActive;
  final VoidCallback onTap;

  InfoCard({
    Key? key,
    required this.title,
    required this.value,
    required this.topColor,
    this.isActive = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 136,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: mainBlack,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 6),
                color: lightGrey.withOpacity(.1),
                blurRadius: 12,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: topColor,
                      height: 5,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$title\n",
                      style: TextStyle(
                        fontSize: 16,
                        color: isActive ? textGray : textWhite,
                      ),
                    ),
                    TextSpan(
                      text: "$value\n",
                      style: TextStyle(
                        fontSize: 40,
                        color: isActive ? textGray : textWhite,
                      ),
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
