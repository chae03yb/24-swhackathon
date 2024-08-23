import "package:bluetooth_classic/bluetooth_classic.dart";


class BluetoothHelper {
  BluetoothHelper._();

  static final BluetoothHelper instance = BluetoothHelper._();
  BluetoothClassic bluetoothClassicInstance;

  factory BluetoothHelper() {
    return instance;
  }

  void init() {
    bluetoothClassicInstance = BluetoothClassic();
  }

  void getRecordFile() async {

  }

  void getBrakeRecordFile() async {

  }

  void getRPMRecordFile() async {

  }
}