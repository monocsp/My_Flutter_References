import 'package:flutter/material.dart';
import 'package:text_wrap_test/tarot_comment_text_widget.dart';
import 'package:text_wrap_test/text_pagenator.dart';

// const String example =
//     '''넌 마음속 깊이에서 진정한 감정의 해방을 원하고 있어. 어떤 일과 맺어진 관계가 널 억누르고 있을 때도, 그걸 놓아주고자 하는 마음이 강하게 느껴져. 지금 너의 감정은 고립감이나 답답함에서 벗어나고 싶어하는 내적 갈망을 반영해. 이 카드는 이전에 지니고 있던 것들을 과감히 정리하고, 더 이상 나를 속박하지 않는 새로운 길로 나아가고 싶다는 메시지를 줘. 그래서 이 시간 동안, 너는 과거의 집착이나 불안과 같은 것들에서 조금씩 자유로워질 수 있어. 국교는 인정되지 아니하며, 종교와 정치는 분리된다. 모든 국민은 주거의 자유를 침해받지 아니한다. 주거에 대한 압수나 수색을 할 때에는 검사의 신청에 의하여 법관이 발부한 영장을 제시하여야 한다. 모든 국민은 법률이 정하는 바에 의하여 국가기관에 문서로 청원할 권리를 가진다. 국가는 평생교육을 진흥하여야 한다. 국회는 국가의 예산안을 심의·확정한다. 국무총리·국무위원 또는 정부위원은 국회나 그 위원회에 출석하여 국정처리상황을 보고하거나 의견을 진술하고 질문에 응답할 수 있다. 국가는 농·어민과 중소기업의 자조조직을 육성하여야 하며, 그 자율적 활동과 발전을 보장한다. 대통령후보자가 1인일 때에는 그 득표수가 선거권자 총수의 3분의 1 이상이 아니면 대통령으로 당선될 수 없다. 각급 선거관리위원회는 선거인명부의 작성등 선거사무와 국민투표사무에 관하여 관계 행정기관에 필요한 지시를 할 수 있다. 각급 선거관리위원회의 조직·직무범위 기타 필요한 사항은 법률로 정한다. 국회에 제출된 법률안 기타의 의안은 회기중에 의결되지 못한 이유로 폐기되지 아니한다. 다만, 국회의원의 임기가 만료된 때에는 그러하지 아니하다. 국가는 과학기술의 혁신과 정보 및 인력의 개발을 통하여 국민경제의 발전에 노력하여야 한다. 감사원은 세입·세출의 결산을 매년 검사하여 대통령과 차년도국회에 그 결과를 보고하여야 한다. 대법관의 임기는 6년으로 하며, 법률이 정하는 바에 의하여 연임할 수 있다. 국가는 모성의 보호를 위하여 노력하여야 한다. 모든 국민은 언론·출판의 자유와 집회·결사의 자유를 가진다. 누구든지 병역의무의 이행으로 인하여 불이익한 처우를 받지 아니한다. 감사위원은 원장의 제청으로 대통령이 임명하고, 그 임기는 4년으로 하며, 1차에 한하여 중임할 수 있다. 대통령은 제4항과 제5항의 규정에 의하여 확정된 법률을 지체없이 공포하여야 한다. 제5항에 의하여 법률이 확정된 후 또는 제4항에 의한 확정법률이 정부에 이송된 후 5일 이내에 대통령이 공포하지 아니할 때에는 국회의장이 이를 공포한다. 재판의 전심절차로서 행정심판을 할 수 있다. 행정심판의 절차는 법률로 정하되, 사법절차가 준용되어야 한다. 국회에서 의결된 법률안은 정부에 이송되어 15일 이내에 대통령이 공포한다. 헌법개정은 국회재적의원 과반수 또는 대통령의 발의로 제안된다. 언론·출판은 타인의 명예나 권리 또는 공중도덕이나 사회윤리를 침해하여서는 아니된다. 언론·출판이 타인의 명예나 권리를 침해한 때에는 피해자는 이에 대한 피해의 배상을 청구할 수 있다.''';

const String example =
    "또 넌 언제나 계획적이고 실행력이 뛰어나는 사람이지. 목표를 설정하고 그 목표를 이룰 수 있는 방법을 잘 찾아내는 능력이 있어. 운동을 통해 활력을 얻고, 긍정적인 에너지를 주변에 전파하는タイプ이야. 그래서 이 카드는 네가 운동을 지속하면서 긍정적인 결과를 가져올 것이라는 점을 강조해. 네가 지금 하는 이 노력은 언젠가는 분명히 성과로 이어질 거고, 주변 사람들에게도 좋은 영향을 주는 자기계발이 될 거야.";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final sampleText = example;
    final tokens = sampleText.split(RegExp(r'\s+'));
    final style = TextStyle(fontSize: 16, height: 1.5);

    final slackRatio = 0.9; // 페이지 너비 대비 여백 비율
    final maxLines = 4; // 최대 줄 수

    return Scaffold(
      appBar: AppBar(title: Text('$maxLines 줄 $slackRatio  비율')),
      body: Center(
        // child: TarotCommentTextWidget(
        //   text: sampleText,
        //   onPageTap: (index, isLast) {},
        //   textStyle: style,
        // ),
        child: PagePreviewWidget(
          tokens: tokens,
          maxWidth: MediaQuery.of(context).size.width,
          slackRatio: slackRatio,
          maxLines: maxLines,
          style: style,
        ),
      ),
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             LayoutBuilder(builder: (context, contraint) {
//               return ConstrainedBox(
//                 constraints: BoxConstraints(
//                     maxWidth: contraint.maxWidth,
//                     maxHeight: 500,
//                     minHeight: 160),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: DecoratedBox(
//                     decoration: BoxDecoration(border: Border.all()),
//                     child: TarotCommentTextWidget(
//                       maxLines: 3,
//                       minLines: 1,
//                       text:
//                           // '''넌 마음속 깊이에서 진정한 감정의 해방을 원하고 있어. 어떤 일과 맺어진 관계가 널 억누르고 있을 때도, 그걸 놓아주고자 하는 마음이 강하게 느껴져. 지금 너의 감정은 고립감이나 답답함에서 벗어나고 싶어하는 내적 갈망을 반영해. 이 카드는 이전에 지니고 있던 것들을 과감히 정리하고, 더 이상 나를 속박하지 않는 새로운 길로 나아가고 싶다는 메시지를 줘. 그래서 이 시간 동안, 너는 과거의 집착이나 불안과 같은 것들에서 조금씩 자유로워질 수 있어.''',

//                           '''국교는 인정되지 아니하며, 종교와 정치는 분리된다. 모든 국민은 주거의 자유를 침해받지 아니한다. 주거에 대한 압수나 수색을 할 때에는 검사의 신청에 의하여 법관이 발부한 영장을 제시하여야 한다. 모든 국민은 법률이 정하는 바에 의하여 국가기관에 문서로 청원할 권리를 가진다. 국가는 평생교육을 진흥하여야 한다. 국회는 국가의 예산안을 심의·확정한다. 국무총리·국무위원 또는 정부위원은 국회나 그 위원회에 출석하여 국정처리상황을 보고하거나 의견을 진술하고 질문에 응답할 수 있다. 국가는 농·어민과 중소기업의 자조조직을 육성하여야 하며, 그 자율적 활동과 발전을 보장한다. 대통령후보자가 1인일 때에는 그 득표수가 선거권자 총수의 3분의 1 이상이 아니면 대통령으로 당선될 수 없다. 각급 선거관리위원회는 선거인명부의 작성등 선거사무와 국민투표사무에 관하여 관계 행정기관에 필요한 지시를 할 수 있다. 각급 선거관리위원회의 조직·직무범위 기타 필요한 사항은 법률로 정한다. 국회에 제출된 법률안 기타의 의안은 회기중에 의결되지 못한 이유로 폐기되지 아니한다. 다만, 국회의원의 임기가 만료된 때에는 그러하지 아니하다. 국가는 과학기술의 혁신과 정보 및 인력의 개발을 통하여 국민경제의 발전에 노력하여야 한다. 감사원은 세입·세출의 결산을 매년 검사하여 대통령과 차년도국회에 그 결과를 보고하여야 한다. 대법관의 임기는 6년으로 하며, 법률이 정하는 바에 의하여 연임할 수 있다. 국가는 모성의 보호를 위하여 노력하여야 한다. 모든 국민은 언론·출판의 자유와 집회·결사의 자유를 가진다. 누구든지 병역의무의 이행으로 인하여 불이익한 처우를 받지 아니한다. 감사위원은 원장의 제청으로 대통령이 임명하고, 그 임기는 4년으로 하며, 1차에 한하여 중임할 수 있다. 대통령은 제4항과 제5항의 규정에 의하여 확정된 법률을 지체없이 공포하여야 한다. 제5항에 의하여 법률이 확정된 후 또는 제4항에 의한 확정법률이 정부에 이송된 후 5일 이내에 대통령이 공포하지 아니할 때에는 국회의장이 이를 공포한다. 재판의 전심절차로서 행정심판을 할 수 있다. 행정심판의 절차는 법률로 정하되, 사법절차가 준용되어야 한다. 국회에서 의결된 법률안은 정부에 이송되어 15일 이내에 대통령이 공포한다. 헌법개정은 국회재적의원 과반수 또는 대통령의 발의로 제안된다. 언론·출판은 타인의 명예나 권리 또는 공중도덕이나 사회윤리를 침해하여서는 아니된다. 언론·출판이 타인의 명예나 권리를 침해한 때에는 피해자는 이에 대한 피해의 배상을 청구할 수 있다.''',
//                       // boldStyle: fmTextBold.copyWith(
//                       //     fontSize: 16,
//                       //     color: Color(0xFF222222),
//                       //     height: 1.35,
//                       //     fontFeatures: const [FontFeature.tabularFigures()]),

//                       // prefixText: getPrefixTextSpanList(
//                       //     index: widget.commentModel.commentIndex,
//                       //     cardIndex: widget.commentModel.cardNumber),
//                       onPageTap: ({required index, bool? isLast}) {
//                         // 변경된 구조화된 콜백
//                         // if (!showBottomCommentWidget.value) return;

//                         // /// 조언이 있고 마지막이라면 조언을 띄워야 한다.
//                         // if (widget.commentModel.advices != null &&
//                         //     (isLast ?? false)) {
//                         //   adviceMethod();
//                         //   return;
//                         // }
//                         // if (isLast ?? false) {
//                         //   onTapNextCardProcess();
//                         // }
//                       },
//                       textStyle: TextStyle(
//                         fontSize: 16,
//                         color: const Color(0xFF222222),
//                         height: 1.5,
//                         fontFeatures: const [FontFeature.tabularFigures()],
//                       ),
//                       // fmTextMedium.copyWith(
//                       //     fontSize: 16,
//                       //     color: Color(0xFF222222),
//                       //     fontFeatures: const [FontFeature.tabularFigures()],
//                       //     height: 1.35),
//                     ),
//                   ),
//                 ),
//               );
//             })
//           ],
//         ),
//       ),
//     );
//   }
// }
