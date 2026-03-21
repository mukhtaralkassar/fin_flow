// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:fin_flow/data/data_sources/local/transaction_local_data_source.dart';
import 'package:fin_flow/data/repositories/transaction_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fin_flow/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
     final sharedPrefs = await SharedPreferences.getInstance();
    final localDataSource = TransactionLocalDataSourceImpl(sharedPreferences: sharedPrefs);
    final repository = TransactionRepositoryImpl(localDataSource: localDataSource);
    // Build our app and trigger a frame.
    await tester.pumpWidget(FinFlowApp(repository: repository));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.pumpAndSettle();
    expect(find.text('FinFlow'), findsOneWidget);

  });
}
