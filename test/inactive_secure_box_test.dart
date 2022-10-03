import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inactive_secure_box/inactive_secure_box.dart';

void main() {
  testWidgets('verify wrapper logic', (tester) async {
    const key = Key('inactive');
    await tester.pumpWidget(
      makeTestableApp(const InactiveSecureBox(child: Text('Foo bar'))),
    );
    // return widget in normal mode
    expect(find.byKey(key), findsNothing);
    // turn up AppLifecycleState to inactive, enable inactive mode
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(find.byKey(key), findsOneWidget);
  });

  testWidgets('verify inline InactiveSecureBox', (tester) async {
    const key = Key('inactive');
    await tester.pumpWidget(
      makeTestableApp(
        Column(
          children: const [
            InactiveSecureBox(child: Text('1')),
            Text('2'),
            InactiveSecureBox(child: Text('3')),
          ],
        ),
      ),
    );

    // turn up AppLifecycleState to inactive, enable inactive mode
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(find.byKey(key), findsNWidgets(2));
  });

  testWidgets('verify nested InactiveSecureBox', (tester) async {
    const key = Key('inactive');
    await tester.pumpWidget(
      makeTestableApp(
        InactiveSecureBox(
          child: Column(
            children: const [
              InactiveSecureBox(child: Text('1')),
              Text('2'),
              InactiveSecureBox(child: Text('3')),
            ],
          ),
        ),
      ),
    );

    // turn up AppLifecycleState to inactive, enable inactive mode
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(find.byKey(key), findsOneWidget);
  });
}

Widget makeTestableApp(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}
