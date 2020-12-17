@Timeout(const Duration(minutes: 2))
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Chat App Performance Tests', () {
    // Register screen
    final usernameField = find.byValueKey("userNameInput");
    final createNewIdentityButton = find.byValueKey("createNewIdentity");

    // Home screen
    final QRButton = find.byValueKey("QRButton");
    final QRImage = find.byValueKey("QRImage");

    // Drawer
    final homeScreen = find.byValueKey("HomeScreen");
    final deleteButton = find.byValueKey("DeleteAcc");

    final SerializableFinder app = find.byValueKey("HomeScreen");
    final SerializableFinder drawerOpenButton = find.byValueKey("Drawer");

    // Screen
    final mainArea = find.byValueKey("MainArea");

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test("Create account", () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(usernameField);
        await driver.enterText("testin");

        await driver.tap(createNewIdentityButton);
        await driver.waitFor(find.text('Inbox'));
      });
    });

    test("Open QR image", () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(QRButton);
        await driver.waitFor(QRImage);
      });
    });

    //TODO: figure out how to open the drawer ):
    test("Delete account", () async {

    });
  });
}
