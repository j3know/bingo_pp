import 'dart:math';

import 'package:bingo_app/ui/views/cards/cards_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

const double _graphicSize = 60;

class InfoAlertDialog extends StackedView<InfoAlertDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const InfoAlertDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    InfoAlertDialogModel viewModel,
    Widget? child,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.title!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        request.description!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: 3,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: _graphicSize,
                  height: _graphicSize,
                  decoration: const BoxDecoration(
                    color: Color(0xffF6E7B0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(_graphicSize / 2),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '💰',
                    style: TextStyle(fontSize: 30),
                  ),
                )
              ],
            ),
            DropdownButtonFormField<String>(
              value: viewModel.selectedPattern ?? 'L',
              onChanged: (String? newValue) {
                viewModel.setSelectedPattern(newValue);
              },
              decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              items: [
                'L',
                'X',
                'Cross',
                'Blackout',
                'Corners',
                'LineVertical',
                'LineHorizontal',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // 1. Set the selected pattern
                String? selectedPattern = viewModel.selectedPattern;
                if (selectedPattern != null) {
                  viewModel.setSelectedPattern(selectedPattern);

                  // 2. Generate bingo card based on the selected pattern
                  viewModel.generateBingoCard();

                  // 3. Check for L pattern
                  viewModel.checkForLPattern();

                  // 4. Navigate to another page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BingoCardPage(selectedPattern: selectedPattern),
                    ),
                  );
                }
              },
              child: Container(
                height: 50,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Generate card',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  InfoAlertDialogModel viewModelBuilder(BuildContext context) =>
      InfoAlertDialogModel();
}

class BingoCardPage extends StatefulWidget {
  final String selectedPattern;

  const BingoCardPage({Key? key, required this.selectedPattern})
      : super(key: key);

  @override
  _BingoCardPageState createState() => _BingoCardPageState();
}

class _BingoCardPageState extends State<BingoCardPage> {
  List<List<int>> bingoCard = [];
  List<List<int>> sets = List.generate(5, (_) => []);
  List<List<int>> get getNumbers => sets;

  List<int> bList = [];
  List<int> iList = [];
  List<int> nList = [];
  List<int> gList = [];
  List<int> oList = [];
  List<int> tappedItems = [];

  @override
  void initState() {
    super.initState();
    generateBingoCard();
  }

  void generateBingoCard() {
    for (var i = 0; i < 5; i++) {
      for (var j = 0; j < 5; j++) {
        int value = 0;
        switch (j) {
          case 0:
            value = generateRandomNumberBasedOnGivenRange(bList, 15, 1);
            break;
          case 1:
            value = generateRandomNumberBasedOnGivenRange(iList, 15, 16);
            break;
          case 2:
            if (i == 2 && j == 2) {
              value = 0;
            } else {
              value = generateRandomNumberBasedOnGivenRange(nList, 15, 31);
            }
            break;
          case 3:
            value = generateRandomNumberBasedOnGivenRange(gList, 15, 46);
            break;
          default:
            value = generateRandomNumberBasedOnGivenRange(oList, 15, 61);
        }
        sets[i].add(value);
      }
    }
    bingoCard = List.from(sets);
  }

  int generateRandomNumberBasedOnGivenRange(
      List<int> uniqueValues, int base, int range) {
    Random random = Random();
    int randomValue = (random.nextInt(base) + range);

    while (uniqueValues.contains(randomValue)) {
      randomValue = (random.nextInt(base) + range);
    }

    uniqueValues.add(randomValue);
    return randomValue;
  }

  bool checkForWin() {
    switch (widget.selectedPattern) {
      case 'L':
        return checkForWinL();
      case 'X':
        return checkForWinX();
      case 'Cross':
        return checkForWinCross();
      case 'Blackout':
        return checkForWinBlackout();
      case 'Corners':
        return checkForWinCorners();
      case 'LineVertical':
        return checkForWinVertical();
      case 'LineHorizontal':
        return checkForWinHorizontal();
      default:
        return false;
    }
  }

  bool checkForWinBlackout() {
    if (bingoCard[0][0] < 0 &&
        bingoCard[0][1] < 0 &&
        bingoCard[0][2] < 0 &&
        bingoCard[0][3] < 0 &&
        bingoCard[0][4] < 0 &&
        bingoCard[1][0] < 0 &&
        bingoCard[1][1] < 0 &&
        bingoCard[1][2] < 0 &&
        bingoCard[1][3] < 0 &&
        bingoCard[1][4] < 0 &&
        bingoCard[2][0] < 0 &&
        bingoCard[2][1] < 0 &&
        bingoCard[2][3] < 0 &&
        bingoCard[2][4] < 0 &&
        bingoCard[3][0] < 0 &&
        bingoCard[3][1] < 0 &&
        bingoCard[3][2] < 0 &&
        bingoCard[3][3] < 0 &&
        bingoCard[3][4] < 0 &&
        bingoCard[4][0] < 0 &&
        bingoCard[4][1] < 0 &&
        bingoCard[4][2] < 0 &&
        bingoCard[4][3] < 0 &&
        bingoCard[4][4] < 0) {
      showDialogBox();
      return true;
    }
    return false;
  }

  bool checkForWinHorizontal() {
    for (int i = 0; i < 5; i++) {
      if (bingoCard[i].every((cell) => cell < 0) ||
          bingoCard[i].every((cell) => cell < 1)) {
        showDialogBox();
        return true;
      }
    }
    return false;
  }

  bool checkForWinVertical() {
    for (int j = 0; j < 5; j++) {
      if (bingoCard.every((row) => row[j] < 5) ||
          bingoCard.every((row) => row[j] < 4)) {
        showDialogBox();
        return true;
      }
    }
    return false;
  }

  bool checkForWinX() {
    if (bingoCard[0][0] < 0 &&
        bingoCard[1][1] < 0 &&
        bingoCard[3][3] < 0 &&
        bingoCard[4][4] < 0 &&
        bingoCard[0][4] < 0 &&
        bingoCard[1][3] < 0 &&
        bingoCard[3][1] < 0 &&
        bingoCard[4][0] < 0) {
      showDialogBox();
      return true;
    }
    return false;
  }

  bool checkForWinCross() {
    if (bingoCard[0][2] < 0 &&
        bingoCard[1][2] < 0 &&
        bingoCard[2][0] < 0 &&
        bingoCard[2][1] < 0 &&
        bingoCard[2][3] < 0 &&
        bingoCard[2][4] < 0 &&
        bingoCard[3][2] < 0 &&
        bingoCard[4][2] < 0) {
      showDialogBox();
      return true;
    }
    return false;
  }

  bool checkForWinL() {
    if (bingoCard[0][0] < 0 &&
            bingoCard[0][1] < 0 &&
            bingoCard[0][2] < 0 &&
            bingoCard[0][3] < 0 &&
            bingoCard[0][4] < 0 &&
            bingoCard[1][4] < 0 &&
            bingoCard[2][4] < 0 &&
            bingoCard[3][4] < 0 &&
            bingoCard[4][4] < 0 ||
        bingoCard[4][0] < 0 &&
            bingoCard[4][1] < 0 &&
            bingoCard[4][2] < 0 &&
            bingoCard[4][3] < 0 &&
            bingoCard[4][4] < 0 &&
            bingoCard[0][4] < 0 &&
            bingoCard[1][4] < 0 &&
            bingoCard[2][4] < 0 &&
            bingoCard[3][4] < 0 ||
        bingoCard[0][0] < 0 &&
            bingoCard[0][1] < 0 &&
            bingoCard[0][2] < 0 &&
            bingoCard[0][3] < 0 &&
            bingoCard[0][4] < 0 &&
            bingoCard[1][0] < 0 &&
            bingoCard[2][0] < 0 &&
            bingoCard[3][0] < 0 &&
            bingoCard[4][0] < 0 ||
        bingoCard[4][0] < 0 &&
            bingoCard[4][1] < 0 &&
            bingoCard[4][2] < 0 &&
            bingoCard[4][3] < 0 &&
            bingoCard[4][4] < 0 &&
            bingoCard[0][0] < 0 &&
            bingoCard[1][0] < 0 &&
            bingoCard[2][0] < 0 &&
            bingoCard[3][0] < 0) {
      showDialogBox();
      return true;
    }
    return false;
  }

  bool checkForWinCorners() {
    if (bingoCard[0][0] < 0 && bingoCard[0][1] < 0 && bingoCard[1][0] < 0 ||
        bingoCard[0][3] < 0 && bingoCard[0][4] < 0 && bingoCard[1][4] < 0 ||
        bingoCard[3][4] < 0 && bingoCard[4][3] < 0 && bingoCard[4][4] < 0 ||
        bingoCard[3][0] < 0 && bingoCard[4][0] < 0 && bingoCard[4][1] < 0 ||
        bingoCard[1][1] < 0 && bingoCard[1][2] < 0 && bingoCard[2][1] < 0 ||
        bingoCard[1][2] < 0 && bingoCard[1][3] < 0 && bingoCard[2][3] < 0 ||
        bingoCard[3][1] < 0 && bingoCard[3][2] < 0 && bingoCard[2][1] < 0 ||
        bingoCard[3][2] < 0 && bingoCard[3][3] < 0 && bingoCard[2][3] < 0) {
      showDialogBox();
      return true;
    }
    return false;
  }

  void showDialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bingo!'),
          content: Text('You have won!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bingo Card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLabel('B'),
                _buildLabel('I'),
                _buildLabel('N'),
                _buildLabel('G'),
                _buildLabel('O'),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 0, 0, 0)),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 248, 1, 1).withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: 25,
                itemBuilder: (context, index) {
                  int i = index ~/ 5;
                  int j = index % 5;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (bingoCard[i][j] != 0) {
                          bingoCard[i][j] = -bingoCard[i][j];
                          checkForWin();
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8.0),
                        color: bingoCard[i][j] < 0 ? Colors.blue : Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: bingoCard[i][j] == 0
                          ? Transform.scale(
                              scale: 1.5,
                              child: const Text(
                                '⭐',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35.0,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : Text(
                              '${bingoCard[i][j].abs()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: bingoCard[i][j] < 0
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey[300],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
    );
  }
}

// import 'package:bingo_app/ui/views/cards/cards_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:stacked/stacked.dart';
// import 'package:stacked_services/stacked_services.dart';

// const double _graphicSize = 60;

// class InfoAlertDialog extends StatelessWidget {
//   final DialogRequest request;
//   final Function(DialogResponse) completer;

//   const InfoAlertDialog({
//     Key? key,
//     required this.request,
//     required this.completer,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<InfoAlertDialogModel>.reactive(
//       viewModelBuilder: () => InfoAlertDialogModel(),
//       onModelReady: (viewModel) => viewModel.init(request),
//       builder: (context, viewModel, child) {
//         return Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           backgroundColor: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             request.title!,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             request.description!,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey,
//                             ),
//                             maxLines: 3,
//                             softWrap: true,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       width: _graphicSize,
//                       height: _graphicSize,
//                       decoration: const BoxDecoration(
//                         color: Color(0xffF6E7B0),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(_graphicSize / 2),
//                         ),
//                       ),
//                       alignment: Alignment.center,
//                       child: const Text(
//                         '💰',
//                         style: TextStyle(fontSize: 30),
//                       ),
//                     )
//                   ],
//                 ),
//                 DropdownButtonFormField<String>(
//                   value: viewModel.selectedPattern,
//                   onChanged: (String? newValue) {
//                     viewModel.setSelectedPattern(newValue);
//                   },
//                   decoration: InputDecoration(
//                     enabledBorder: const UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black),
//                     ),
//                   ),
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   items: [
//                     'L',
//                     'X',
//                     'Cross',
//                     'Blackout',
//                     'Corners',
//                     'LineVertical',
//                     'LineHorizontal',
//                   ].map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(
//                         value,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.black,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 16),
//                 GestureDetector(
//                   onTap: () {
//                     String? selectedPattern = viewModel.selectedPattern;
//                     if (selectedPattern != null) {
//                       viewModel.setSelectedPattern(selectedPattern);
//                       viewModel.generateBingoCard();

//                       if (viewModel.checkForWin()) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => BingoCardPage(
//                               selectedPattern: selectedPattern,
//                               bingoCardModel: viewModel.bingoCardModel,
//                             ),
//                           ),
//                         );
//                       }
//                     }
//                   },
//                   child: Container(
//                     height: 50,
//                     width: double.infinity,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Text(
//                       'Generate card',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class BingoCardPage extends StatefulWidget {
//   final String selectedPattern;
//   final BingoCardModel bingoCardModel;

//   const BingoCardPage({
//     Key? key,
//     required this.selectedPattern,
//     required this.bingoCardModel,
//   }) : super(key: key);

//   @override
//   _BingoCardPageState createState() => _BingoCardPageState();
// }

// class _BingoCardPageState extends State<BingoCardPage> {
//   @override
//   void initState() {
//     super.initState();
//     widget.bingoCardModel.generateBingoCard();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bingo Card'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildLabel('B'),
//                 _buildLabel('I'),
//                 _buildLabel('N'),
//                 _buildLabel('G'),
//                 _buildLabel('O'),
//               ],
//             ),
//             SizedBox(
//               height: 16,
//             ),
//             Container(
//               padding: EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Color.fromARGB(255, 0, 0, 0)),
//                 borderRadius: BorderRadius.circular(10.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color:
//                         const Color.fromARGB(255, 248, 1, 1).withOpacity(0.5),
//                     spreadRadius: 3,
//                     blurRadius: 5,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 5,
//                   crossAxisSpacing: 8.0,
//                   mainAxisSpacing: 8.0,
//                 ),
//                 itemCount: 25,
//                 itemBuilder: (context, index) {
//                   int i = index ~/ 5;
//                   int j = index % 5;
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         if (widget.bingoCardModel.bingoCard[i][j] != 0) {
//                           widget.bingoCardModel.toggleCell(i, j);
//                           if (widget.bingoCardModel
//                               .checkForWin(widget.selectedPattern)) {
//                             _showDialogBox();
//                           }
//                         }
//                       });
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black),
//                         borderRadius: BorderRadius.circular(8.0),
//                         color: widget.bingoCardModel.bingoCard[i][j] < 0
//                             ? Colors.blue
//                             : Colors.white,
//                       ),
//                       alignment: Alignment.center,
//                       child: widget.bingoCardModel.bingoCard[i][j] == 0
//                           ? Transform.scale(
//                               scale: 1.5,
//                               child: const Text(
//                                 '⭐',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 35.0,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             )
//                           : Text(
//                               '${widget.bingoCardModel.bingoCard[i][j]}',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20.0,
//                                 color: Colors.black,
//                               ),
//                             ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLabel(String label) {
//     return Container(
//       width: 40.0,
//       height: 40.0,
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black),
//         borderRadius: BorderRadius.circular(8.0),
//         color: Colors.white,
//       ),
//       alignment: Alignment.center,
//       child: Text(
//         label,
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 20.0,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }

//   Future<void> _showDialogBox() async {
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Bingo!'),
//           content: const Text('Congratulations! You have achieved Bingo!'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
