// import 'package:dolomood/core/style/text_style.dart';
// import 'package:dolomood/core/utils/config_reader.dart';
// import 'package:dolomood/core/utils/extension/duration_extension.dart';
// import 'package:dolomood/core/utils/extension/int_extension.dart';
// import 'package:dolomood/core/utils/log/logger.dart';
// import 'package:dolomood/feature/tarot/cubit/progress/tarot_progress_cubit.dart';
// import 'package:dolomood/feature/tarot/model/card/tarot_card_model.dart';
// import 'package:dolomood/feature/tarot/model/comment/tarot_comment_model.dart';
// import 'package:dolomood/feature/tarot/ui/widgets/controller/tarot_rive_controller.dart';
// import 'package:dolomood/feature/tarot/ui/widgets/slide_fade_inout_widget.dart';
// import 'package:dolomood/feature/tarot/ui/widgets/start/comment/tarot_comment_text_widget.dart';
// import 'package:dolomood/feature/tarot/ui/widgets/start/tarot_show_card_overlap_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../widgets/card_stack/stack_card.dart';

// enum TarotComment {
//   /// 첫 번째 카드
//   fistCardComment(idx: 1),

//   /// 두 번째 카드
//   secondCardComment(idx: 2),

//   /// 세 번째 카드
//   thridCardComment(idx: 3),

//   /// 첫 번째 조언
//   firstAdviceComment(idx: 3),

//   /// 두 번째 조언
//   secondAdviceComment(idx: 3),

//   /// 네번째 카드
//   fourthCardComment(idx: 4);

//   final int idx;
//   const TarotComment({required this.idx});
// }

// /// **TarotAfterComment**
// ///
// /// 이 클래스는 Tarot AfterComment를 표시하고 애니메이션 효과를 제어하는 위젯입니다.
// /// 사용자 상호작용 및 애니메이션 상태 변화를 통해 카드와 조언 표시를 다루며,
// /// 다양한 ValueNotifier 및 애니메이션 컨트롤러를 통해 시각적 요소를 처리합니다.
// ///
// /// 주요 기능:
// /// 1. **카드 오버레이** - 카드가 뒤집어지며 나타나는 효과를 보여줍니다.
// /// 2. **카드 상태 표시** - 특정 ValueNotifier를 통해 사용자가 선택한 카드와 관련된 정보를 보여줍니다.
// /// 3. **조언 애니메이션** - 조언 텍스트를 단계별로 표시하고 눈, 표정 애니메이션을 통해 시각적 효과를 추가합니다.
// /// 4. **다양한 ValueNotifier** - 상태 변화를 관리하여 조언과 카드의 상태를 조정합니다.
// /// 5. **Rive 애니메이션** - Rive 컨트롤러를 통해 특정 조건에 맞게 애니메이션 효과를 제어합니다.
// ///
// /// ## 코드 구성
// /// - `TarotAfterComment` 위젯 클래스: 카드 뒤집기, 조언 표시, 애니메이션 및 상호작용을 제어합니다.
// /// - `_TarotAfterCommentState`: 상태 관리를 통해 카드 및 조언 표시, Rive 애니메이션 등을 제어합니다.
// /// - 주요 메서드:
// ///   - `flipedOverlayCardWidget`: 카드가 뒤집어지고 보여지는 애니메이션을 담당합니다.
// ///   - `tarotDolFaceChange`: 특정 단계에 따라 돌의 얼굴 표현을 변경합니다.
// ///   - `getPrefixTextSpanList`: 카드 설명에 필요한 텍스트 스팬을 반환합니다.
// ///
// /// ## 사용 예시
// /// ```dart
// /// TarotAfterComment(
// ///   overlayCardBackImageWidget: Image.asset('card_back.png'),
// ///   commentModel: TarotCommentModel(...),
// ///   riveController: TarotRiveController(),
// /// );
// /// ```
// class TarotAfterComment extends StatefulWidget {
//   final TarotCommentModel commentModel;

//   final Widget overlayCardBackImageWidget;
//   final TarotRiveController riveController;
//   final Function? taortCommentChangeCallback;

//   const TarotAfterComment(
//       {super.key,
//       required this.overlayCardBackImageWidget,
//       required this.commentModel,
//       required this.riveController,
//       this.taortCommentChangeCallback});

//   @override
//   State<TarotAfterComment> createState() => _TarotAfterCommentState();
// }

// class _TarotAfterCommentState extends State<TarotAfterComment> {
//   /// 오버레이 상태를 관리하는 ValueNotifier입니다.
//   ///
//   /// [showOverlay]는 오버레이가 활성화되어 있는지를 나타내며,
//   /// `null`이면 초기 상태, `true`일 때 오버레이가 표시되며
//   /// `false`일 때 오버레이가 해제됩니다.
//   final ValueNotifier<bool?> showOverlay = ValueNotifier<bool?>(null);

//   // 250428 제거
//   // /// 돌로 머리 위에 카드가 있는지 표시하는 ValueNotifier입니다.
//   // ///
//   // /// [showHeadAboveCard]는 돌로의 머리 위에 카드가 표시되어야 하는지를 나타냅니다.
//   // /// `true`일 경우 카드를 표시하고, `false`일 경우 표시하지 않습니다.
//   // final ValueNotifier<bool> showHeadAboveCard = ValueNotifier<bool>(false);

//   /// 돌로 머리 위에 조언이 표시되는지 관리하는 ValueNotifier입니다.
//   ///
//   /// [showHeadAboveAdvice]는 돌로의 머리 위에 조언 텍스트가 나타나는지를 나타냅니다.
//   /// `true`일 때 조언을 표시하고, `false`일 때 표시하지 않습니다.
//   final ValueNotifier<bool> showHeadAboveAdvice = ValueNotifier<bool>(false);

//   /// 조언 인덱스를 관리하는 ValueNotifier입니다.
//   ///
//   /// [adviceIndex]는 현재 표시될 조언의 인덱스를 관리합니다.
//   /// `-1`로 초기화되며, 특정 인덱스에 따라 조언이 나타나게 됩니다.
//   final ValueNotifier<int> adviceIndex = ValueNotifier<int>(-1);

//   /// 하단 코멘트 위젯 표시 여부를 관리하는 ValueNotifier입니다.
//   ///
//   /// [showBottomCommentWidget]는 돌로의 하단 코멘트 영역 표시 여부를 나타냅니다.
//   /// `true`일 경우 코멘트 영역을 표시하고, `false`일 경우 표시하지 않습니다.
//   final ValueNotifier<bool> showBottomCommentWidget =
//       ValueNotifier<bool>(false);

//   /// 카드 이미지 리스트입니다.
//   ///
//   /// [cardImages]는 표시할 카드 이미지들을 담고 있는 리스트입니다.
//   /// 각 카드 이미지는 `Widget` 타입으로 리스트에 저장됩니다.
//   final List<Widget> cardImages = [];

//   /// 카드 정보 모델입니다.
//   ///
//   /// [cardInfo]는 현재 타로 카드에 대한 정보를 담고 있는 모델 객체입니다.
//   /// [TarotCardModel] 타입으로 카드의 세부 정보를 포함합니다.
//   late final TarotCardModel cardInfo;

//   // final TarotRiveController riveController = Tarowidget.RiveController.instance;

//   /// 카드가 뒤집어진 후 표시되는 로직을 처리합니다
//   ///
//   /// [flipedOverlayCardWidget] 함수는 3초 대기 후 오버레이 상태를 `false`로 변경하고,
//   /// 돌로의 눈을 위쪽으로 바라보게 하는 애니메이션을 실행합니다.
//   void flipedOverlayCardWidget({bool ignoreDelay = false}) async {
//     if (!ignoreDelay) {
//       await Future.delayed(3.seconds); // 3초간의 대기 시간 설정
//     } else {
//       await Future.delayed(500.milliseconds); // 3초간의 대기 시간 설정
//     }

//     if (!(showOverlay.value ?? false)) return;

//     showOverlay.value = false; // 오버레이 해제

//     await Future.delayed(500.milliseconds); // 300ms 대기 후 다음 동작 수행
//     /// 기본표정으로 변경
//     widget.riveController.fireDefaultAll();
//     showBottomCommentWidget.value = true; // 하단 코멘트 위젯을 표시
//     /// 테이블 위 카드가 보여지도록 설정
//     widget.taortCommentChangeCallback?.call();

//     /// flip된 후 바로 표정이 변화한다.
//     final int commentIndex =
//         widget.commentModel.commentIndex; // 현재 코멘트 인덱스 가져오기
//     tarotDolFaceChange(commentIndex: commentIndex);
//   }

//   tarotDolFaceChange({required int commentIndex}) {
//     widget.riveController.fireDefaultAll();

//     if (commentIndex == TarotComment.fistCardComment.idx) {
//       int? moodID = context
//           .read<TarotProgressCubit>()
//           .state
//           .progressInfo
//           ?.selectedDolForTarot
//           ?.moodId;
//       if ([1, 2, 3].contains(moodID)) {
//         widget.riveController.fireSadEyes();
//       } else if ([5, 6, 7].contains(moodID)) {
//         widget.riveController.fireGoodEyes();
//       } else {
//         widget.riveController.fireDefaultAll();
//       }
//       return;
//     }
//     if (commentIndex == TarotComment.secondCardComment.idx) {
//       widget.riveController.fireCloseEyes();
//       widget.riveController.fireArmFront();
//       return;
//     }
//     if (commentIndex == TarotComment.thridCardComment.idx) {
//       widget.riveController.fireDefaultAll();
//       return;
//     }
//     if (commentIndex == TarotComment.fourthCardComment.idx) {
//       showHeadAboveAdvice.value = false;

//       widget.riveController.fireGoodEyes();
//       return;
//     }
//   }

// // /// 카드를 볼 때마다 짓는 표정
// // ///
// // /// [progressIndex]는 하나의 카드 보여주는 flow에 대한 Index입니다.
// // /// [isLast]는 마지막 카드인지 여부를 나타냅니다.
// // tarotDolFaceChange({required int progressIndex, bool? isLast}) {
// //   /// 오버레이가 보일 때는 아무것도 하지 않음
// //   if (showOverlay.value == true) return;

// //   /// 종료시
// //   if (commentIndex == 4 && (isLast ?? false)) {
// //     context
// //         .read<TarotProgressCubit>()
// //         .updateTarotCardShowStatus(stage: TarotCardStage.end);
// //     widget.riveController.fireDefaultAll();
// //     return;
// //   }

// //   /// 첫번째카드
// //   if (commentIndex == TarotComment.fistCardComment.idx) {
// //     if (progressIndex == 0) {
// //       widget.riveController.fireDefaultAll();
// //
// //       // showHeadAboveCard.value = false;

// //       if (isLast ?? false) {
// //         widget.riveController.fireDefaultAll();

// //       }
// //       return;
// //     }

// //     if (commentIndex == TarotComment.secondCardComment.idx) {
// //       if (progressIndex == 0) {
// //
// //         // showHeadAboveCard.value = false;

// //         widget.riveController.fireCloseEyes();
// //         widget.riveController.fireArmFront();
// //       }

// //       if (isLast ?? false) {
// //         widget.riveController.fireDefaultAll();

// //         /// 다음 상태로 넘긴다
// //         context
// //             .read<TarotProgressCubit>()
// //             .updateTarotCardShowStatus(stage: TarotCardStage.third);
// //       }
// //       return;
// //     }

// //     if (commentIndex == TarotComment.thridCardComment.idx) {
// //       if (progressIndex == 0) {
// //
// //         // showHeadAboveCard.value = false;

// //         widget.riveController.fireDefaultAll();
// //       }
// //       if ((isLast ?? false)) {
// //
// //       }

// //       return;
// //     }

// //     if (commentIndex == TarotComment.fourthCardComment.idx) {

// //       if (progressIndex == 0) {
// //
// //         // showHeadAboveCard.value = false;
// //         widget.riveController.fireDefaultAll();

// //         widget.riveController.fireGoodEyes();
// //       }

// //
// //     }
// //   }

//   @override
//   void initState() {
//     //widget.riveController = widget.controller;
//     super.initState();

//     /// ㅇㅣㅈㅓㄴㅇㅔ ㅣㅁㅣ ㅋㅏㄷㅡㄹㅡㄹ ㄷㅜㅣㅈㅣㅂㅇㅡㄴ ㅓㄴㅈㅓㄱㅇㅣ ㅣㅆㄸㅏㅁㅕㄴ.
//     if (widget.commentModel.befoCardImagePath != null) {
//       cardImages.add(
//           cardDummyCardWidget(path: widget.commentModel.befoCardImagePath!));
//     }

//     // build 후 300ms 이후에 Overlay가 나타나도록 설정
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Future.delayed(const Duration(milliseconds: 150), () {
//         showOverlay.value = true; //  overlay 보여주기
//         /// 돌로가 위쪽을 보도록 설정
//         widget.riveController.fireLookupEyes();
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, contraint) {
//       return Stack(
//         fit: StackFit.expand,
//         children: [
//           /// 카드 이미지
//           // Positioned(
//           //   top: 99.5.h,
//           //   left: 0,
//           //   right: 0,
//           //   child: ValueListenableBuilder<bool>(
//           //     valueListenable: showHeadAboveCard,
//           //     builder: (context, value, child) {
//           //       if (widget.commentModel.cardImagePath == null) {
//           //         return const SizedBox.shrink();
//           //       }
//           //       return AnimatedSwitcher(
//           //         duration: 300.milliseconds,
//           //         child: value
//           //             ? SlideFadeInOutWidget(
//           //                 key: ValueKey(widget.commentModel.cardImagePath),
//           //                 child: SizedBox(
//           //                   width: 86.83.w,
//           //                   child: AspectRatio(
//           //                       aspectRatio: 7 / 12,
//           //                       child: ClipRRect(
//           //                         borderRadius: BorderRadius.circular(4.8),
//           //                         child: SvgPicture.asset(
//           //                           widget.commentModel.cardImagePath!,
//           //                           width: 86.83.w,
//           //                           fit: BoxFit.contain,
//           //                         ),
//           //                       )),
//           //                 ),
//           //               )
//           //             : const SizedBox.shrink(),
//           //       );
//           //     },
//           //   ),
//           // ),

//           /// 하단 comment 텍스트 상자
//           Positioned(
//             left: 0,
//             right: 0,
//             // top: 530.h,
//             bottom: ConfigReader.getPaddingBottom + 20,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: ValueListenableBuilder<bool>(
//                 valueListenable: showBottomCommentWidget,
//                 builder: (context, value, child) {
//                   return AnimatedSwitcher(
//                     duration: 300.milliseconds,
//                     child: value
//                         ? ConstrainedBox(
//                             key: ValueKey(widget.commentModel.hashCode),
//                             constraints: BoxConstraints(
//                                 maxWidth: contraint.maxWidth,
//                                 maxHeight: 500.h,
//                                 minHeight: 160.h),
//                             child: TarotCommentTextWidget(
//                               key: ValueKey(widget.commentModel.hashCode),
//                               maxLines: 5,
//                               minLines: 4,
//                               text: widget.commentModel.cardComment,
//                               boldStyle: fmTextBold.copyWith(
//                                   fontSize: 16,
//                                   color: Color(0xFF222222),
//                                   height: 1.35,
//                                   fontFeatures: const [
//                                     FontFeature.tabularFigures()
//                                   ]),

//                               // prefixText: getPrefixTextSpanList(
//                               //     index: widget.commentModel.commentIndex,
//                               //     cardIndex: widget.commentModel.cardNumber),
//                               onPageTap: ({required index, bool? isLast}) {
//                                 // 변경된 구조화된 콜백
//                                 if (!showBottomCommentWidget.value) return;

//                                 /// 조언이 있고 마지막이라면 조언을 띄워야 한다.
//                                 if (widget.commentModel.advices != null &&
//                                     (isLast ?? false)) {
//                                   adviceMethod();
//                                   return;
//                                 }
//                                 if (isLast ?? false) {
//                                   onTapNextCardProcess();
//                                 }
//                               },
//                               textStyle: fmTextMedium.copyWith(
//                                   fontSize: 16,
//                                   color: Color(0xFF222222),
//                                   fontFeatures: const [
//                                     FontFeature.tabularFigures()
//                                   ],
//                                   height: 1.35),
//                             ),
//                           )
//                         : SizedBox.shrink(
//                             key: ValueKey('$value'),
//                           ),
//                   );
//                 },
//               ),
//             ),
//           ),

//           /// 조언 위젯
//           Positioned(
//               top: 50.h,
//               left: 0,
//               right: 0,
//               height: 300,
//               child: ValueListenableBuilder<bool>(
//                 valueListenable: showHeadAboveAdvice,
//                 builder: (context, value, child) {
//                   if (!value) return const SizedBox.shrink();

//                   return SlideFadeInOutWidget(
//                     animatedDuration: 1000.milliseconds,
//                     slideOffset: const Offset(0, 0.1),
//                     child: StackOverlapCard(
//                       padding: const EdgeInsets.only(left: 20),
//                       items: advicesToTextSpans(widget.commentModel.advices),
//                       info: StackOverlapCardInfo(
//                         initialTop: 50.h,
//                         opacity: 50,
//                         topPositionRatio: 0.3,
//                         initialWidth: 287.w,
//                         initialHeight: 78.h,
//                       ),
//                       visibleIndexNotifier: adviceIndex,
//                     ),
//                   );
//                 },
//               )),

//           /// 맨 처음 카드뒤집기
//           Positioned.fill(
//             child: ValueListenableBuilder<bool?>(
//               valueListenable: showOverlay,
//               builder: (context, value, child) {
//                 final bool isVisible = value ?? false;
//                 final String keyString =
//                     "$isVisible ${widget.commentModel.cardImagePath ?? 'no_image'}";
//                 "keyString : $keyString".log;
//                 return AnimatedSwitcher(
//                   duration: 300.milliseconds,
//                   switchInCurve: Curves.easeIn,
//                   switchOutCurve: Curves.easeOut,
//                   child: isVisible && widget.commentModel.cardImagePath != null
//                       ? TarotShowCardOverlapWidget(
//                           key: ValueKey(value),
//                           cardImage: AspectRatio(
//                             aspectRatio: 7 / 12,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(15),
//                               child: SvgPicture.asset(
//                                 widget.commentModel.cardImagePath!,
//                                 width: 196.w,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                           ),
//                           commentIndex: widget.commentModel.commentIndex,
//                           cardBackImage: widget.overlayCardBackImageWidget,
//                           flipedCallback: flipedOverlayCardWidget,
//                           afterFlipedCallback: (isFliped) =>
//                               flipedOverlayCardWidget(ignoreDelay: isFliped),
//                         )
//                       : SizedBox.shrink(key: ValueKey("1 + $value")),
//                 );
//               },
//             ),
//           )
//         ],
//       );
//     });
//   }

//   Widget cardDummyCardWidget({String? path}) {
//     try {
//       return AspectRatio(
//         aspectRatio: 7 / 12,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(2.4),
//           child: SvgPicture.asset(
//             path!,
//             fit: BoxFit.contain,
//           ),
//         ),
//       );
//     } catch (error) {
//       "cardDummyCardWidget error : $error".log;
//       return const SizedBox.shrink();
//     }
//   }

//   /// 조언 보여줄 때 동작하는 메소드
//   adviceMethod() async {
//     if (adviceIndex.value == -1) {
//       // 상단 램프 fadeout

//       // 돌로 위에보기
//       widget.riveController.fireLookupEyes();
//       // 조언 띄우기
//       showHeadAboveAdvice.value = true;
//       // Next Buttonㅇㅣ debounce = 1.second ㄹㅏㅅㅓ ok
//       await Future.delayed(
//         300.milliseconds,
//         () => adviceIndex.value = 0,
//       );
//       return;
//     }

//     int adviceLength = widget.commentModel.advices?.length ?? 0;

//     if (adviceIndex.value >= adviceLength - 1) {
//       widget.riveController.fireDefaultAll();

//       context
//           .read<TarotProgressCubit>()
//           .updateTarotCardShowStatus(stage: TarotCardStage.fourth);
//       return;
//     }

//     adviceIndex.value += 1;
//   }

//   /// comment버튼을 클릭하면 호출되는 메소드
//   onTapNextCardProcess() {
//     final commentIndex = widget.commentModel.commentIndex;
//     if (commentIndex == TarotComment.fistCardComment.idx) {
//       context
//           .read<TarotProgressCubit>()
//           .updateTarotCardShowStatus(stage: TarotCardStage.second);
//       return;
//     }
//     if (commentIndex == TarotComment.secondCardComment.idx) {
//       context
//           .read<TarotProgressCubit>()
//           .updateTarotCardShowStatus(stage: TarotCardStage.third);
//       return;
//     }
//     if (commentIndex == TarotComment.thridCardComment.idx) {
//       context
//           .read<TarotProgressCubit>()
//           .updateTarotCardShowStatus(stage: TarotCardStage.fourth);
//       return;
//     }
//     if (commentIndex == TarotComment.fourthCardComment.idx) {
//       context
//           .read<TarotProgressCubit>()
//           .updateTarotCardShowStatus(stage: TarotCardStage.end);
//       widget.riveController.fireDefaultAll();
//       return;
//     }
//   }

//   List<List<TextSpan>> advicesToTextSpans(List<String>? advices) {
//     if (advices == null) {
//       return [[]]; // 빈 리스트로 반환
//     }

//     return advices.asMap().entries.map((MapEntry<int, String> entry) {
//       final int adviceIndex = entry.key;
//       final String adviceText = entry.value;
//       return [
//         TextSpan(
//           text: "${(adviceIndex + 1).toOrdinal},\n",
//           style: fmMemo.copyWith(
//             fontSize: 14,
//             color: Colors.white.withValues(alpha: 0.8),
//           ),
//         ),
//         TextSpan(
//           text: adviceText,
//           style: fmBody1.copyWith(
//             fontSize: 14,
//             color: Colors.white,
//           ),
//         ),
//       ];
//     }).toList();
//   }

//   // List<TextSpan> getPrefixTextSpanList(
//   //     {required int index, required int cardIndex}) {
//   //   TarotCardModel? card =
//   //       context.read<TarotCardInfoCubit>().getTarotCardUsingIndex(cardIndex);
//   //   if (card == null) return [];
//   //   switch (index) {
//   //     case 1:
//   //       return [
//   //         TextSpan(
//   //             text: '어디 보자...\n',
//   //             style: fmBody1.copyWith(fontSize: 16, color: Colors.white)),
//   //         TextSpan(
//   //             text: '첫 카드는 ',
//   //             style: fmBody1.copyWith(fontSize: 16, color: Colors.white)),
//   //         TextSpan(
//   //             text: card.koName,
//   //             style: fmBody1.copyWith(
//   //                 color: Colors.white, fontWeight: FontWeight.w700)),
//   //         TextSpan(
//   //             text: '가 나왔구나',
//   //             style: fmBody1.copyWith(fontSize: 16, color: Colors.white)),
//   //       ];
//   //     case 2:
//   //       return [
//   //         TextSpan(
//   //             text: '음...\n',
//   //             style: fmBody1.copyWith(fontSize: 16, color: Colors.white)),
//   //         TextSpan(
//   //             text: card.koName,
//   //             style: fmBody1.copyWith(
//   //                 color: Colors.white, fontWeight: FontWeight.w700)),
//   //         TextSpan(
//   //             text: '가 나온 것을 보니',
//   //             style: fmBody1.copyWith(fontSize: 16, color: Colors.white)),
//   //       ];
//   //     case 3:
//   //       return [
//   //         TextSpan(
//   //             text: '조언 카드로는 ',
//   //             style: fmBody1.copyWith(fontSize: 16, color: Colors.white)),
//   //         TextSpan(
//   //             text: card.koName,
//   //             style: fmBody1.copyWith(
//   //                 color: Colors.white, fontWeight: FontWeight.w700)),
//   //         TextSpan(
//   //             text: '가 나왔네',
//   //             style: fmBody1.copyWith(fontSize: 16, color: Colors.white)),
//   //       ];
//   //     case 4:
//   //       return [
//   //         TextSpan(
//   //             text: '미래를 보는 카드에서 ',
//   //             style: fmBody1.copyWith(fontSize: 16, color: Colors.white)),
//   //         TextSpan(
//   //             text: card.koName,
//   //             style: fmBody1.copyWith(
//   //                 color: Colors.white, fontWeight: FontWeight.w700)),
//   //         TextSpan(
//   //             text: '라...',
//   //             style: fmBody1.copyWith(fontSize: 16, color: Colors.white)),
//   //       ];
//   //     default:
//   //       return [
//   //         TextSpan(
//   //             text: '기본 카드 설명입니다.',
//   //             style: fmBody1.copyWith(fontSize: 16, color: Colors.white)),
//   //       ];
//   //   }
//   // }
// }
