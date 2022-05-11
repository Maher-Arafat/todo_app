import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/size_config.dart';

import '../theme.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.title,
    required this.hint,
    this.cntrlr,
    this.wdgt,
  }) : super(key: key);
  final String title;
  final String hint;
  final TextEditingController? cntrlr;
  final Widget? wdgt;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          Container(
            width: SizeConfig.screenWidth,
            height: 50,
            padding: const EdgeInsets.only(left: 15),
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blueGrey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: cntrlr,
                    autofocus: false,
                    readOnly: wdgt!=null?true:false,
                    style: subTitleStyle,
                    cursorColor: Get.isDarkMode?Colors.grey[150]:Colors.grey[800],
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.backgroundColor,
                          width: 0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.backgroundColor,
                          width: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                wdgt ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
