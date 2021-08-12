import 'package:flutter/material.dart';
import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:an_muk_so/theme/colors.dart';

class ReviewPolicyMore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithGoToBack(
        "알아두세요",
        Icon(Icons.arrow_back),
        0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("'약사의 한 마디' 및 '사용자 리뷰'에 대한 안내\n",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: gray900, fontSize: 14)),
            Text(
                "1. 해당 정보는 참조 용도로만 활용 가능하며, 해당 약에 대한 정확한 파악은 의료 기관 혹은 약국 내방을 통해 진행하시기 바랍니다. \n" +
                    "2. '약사의 한마디'는 약학적 정보에 기초한 답변으로 상담 약사의 최종적인 약학적 소견을 나타낸 것이 아니며, 답변을 제공한 개인 및 사업자의 법률적 책임이 없음을 알려드립니다.\n" +
                    "3. '사용자 리뷰'는 개인이 약을 사용하고 느낀 효과와 부작용에 대한 주관적인 의견으로  답변을 제공한 개인 및 사업자의 법률적 책임이 없음을 알려드립니다.\n" +
                    "4. '약사의 한마디'는 시의적, 물리적 환경에 따라 변경된 이견을 가질 수 있으며, 약학적 소견이 상이한 여러 의견을 모두 수렴하지는 않습니다.\n",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: gray500, fontSize: 13))
          ],
        ),
      ),
    );
  }
}
