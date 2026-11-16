import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_banking_app/app.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('BankingApp renders and navigates seamlessly across all 4 tabs', (
    WidgetTester tester,
  ) async {
    // 1. Build our app and trigger frames
    await tester.pumpWidget(const BankingApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verify Tab 0 (Wallet): main balance text & quick action buttons exist
    expect(find.text('\$2,246'), findsOneWidget);
    expect(find.text('18.92 XMR'), findsNWidgets(2)); // Displayed on Hero Card and Featured Card
    expect(find.text('Recieve'), findsOneWidget);
    expect(find.text('Send'), findsOneWidget);
    expect(find.text('Portfolio'), findsOneWidget);

    // 2. Switch to Tab 1 (Analytics)
    await tester.tap(find.byIcon(Icons.bar_chart_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Analytics'), findsOneWidget);
    expect(find.text('Portfolio Net Worth'), findsOneWidget);
    expect(find.text('Asset Allocation'), findsOneWidget);
    expect(find.text('Cash Flow & Savings'), findsOneWidget);

    // 3. Switch to Tab 2 (Transact)
    await tester.tap(find.byIcon(Icons.monetization_on_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Transact'), findsOneWidget);
    expect(find.text('Convert & Swap'), findsOneWidget);
    expect(find.text('Review Swap'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);

    // 4. Switch to Tab 3 (Profile)
    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Profile & Settings'), findsOneWidget);
    expect(find.text('Alex Vance'), findsOneWidget);
    expect(find.text('Tier 3 Pro • VIP'), findsOneWidget);
    expect(find.text('Security & Access'), findsOneWidget);

    // 5. Navigate back to Tab 0 (Wallet)
    await tester.tap(find.byIcon(Icons.account_balance_wallet_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('\$2,246'), findsOneWidget);
    expect(find.text('Portfolio'), findsOneWidget);
  });
}
