import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../../widgets/spacer_horizontal.dart';

class MsOurTakeItem extends StatelessWidget {
  const MsOurTakeItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          "Heading",
          colors: const [
            Color.fromARGB(255, 207, 204, 8),
            Color.fromARGB(255, 237, 250, 0),
            Color.fromARGB(255, 154, 228, 89),
            Color.fromARGB(255, 186, 236, 133),
          ],
          style: styleSansBold(fontSize: 20),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CircleAvatar(
                radius: 3,
                backgroundColor: ThemeColors.white,
              ),
            ),
            SpacerHorizontal(width: 10),
            Flexible(
              child: Text(
                "Revenue has significantly grown by 18.2% over same quarter last year.",
                style: stylePTSansRegular(height: 1.5, fontSize: 17),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
