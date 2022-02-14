import 'package:flutter/material.dart';
import 'package:bigsam_pos/menu/home.dart';
import 'package:bigsam_pos/menu/setting.dart';
import 'package:bigsam_pos/menu/transaksi.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyStatefulWidget(),
      initialRoute: '/',
      routes: {
        MyStatefulWidget.routeName: (context) => MyStatefulWidget(
              selectedmenu: 1,
            ),
      },
      onGenerateRoute: (settings) {
        print('onGenerateRoute: ${settings.name}');
        if (settings.name == MyStatefulWidget.routeName) {
          final args = settings.arguments as ScreenArguments;
          print(args);
          return MaterialPageRoute(
            builder: (context) => MyStatefulWidget(
              selectedmenu: args.selectedmenu,
            ),
          );
        }
        return null;
      },
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({this.selectedmenu, Key? key}) : super(key: key);
  final int? selectedmenu;
  static const routeName = '/menu';

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  String _title = '';
  List<Widget> _widgetOptions = [
    Home(),
    Transaksi(),
    Setting(),
  ];

  @override
  Widget build(BuildContext context) {
    print(widget.selectedmenu);
    if (widget.selectedmenu != null && _title == '') {
      _selectedIndex = widget.selectedmenu!;
      _title = 'bigsam';
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              backgroundColor: Colors.blue[800],
              groupAlignment: 0,
              labelType: NavigationRailLabelType.selected,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  selectedIcon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.data_usage,
                    color: Colors.white,
                  ),
                  selectedIcon: Icon(
                    Icons.data_usage,
                    color: Colors.white,
                  ),
                  label:
                      Text('Transaksi', style: TextStyle(color: Colors.white)),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  selectedIcon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  label:
                      Text('Pengaturan', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),

            // This is the main content.
            Expanded(child: _widgetOptions.elementAt(_selectedIndex))
          ],
        ),
      ),
    );
  }
}

class ScreenArguments {
  final int selectedmenu;

  ScreenArguments(this.selectedmenu);
}
