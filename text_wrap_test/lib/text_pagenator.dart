// import 'dart:developer';
// import 'dart:ui';

// import 'package:flutter/material.dart';

// class TextPaginator {
//   final String text;
//   final TextStyle textStyle;
//   final int maxLines;
//   final double maxWidth;
//   final double maxHeight;
//   final double slackRatio;

//   TextPaginator({
//     required this.text,
//     required this.textStyle,
//     required this.maxLines,
//     required this.maxWidth,
//     required this.maxHeight,
//     this.slackRatio = 0.90,
//   });

//   /// 페이지네이션 수행
//   /// - [text]를 문장 단위로 분리 후
//   /// - 빈 페이지면 문장 전체 폭·줄 수 검사, 아니면 토큰 단위 처리
//   /// - 토큰 별로 줄 나눔 후 [TextSpan]으로 변환
//   List<List<TextSpan>> paginate() {
//     final threshold = maxLines * maxWidth * slackRatio;
//     final sentences = text.split(RegExp(r'(?<=[\.\?!])\s*'));

//     final pages = <List<TextSpan>>[];
//     var currentPage = <TextSpan>[];
//     var usedWidth = 0.0;
//     var idx = 0;

//     while (idx < sentences.length) {
//       final sentence = sentences[idx];

//       if (usedWidth == 0.0) {
//         // 빈 페이지: 전체 문장 폭·줄 수 검사
//         final fullText = ' $sentence';
//         final fullW = _measureWidth(fullText);

//         log("fullText: $fullText, width: $fullW, threshold: $threshold");

//         if (fullW <= threshold) {
//           // 폭 OK → 줄 수 검사
//           final lines = _wrapToLines(_tokenize(fullText));
//           if (lines.length <= maxLines) {
//             // 정상 추가
//             for (var ln in lines) {
//               final lineText = ln.join(' ') + '\n';
//               currentPage.add(TextSpan(text: lineText, style: textStyle));
//               usedWidth += _measureWidth(lineText);
//             }
//             idx++;
//           } else {
//             // 예외 A: 줄 수 초과
//             final split = _splitByLimit(
//                 _tokenize(sentence), maxLines * maxWidth * slackRatio);
//             final fit = split['fit']!;
//             final rest = split['rest']!;
//             final fitLines = _wrapToLines(_tokenize(fit));
//             for (var ln in fitLines) {
//               final lineText = ln.join(' ') + '\n';
//               currentPage.add(TextSpan(text: lineText, style: textStyle));
//               usedWidth += _measureWidth(lineText);
//             }
//             sentences[idx] = rest.trim();
//           }
//         } else {
//           // 예외 B: 폭 초과
//           final split = _splitByLimit(_tokenize(sentence), threshold);
//           final fit = split['fit']!;
//           final rest = split['rest']!;
//           final fitLines = _wrapToLines(_tokenize(fit));
//           for (var ln in fitLines) {
//             final lineText = ln.join(' ') + '\n';
//             currentPage.add(TextSpan(text: lineText, style: textStyle));
//             usedWidth += _measureWidth(lineText);
//           }
//           sentences[idx] = rest.trim();
//         }
//       } else {
//         // 부분 페이지: 이전 줄 토큰 + 새 문장 토큰 합쳐서 처리
//         List<String> prevTokens = [];
//         if (currentPage.isNotEmpty) {
//           final lastSpan = currentPage.removeLast();
//           prevTokens = lastSpan.toPlainText().trim().split(RegExp(r'\s+'));
//           usedWidth -= _measureWidth(lastSpan.toPlainText());
//         }
//         final newTokens = _tokenize(sentence);
//         // 부분 페이지: 이전 줄+새 문장 합친 뒤
//         final mergedTokens = [...prevTokens, ...newTokens];
//         final lines = _wrapToLines(mergedTokens);

//         for (var ln in lines) {
//           final lineText = ln.join(' ') + '\n';
//           currentPage.add(TextSpan(text: lineText, style: textStyle));
//           usedWidth += _measureWidth(lineText);
//         }
//         idx++;
//       }

//       // 페이지 가득 찼으면 즉시 마감
//       if (currentPage.length >= maxLines) {
//         pages.add(List.of(currentPage));
//         currentPage.clear();
//         usedWidth = 0.0;
//       }
//     }

//     if (currentPage.isNotEmpty) pages.add(currentPage);
//     return pages;
//   }

//   /// 주어진 문자열 [s]의 렌더 폭을 TextPainter로 계산합니다.
//   double _measureWidth(String s) {
//     final painter = TextPainter(
//       text: TextSpan(text: s, style: textStyle),
//       textDirection: TextDirection.ltr,
//     )..layout(maxWidth: double.infinity);
//     return painter.width;
//   }

//   /// 띄어쓰기(\s+)도 토큰으로 남겨 단어+공백 모두 분리합니다.
//   List<String> _tokenize(String s) {
//     return s.split(RegExp(r'(\s+)')).where((t) => t.isNotEmpty).toList();
//   }

//   /// [tokens]를 maxWidth*slackRatio 기준으로 여러 줄로 그룹화합니다.
//   List<List<String>> _wrapToLines(List<String> tokens) {
//     final lines = <List<String>>[];
//     var line = <String>[];

//     for (var token in tokens) {
//       final candidate = line.isEmpty ? token : '${line.join(' ')} $token';
//       if (_measureWidth(candidate) <= maxWidth * slackRatio) {
//         line.add(token);
//       } else {
//         lines.add(line);
//         line = [token];
//       }
//     }
//     if (line.isNotEmpty) lines.add(line);
//     return lines;
//   }

//   /// [tokens]를 누적해 [limit] 이하가 되는 부분(fit)과 나머지(rest)로 분리합니다.
//   Map<String, String> _splitByLimit(List<String> tokens, double limit) {
//     var buffer = '';
//     var consumed = 0;
//     for (var token in tokens) {
//       final test = buffer.isEmpty ? token : '$buffer $token';
//       if (_measureWidth(test) > limit) break;
//       buffer = test;
//       consumed += token.length;
//     }
//     final fit = buffer.trim();
//     final rest = tokens.skipWhile((t) {
//       consumed -= t.length;
//       return consumed >= 0;
//     }).join(' ');
//     return {'fit': fit, 'rest': rest};
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';

/// 토큰 리스트를 페이지 단위로 분리합니다.
/// maxWidth, slackRatio, maxLines 기준으로 페이지 경계를 결정합니다.
class TextPaginator {
  /// 토큰 리스트를 받아 페이지별 토큰 서브리스트를 반환합니다.
  static List<List<String>> paginateTokens(
    List<String> tokens,
    double maxWidth,
    double slackRatio,
    int maxLines,
    TextStyle style,
  ) {
    final pages = <List<String>>[];
    int start = 0;
    while (start < tokens.length) {
      final end =
          _layoutPage(tokens, start, maxWidth, slackRatio, maxLines, style);
      pages.add(tokens.sublist(start, end));
      start = end;
    }
    return pages;
  }

  /// 한 페이지에 들어갈 토큰 범위를 계산하여 end 인덱스를 반환합니다.
  static int _layoutPage(
    List<String> tokens,
    int start,
    double maxWidth,
    double slackRatio,
    int maxLines,
    TextStyle style,
  ) {
    final currentLineTokens = <String>[];
    int lineCount = 0;

    for (int i = start; i < tokens.length; i++) {
      final token = tokens[i];
      final potentialLine = currentLineTokens.isEmpty
          ? token
          : '${currentLineTokens.join(' ')} $token';
      final width = _measureTextWidth(potentialLine, style);

      if (width <= maxWidth * slackRatio) {
        currentLineTokens.add(token);
      } else {
        lineCount++;
        if (lineCount >= maxLines) {
          // 페이지 분할 시 문장 경계를 찾아 분할 인덱스를 결정
          if (_isSentenceEnd(tokens[i - 1])) {
            return i;
          }
          for (int j = i - 1; j >= start; j--) {
            if (_isSentenceEnd(tokens[j])) {
              return j + 1;
            }
          }
          return i;
        }
        currentLineTokens
          ..clear()
          ..add(token);
      }
    }

    return tokens.length;
  }

  /// 토큰이 문장 끝인지 (마침표·물음표·느낌표) 확인합니다.
  static bool _isSentenceEnd(String token) =>
      token.endsWith('.') || token.endsWith('?') || token.endsWith('!');

  /// 주어진 텍스트의 렌더링 너비를 측정합니다.
  static double _measureTextWidth(String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return painter.width;
  }
}

/// 페이지 단위로 토큰을 시각화하고,
/// 하단의 처음/이전/다음 버튼으로 페이지 전환을 지원하며,
/// 컨테이너 크기는 AnimatedContainer로 300ms 애니메이션됩니다.
/// 버튼은 1초간 디바운스되어 누를 수 없습니다.
class PagePreviewWidget extends StatefulWidget {
  final List<String> tokens;
  final double maxWidth;
  final double slackRatio;
  final int maxLines;
  final TextStyle style;

  const PagePreviewWidget({
    Key? key,
    required this.tokens,
    required this.maxWidth,
    required this.slackRatio,
    required this.maxLines,
    required this.style,
  }) : super(key: key);

  @override
  State<PagePreviewWidget> createState() => _PagePreviewWidgetState();
}

class _PagePreviewWidgetState extends State<PagePreviewWidget> {
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  final ValueNotifier<bool> _buttonsEnabled = ValueNotifier<bool>(true);
  Timer? _debounceTimer;
  late final List<List<String>> _pages;

  @override
  void initState() {
    super.initState();
    // 위젯 생성 시 한 번만 페이지 분할
    _pages = TextPaginator.paginateTokens(
      widget.tokens,
      widget.maxWidth,
      widget.slackRatio,
      widget.maxLines,
      widget.style,
    );
  }

  void _startDebounce() {
    _buttonsEnabled.value = false;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      _buttonsEnabled.value = true;
    });
  }

  void _goToFirst() {
    if (!_buttonsEnabled.value) return;
    _currentPage.value = 0;
    _startDebounce();
  }

  void _goToPrevious() {
    if (!_buttonsEnabled.value) return;
    if (_currentPage.value > 0) {
      _currentPage.value -= 1;
      _startDebounce();
    }
  }

  void _goToNext() {
    if (!_buttonsEnabled.value) return;
    if (_currentPage.value < _pages.length - 1) {
      _currentPage.value += 1;
      _startDebounce();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _currentPage.dispose();
    _buttonsEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 페이지 인덱스 변화에만 반응하는 AnimatedContainer + 텍스트 영역
        ValueListenableBuilder<int>(
          valueListenable: _currentPage,
          builder: (_, page, __) {
            final lines = _layoutLines(_pages[page]);
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey(lines),
                width: widget.maxWidth,
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  key: ValueKey(lines),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final line in lines) Text(line, style: widget.style),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        // 버튼 활성화 상태에만 반응하는 버튼 그룹
        ValueListenableBuilder<bool>(
          valueListenable: _buttonsEnabled,
          builder: (_, enabled, __) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: enabled ? _goToFirst : null,
                  child: const Text('처음으로'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: enabled ? _goToPrevious : null,
                  child: const Text('이전'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: enabled ? _goToNext : null,
                  child: const Text('다음'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// 토큰 리스트를 받아 각 줄에 맞는 문자열 리스트로 분할합니다.
  List<String> _layoutLines(List<String> tokensPage) {
    final lines = <String>[];
    String currentLine = '';

    for (final token in tokensPage) {
      final nextLine = currentLine.isEmpty ? token : '$currentLine $token';
      final painter = TextPainter(
        text: TextSpan(text: nextLine, style: widget.style),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();

      if (painter.width <= widget.maxWidth * widget.slackRatio) {
        currentLine = nextLine;
      } else {
        if (currentLine.isNotEmpty) lines.add(currentLine);
        currentLine = token;
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }
    return lines;
  }
}
