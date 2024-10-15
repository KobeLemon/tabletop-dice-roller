import 'dart:math';

import "package:flutter/material.dart";
import "package:flutter/services.dart";

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:provider/provider.dart";

void main() {
  // These two force the app to stay in portrait mode, regardless how the user moves the phone
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // This function runs the app itself.
  runApp(const MyApp());
}

// ==================== Start of Overall App Class/State ==================== //
// This class creates the overall app itself.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MyAppState(),
      child: MaterialApp(
        title: "Tabletop Dice Roller",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

// This class creates a Dice object with its properties
class Dice {
  int maxFace;
  int currentFace;

  Dice(
    this.maxFace,
    this.currentFace,
  );
}

// This class creates the app's overall state, inheriting from ChangeNotifier
class MyAppState extends ChangeNotifier {
  int modifier = 0; // modifiers for skills, injuries, etc.
  String diceBaseImagePath = "assets/images/"; // base path for all images
  int totalSum = 0; // total sum of latest dice rolls
  List<String> rollHistory = <String>[]; // keeps track of the dice roll history
  String rollSummary = "";

  // This list keeps track of how many dice will be rolled at a time.
  // Default is empty. For testing purposes, I will use 1 of each
  List<Dice> diceList = <Dice>[
    // maxFace, currentFace, count
    Dice(2, 2),
    Dice(3, 3),
    Dice(4, 4),
    Dice(6, 6),
    Dice(8, 8),
    Dice(10, 10),
    Dice(12, 12),
    Dice(20, 20),
    Dice(100, 100),
    Dice(2, 2),
    Dice(3, 3),
    Dice(4, 4),
    Dice(6, 6),
    Dice(8, 8),
    Dice(10, 10),
    Dice(12, 12),
    Dice(20, 20),
    Dice(100, 100),
    Dice(2, 2),
    Dice(3, 3),
    Dice(4, 4),
    Dice(6, 6),
    Dice(8, 8),
    Dice(10, 10),
    Dice(12, 12),
    Dice(20, 20),
    Dice(100, 100),
  ];

  // Generate a random face number between 1 and the current dice's maxFace, then add that number to the total.
  void rollDice() {
    totalSum = 0;
    rollSummary = "";
    if (diceList.isNotEmpty) {
      for (Dice dice in diceList) {
        int random = Random().nextInt(dice.maxFace) + 1;
        dice.currentFace = random + modifier;
        totalSum += dice.currentFace;
        rollSummary += "\nd${dice.maxFace}: ${dice.currentFace}";
      }
      rollHistory.add("Rolled $totalSum total. $rollSummary");
    }
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  // add dice to the list & sort it by smallest to largest maxFace
  void addDice(int maxFaceAdd, int currentFaceAdd) {
    diceList.add(Dice(maxFaceAdd, currentFaceAdd));
    diceList.sort(
        (Dice diceA, Dice diceB) => diceA.maxFace.compareTo(diceB.maxFace));
    notifyListeners();
  }
}
// ==================== End of Overall App Class/State ==================== //

// ==================== Start of Home Page Class/State ==================== //
// This class creates the Home Page with its state
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
  const MyHomePage({super.key});
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    // This switch statement sets the page navigation logic.
    // Eventually there will be four pages, but the two unused pages just route to the home page for now.
    switch (selectedIndex) {
      case 0:
        page = const RollDicePage();
        break;
      case 1:
        page = const RollHistoryPage();
        // page = const AddDicePage();
        break;
      case 2:
        page = const RollDicePage();
        // page = const AddModifiersPage();
        break;
      case 3:
        page = const RollDicePage();
      // page = const RollHistoryPage();
      default:
        page = const RollDicePage();
      // throw UnimplementedError("no widget for $selectedIndex");
    }

    return mainLayoutBuilder(page);
  }
// ==================== End of Home Page Class/State ==================== //

// ==================== Start of Main Layout Builder ==================== //
  // This method builds the main layout of the app.
  LayoutBuilder mainLayoutBuilder(Widget page) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
          body: Row(
            children: [
              // Main Content
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
          bottomNavigationBar: bottomNavBar());
    });
  }

  // Main Bottom Navigation Bar
  NavigationBar bottomNavBar() {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          selectedIndex = index;
        });
      },
      indicatorColor: Colors.amber,
      selectedIndex: selectedIndex,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(FontAwesomeIcons.house),
          label: 'Home',
        ),
        // NavigationDestination(
        //   icon: Icon(FontAwesomeIcons.dice),
        //   label: 'Add Dice',
        // ),
        // NavigationDestination(
        //   icon: Icon(FontAwesomeIcons.plus),
        //   label: 'Add Modifiers',
        // ),
        NavigationDestination(
          icon: Icon(FontAwesomeIcons.clock),
          label: 'Roll History',
        ),
      ],
    );
  }
}

// ==================== End of Main Layout Builder ==================== //

// ==================== Start of App Pages ==================== //

// ============= Start of Home Roll Dice Page ============= //
// This class creates the main roll dice page with its state
class RollDicePage extends StatefulWidget {
  const RollDicePage({super.key});

  @override
  State<RollDicePage> createState() => _RollDicePageState();
}

class _RollDicePageState extends State<RollDicePage> {
  int imageIndex = 6;
  int maxFace = 6; // Default maxFace is 6

  @override
  Widget build(BuildContext context) {
    MyAppState appState = context.watch<MyAppState>();
    ThemeData theme = Theme.of(context);
    TextStyle titleStyle = theme.textTheme.displayMedium!;

    /// TESTING ONLY -- REMOVE THIS SORT WHEN done testing
    appState.diceList.sort(
        (Dice diceA, Dice diceB) => diceA.maxFace.compareTo(diceB.maxFace));

    return appState.diceList.isEmpty
        // if no dice are selected, notify the user about such. This is default.
        ? const Center(
            child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "No dice selected!\nClick \"Add Dice\" at the bottom to add more dice.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ))

        // if at least one dice is selected, display all available dice.
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: SafeArea(
                    child: Text(
                      "Total:" "${appState.totalSum}",
                      style: titleStyle,
                    ),
                  ),
                ),
                DiceListDisplay(appState: appState, titleStyle: titleStyle),
                Container(
                  margin: const EdgeInsets.all(16.0),
                  child: RollDiceBtn(appState: appState),
                ),
              ],
            ),
          );
  }
}

// This class creates a DiceItem which is the visual representation of a dice
class DiceItem extends StatelessWidget {
  const DiceItem({
    super.key,
    required this.appState,
    required this.dice,
  });

  final MyAppState appState;
  final Dice dice;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        width: 100,
        child: Stack(alignment: Alignment.center, children: <Widget>[
          // The dice's base image. The images are blank silhouettes of real dice shapes.
          Image.asset(
            //Example:d20_blank.png
            "${appState.diceBaseImagePath}d${dice.maxFace}_blank.png",
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // The dice's max face that can be rolled
              Text(
                "${dice.currentFace}",
                style: const TextStyle(color: Colors.white, fontSize: 40),
              ),
              // the type of dice it is (d2, d4, etc.)
              Container(
                  width: 40,
                  decoration: const BoxDecoration(
                      border: Border(
                    top: BorderSide(
                      color: Colors.white,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  )),
                  child: Text(
                    "d${dice.maxFace}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ))
            ],
          )
        ]));
  }
}

// This class displays all selected dice
class DiceListDisplay extends StatelessWidget {
  const DiceListDisplay({
    super.key,
    required this.titleStyle,
    required this.appState,
  });

  final TextStyle titleStyle;
  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    List<Widget> diceItemList = [];

    for (Dice dice in appState.diceList) {
      diceItemList.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: DiceItem(appState: appState, dice: dice),
      ));
    }

    return Expanded(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Wrap(
              spacing: 20.0, // Horizontal spacing between items
              runSpacing: 8.0, // Vertical spacing between rows
              alignment: WrapAlignment.center, // Center the items
              children: diceItemList,
            ),
          ],
        ),
      ),
    );
  }
}

// This class creates the roll dice button which triggers the roll dice functionality
class RollDiceBtn extends StatelessWidget {
  const RollDiceBtn({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        appState.rollDice();
      },
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 30,
          fontStyle: FontStyle.italic,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Roll Dice"),
            SizedBox(
              width: 10,
            ),
            Icon(FontAwesomeIcons.dice),
          ],
        ),
      ),
    );
  }
}

// ============= End of Home Roll Dice Page ============= //

// ============= Start of Roll History Page ============= //
// This class creates the Roll History Page which is a history of all rolls,
//   including the faces of all dice.
class RollHistoryPage extends StatelessWidget {
  const RollHistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    MyAppState appState = context.watch<MyAppState>();
    ThemeData theme = Theme.of(context);
    TextStyle titleStyle = theme.textTheme.displayMedium!;

    if (appState.rollHistory.isEmpty) {
      return Center(
        child: Text(
          "No rolls yet",
          style: titleStyle,
        ),
      );
    }
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const SizedBox(
            height: 30,
          ),
          for (String roll in appState.rollHistory) ...[
            Card(
              color: theme.colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                    child: Text(
                  roll,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                )),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}
// ============= End of Roll History Page ============= //

// ==================== End of App Pages ==================== //
