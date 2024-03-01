import 'package:stacked/stacked.dart';

class InfoAlertDialogModel extends BaseViewModel {
  String? selectedPattern;

  void setSelectedPattern(String? s) {
    selectedPattern = s;
  }

  void generateBingoCard() {}

  void checkForLPattern() {}
}

// ui/views/cards/cards_viewmodel.dart
// import 'dart:math';

// class BingoCardModel {
//   List<List<int>> bingoCard = [];
//   List<List<int>> sets = List.generate(5, (_) => []);
//   List<List<int>> get getNumbers => sets;
//   List<int> tappedItems = [];

//   void generateBingoCard() {
//     for (var i = 0; i < 5; i++) {
//       for (var j = 0; j < 5; j++) {
//         int value = 0;
//         switch (j) {
//           case 0:
//             value = _generateRandomNumberBasedOnGivenRange(sets[i], 15, 1);
//             break;
//           case 1:
//             value = _generateRandomNumberBasedOnGivenRange(sets[i], 15, 16);
//             break;
//           case 2:
//             if (i == 2 && j == 2) {
//               value = 0;
//             } else {
//               value = _generateRandomNumberBasedOnGivenRange(sets[i], 15, 31);
//             }
//             break;
//           case 3:
//             value = _generateRandomNumberBasedOnGivenRange(sets[i], 15, 46);
//             break;
//           default:
//             value = _generateRandomNumberBasedOnGivenRange(sets[i], 15, 61);
//         }
//         sets[i].add(value);
//       }
//     }
//     bingoCard = List.from(sets);
//   }

//   int _generateRandomNumberBasedOnGivenRange(
//       List<int> uniqueValues, int base, int range) {
//     Random random = Random();
//     int randomValue = (random.nextInt(base) + range);

//     while (uniqueValues.contains(randomValue)) {
//       randomValue = (random.nextInt(base) + range);
//     }

//     uniqueValues.add(randomValue);
//     return randomValue;
//   }

//   void toggleCell(int i, int j) {
//     bingoCard[i][j] = -bingoCard[i][j];
//   }

//   bool checkForWin(String selectedPattern) {
//     switch (selectedPattern) {
//       case 'L':
//         return _checkForWinL();
//       case 'X':
//         return _checkForWinX();
//       case 'Cross':
//         return _checkForWinCross();
//       case 'Blackout':
//         return _checkForWinBlackout();
//       case 'Corners':
//         return _checkForWinCorners();
//       case 'LineVertical':
//         return _checkForWinVertical();
//       case 'LineHorizontal':
//         return _checkForWinHorizontal();
//       default:
//         return false;
//     }
//   }

//   bool _checkForWinBlackout() {
//     if (bingoCard.every((row) => row.every((cell) => cell < 0))) {
//       _showDialogBox();
//       return true;
//     }
//     return false;
//   }

//   bool _checkForWinHorizontal() {
//     for (int i = 0; i < 5; i++) {
//       if (bingoCard[i].every((cell) => cell < 0) ||
//           bingoCard[i].every((cell) => cell > 0)) {
//         _showDialogBox();
//         return true;
//       }
//     }
//     return false;
//   }

//   bool _checkForWinVertical() {
//     for (int j = 0; j < 5; j++) {
//       if (bingoCard.every((row) => row[j] < 0) ||
//           bingoCard.every((row) => row[j] > 0)) {
//         _showDialogBox();
//         return true;
//       }
//     }
//     return false;
//   }

//   bool _checkForWinX() {
//     if (bingoCard[0][0] < 0 &&
//         bingoCard[1][1] < 0 &&
//         bingoCard[3][3] < 0 &&
//         bingoCard[4][4] < 0 &&
//         bingoCard[0][4] < 0 &&
//         bingoCard[1][3] < 0 &&
//         bingoCard[3][1] < 0 &&
//         bingoCard[4][0] < 0) {
//       _showDialogBox();
//       return true;
//     }
//     return false;
//   }

//   bool _checkForWinCross() {
//     if (bingoCard[0][2] < 0 &&
//         bingoCard[1][2] < 0 &&
//         bingoCard[2][0] < 0 &&
//         bingoCard[2][1] < 0 &&
//         bingoCard[2][3] < 0 &&
//         bingoCard[2][4] < 0 &&
//         bingoCard[3][2] < 0 &&
//         bingoCard[4][2] < 0) {
//       _showDialogBox();
//       return true;
//     }
//     return false;
//   }

//   bool _checkForWinL() {
//     if (bingoCard[0][0] < 0 &&
//             bingoCard[0][1] < 0 &&
//             bingoCard[0][2] < 0 &&
//             bingoCard[0][3] < 0 &&
//             bingoCard[0][4] < 0 &&
//             bingoCard[1][4] < 0 &&
//             bingoCard[2][4] < 0 &&
//             bingoCard[3][4] < 0 &&
//             bingoCard[4][4] < 0 ||
//         bingoCard[4][0] < 0 &&
//             bingoCard[4][1] < 0 &&
//             bingoCard[4][2] < 0 &&
//             bingoCard[4][3] < 0 &&
//             bingoCard[4][4] < 0 &&
//             bingoCard[0][4] < 0 &&
//             bingoCard[1][4] < 0 &&
//             bingoCard[2][4] < 0 &&
//             bingoCard[3][4] < 0 ||
//         bingoCard[0][0] < 0 &&
//             bingoCard[0][1] < 0 &&
//             bingoCard[0][2] < 0 &&
//             bingoCard[0][3] < 0 &&
//             bingoCard[0][4] < 0 &&
//             bingoCard[1][0] < 0 &&
//             bingoCard[2][0] < 0 &&
//             bingoCard[3][0] < 0 &&
//             bingoCard[4][0] < 0 ||
//         bingoCard[4][0] < 0 &&
//             bingoCard[4][1] < 0 &&
//             bingoCard[4][2] < 0 &&
//             bingoCard[4][3] < 0 &&
//             bingoCard[4][4] < 0 &&
//             bingoCard[0][0] < 0 &&
//             bingoCard[1][0] < 0 &&
//             bingoCard[2][0] < 0 &&
//             bingoCard[3][0] < 0) {
//       _showDialogBox();
//       return true;
//     }
//     return false;
//   }

//   bool _checkForWinCorners() {
//     if (bingoCard[0][0] < 0 && bingoCard[0][1] < 0 && bingoCard[1][0] < 0 ||
//         bingoCard[0][3] < 0 && bingoCard[0][4] < 0 && bingoCard[1][4] < 0 ||
//         bingoCard[3][4] < 0 && bingoCard[4][3] < 0 && bingoCard[4][4] < 0 ||
//         bingoCard[3][0] < 0 && bingoCard[4][0] < 0 && bingoCard[4][1] < 0 ||
//         bingoCard[1][1] < 0 && bingoCard[1][2] < 0 && bingoCard[2][1] < 0 ||
//         bingoCard[1][2] < 0 && bingoCard[1][3] < 0 && bingoCard[2][3] < 0 ||
//         bingoCard[3][1] < 0 && bingoCard[3][2] < 0 && bingoCard[2][1] < 0 ||
//         bingoCard[3][2] < 0 && bingoCard[3][3] < 0 && bingoCard[2][3] < 0) {
//       _showDialogBox();
//       return true;
//     }
//     return false;
//   }

//   void showDialogBox() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Bingo!'),
//           content: Text('You have won!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
