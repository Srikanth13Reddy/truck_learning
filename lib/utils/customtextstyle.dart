
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_learning/utils/colors.dart';
import 'package:truck_learning/widgets/bubble.dart';

const AssetImage PlaceholderImage = AssetImage('images/dummy_profile.png');

final TextStyle appBarTestStyleBlack = GoogleFonts.rubik(
  color: Color.fromRGBO(48, 48, 48, 1),
  fontWeight: FontMedium,
  fontSize: 22,
);
final TextStyle appBarTestStyleBlackGrey = GoogleFonts.rubik(
  color: Color.fromRGBO(184, 184, 184, 1),
  fontWeight: FontMedium,
  fontSize: 22,
);

final buttonTextStyle = GoogleFonts.rubik(
  fontSize: 15,
  color: WhiteColor,
  fontWeight: FontMedium,
);

final borderButtonTextStyle = GoogleFonts.rubik(
  fontSize: 16,
  color: PrimaryButtonColor,
  fontWeight: FontMedium,
);

final TextStyle errorTestStyle = GoogleFonts.rubik(
  fontSize: 14,
  color: TitleColor,
  fontWeight: FontRegular,
);

final infoTitleTextStyle = GoogleFonts.rubik(
  fontSize: 18,
  color: TitleColor,
  fontWeight: FontMedium,
);

final infoDescTextStyle = GoogleFonts.rubik(
  fontSize: 14,
  color: SubTitleColor,
  fontWeight: FontRegular,
);

final listViewTitleTestStyle = GoogleFonts.rubik(
  fontSize: 16,
  color: TitleColor,
  fontWeight: FontMedium,
);

final listViewSubTitleTestStyle = GoogleFonts.rubik(
  fontSize: 14,
  color: GreyColor,
  fontWeight: FontRegular,
);

final headerTitleTextStyle = GoogleFonts.rubik(
  fontSize: 24,
  color: TitleColor,
  fontWeight: FontMedium,
);

final headerTitleTextStyleGrey = GoogleFonts.rubik(
  fontSize: 24,
  color: BorderColor,
  fontWeight: FontMedium,
);

final titleTextStyleBlack = GoogleFonts.rubik(
  fontSize: 20,
  color: TitleColor,
  fontWeight: FontMedium,
);

final titleTextStyleGrey = GoogleFonts.rubik(
  fontSize: 20,
  color: BorderColor,
  fontWeight: FontMedium,
);

final titleTextStyleGreen = GoogleFonts.rubik(
  fontSize: 14,
  color: PrimaryButtonColor,
  fontWeight: FontMedium,
);

final menuItemTextStyle = GoogleFonts.rubik(
  fontSize: 16,
  color: TitleColor,
  fontWeight: FontMedium,
);

final cardTextStyleWhite = GoogleFonts.rubik(
  fontSize: 18,
  color: WhiteColor,
  fontWeight: FontMedium,
);

final subHeaderTextStyle = GoogleFonts.rubik(
  fontSize: 17,
  color: SubTitleColor,
  fontWeight: FontRegular,
);

final subHeaderTextStyleBlack = GoogleFonts.rubik(
  fontSize: 20,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

final mediumTitleTextStyle = GoogleFonts.rubik(
  fontSize: 14,
  color: SubTitleColor,
  fontWeight: FontRegular,
);

final mediumTitleTextStyleGreen = GoogleFonts.rubik(
  fontSize: 16,
  color: PrimaryButtonColor,
  fontWeight: FontMedium,
);

final mediumTitleTextStyleBlack = GoogleFonts.rubik(
  fontSize: 14,
  color: TitleColor,
  fontWeight: FontRegular,
);



final smallTextStyle = GoogleFonts.rubik(
  fontSize: 12,
  color: BorderColor,
  fontWeight: FontRegular,
);

final smallTextStyleBlack = GoogleFonts.rubik(
  fontSize: 12,
  color: TitleColor,
  fontWeight: FontRegular,
);

final smallTextStyleGrey = GoogleFonts.rubik(
  fontSize: 10,
  color: BorderColor,
  fontWeight: FontRegular,
);

final textBoxTextStyleBlack = GoogleFonts.rubik(
  fontSize: 14,
  color: TitleColor,
  fontWeight: FontMedium,
);

final textBoxTextStyleGrey = GoogleFonts.rubik(
  fontSize: 14,
  color: Color.fromRGBO(136, 136, 136, 1),
  fontWeight: FontMedium,
);

final textBoxHintTextStyle = GoogleFonts.rubik(
  fontSize: 14,
  color: BorderColor,
  fontWeight: FontRegular,
);

final textBoxErrorTextStyle = GoogleFonts.rubik(
  color: Colors.red,
  fontSize: 12,
);

final textBoxEnabledUnderlineDecoration = UnderlineInputBorder(
  borderSide: BorderSide(color: BorderColor),
);

final textBoxFocusedUnderlineDecoration = UnderlineInputBorder(
  borderSide: BorderSide(color: BorderColor),
);

final textBoxEnabledOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: BorderColor),
);

final textBoxFocusedOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: BorderColor),
);

//Chat message Style
final msgStyleSomebody = BubbleStyle(
  nip: BubbleNip.leftTop,
  color: Colors.white,
  elevation: 1,
  margin: BubbleEdges.only(top: 8.0, right: 50.0),
  alignment: Alignment.topLeft,
);
final msgStyleMe = BubbleStyle(
  nip: BubbleNip.rightTop,
  color: Color.fromARGB(255, 225, 255, 199),
  elevation: 1,
  margin: BubbleEdges.only(top: 8.0, left: 50.0),
  alignment: Alignment.topRight,
);

final msgTextStyle = GoogleFonts.rubik(
  fontSize: 16,
  color: TitleColor,
  fontWeight: FontRegular,
);

final msgTimeTextStyle = GoogleFonts.rubik(
  fontSize: 10,
  color: BorderColor,
  fontWeight: FontRegular,
);
