import "package:flutter/material.dart";

import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';
import "package:provider/provider.dart";

void main() {
  runApp(const MyApp());
}

// ==================== Start of Overall App Class/State ==================== //
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

class MyAppState extends ChangeNotifier {

}
// ==================== End of Overall App Class/State ==================== //

// ==================== Start of Home Page Class/State ==================== //
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
    switch (selectedIndex) {
      case 0:
        page = const RollDicePage();
        break;
      case 1:
        page = const RollHistoryPage();
        break;
      default:
        page = const RollDicePage();
        // throw UnimplementedError("no widget for $selectedIndex");
    }

    return mainLayoutBuilder(page);
  }
// ==================== End of Home Page Class/State ==================== //

// ==================== Start of Main Layout Builder ==================== //
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
        bottomNavigationBar: bottomNavBar()
      );
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
      destinations: <Widget>[
        const NavigationDestination(
          icon: Icon(Ionicons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: SvgPicture.asset(
            'assets/images/dice_pair.svg', 
            semanticsLabel: 'Dice Pair Icon',
            colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
            ),
          label: 'Add Dice',
        ),
        // NavigationDestination(
        //   icon: Icon(Ionicons.add_circle_sharp),
        //   label: 'Add Modifiers',
        // ),
        const NavigationDestination(
          icon: Icon(Ionicons.time),
          label: 'Roll History',
        ),
      ],
    );
  }

}

// ==================== End of Main Layout Builder ==================== //

// ==================== Start of App Pages ==================== //

// ============= Start of Home Generator Page ============= //
class RollDicePage extends StatelessWidget {
  const RollDicePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    MyAppState appState = context.watch<MyAppState>();

    IconData icon;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Home Page"),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }
}
// ============= End of Home Generator Page ============= //

// ============= Start of Roll History Page ============= //
class RollHistoryPage extends StatelessWidget {
  const RollHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    MyAppState appState = context.watch<MyAppState>();
    ThemeData theme = Theme.of(context);
    TextStyle titleStyle = theme.textTheme.displayMedium!;
    TextStyle wordStyle = theme.textTheme.displaySmall!.copyWith(color: theme.colorScheme.onPrimary);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(8), 
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.colorScheme.primary, width: 5)),
            ),
            child: Center(
              child: Text("Roll History", style: titleStyle,)
            ),
          ),
          const SizedBox(height: 30,),
          // ClearFavsBtn(appState: appState),
          // SizedBox(height: 30,),
        ],
      ),
    );
  }
}
// ============= Start of Roll History Page ============= //

// ==================== End of App Pages ==================== //


// ==================== Start of App Items ==================== //

// ==================== End of App Items ==================== //
