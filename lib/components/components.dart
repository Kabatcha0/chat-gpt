import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt/shared/const.dart';
import 'package:flutter/material.dart';

Widget chat({
  required int index,
  required String image,
  required String text,
}) {
  return Container(
      padding: const EdgeInsets.all(5),
      color: index == 0 ? scaffoldBackgroundColor : cardColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            image,
            fit: BoxFit.cover,
            height: 35,
            width: 35,
          ),
          Expanded(
              child: index == 0
                  ? Text(
                      text,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  : DefaultTextStyle(
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      child: AnimatedTextKit(
                        animatedTexts: [TyperAnimatedText(text.trim())],
                        isRepeatingAnimation: false,
                        repeatForever: false,
                        displayFullTextOnTap: true,
                        totalRepeatCount: 0,
                      ))),
          if (index == 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.thumb_down_alt_outlined,
                      color: Colors.white,
                      size: 28,
                    )),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.thumb_up_alt_outlined,
                      color: Colors.white,
                      size: 28,
                    )),
              ],
            ),
        ],
      ));
}

DropdownButton dropdownButton(
    {required List<DropdownMenuItem<dynamic>> items,
    // required String firstValue,
    required Function(dynamic) function}) {
  return DropdownButton(
      items: items,
      // value: firstValue,
      iconEnabledColor: Colors.white,
      dropdownColor: cardColor,
      onChanged: function);
}

Future showModel({
  required BuildContext context,
  required List<DropdownMenuItem<dynamic>> items,
  required Function(dynamic) function,
  // required String value
}) async {
  return await showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const Expanded(
                      child: Text(
                    "Choose Model",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )),
                  dropdownButton(
                    items: items, function: function,
                    //  firstValue: value
                  ),
                ],
              ),
            ),
          ),
      backgroundColor: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)));
}
