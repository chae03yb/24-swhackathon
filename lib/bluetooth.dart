import "dart:typed_data";

import "package:bluetooth_classic/bluetooth_classic.dart";

class DeviceNotPairedError extends Error {}

class BluetoothHelper {
  BluetoothHelper._();

  static final BluetoothHelper instance = BluetoothHelper._();
  BluetoothClassic bluetoothClassicInstance = BluetoothClassic();
  bool connected = false;
  Uint8List rawData = Uint8List(0);

  factory BluetoothHelper() {
    return instance;
  }

  void init() {
    bluetoothClassicInstance.initPermissions();
  }

  void connect(String address, String serviceUUID) async {
    connected = await bluetoothClassicInstance.connect(address, serviceUUID);
  }

  void disconnect() async {
    if (!connected) {
      throw DeviceNotPairedError();
    }

    connected = await bluetoothClassicInstance.disconnect();
  }

  void getRecordFile() async {
    if (!connected) {
      throw DeviceNotPairedError();
    }

    await bluetoothClassicInstance.write("PULL REC");
  }

  void getBrakeRecordFile() async {
    if (!connected) {
      throw DeviceNotPairedError();
    }

    await bluetoothClassicInstance.write("PULL BRK");
  }

  void getRPMRecordFile() async {
    if (!connected) {
      throw DeviceNotPairedError();
    }

    await bluetoothClassicInstance.write("PULL RPM");
  }

  void onDataReceivedHandler(Function f) {
    bluetoothClassicInstance.onDeviceDataReceived().listen((event) {
      rawData = Uint8List.fromList([...rawData, ...event]);
    });
  }
}
