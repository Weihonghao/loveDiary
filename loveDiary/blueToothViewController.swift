//
//  blueToothViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/18.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit
import CoreBluetooth

class blueToothViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    
    @IBOutlet weak var statusLabel: UILabel!

    @IBOutlet weak var resultLabel: UILabel!
    
    //@IBOutlet weak var temperatureLabel: UILabel!
    
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    
    
    let IRTemperatureServiceUUID = CBUUID(string: "00009800-0000-1000-8000-00177A000002")
    let IRTemperatureDataUUID   = CBUUID(string: "0000AA00-0000-1000-8000-00177A000002")
    let IRTemperatureConfigUUID = CBUUID(string: "0000AA00-0000-1000-8000-00177A000002")

    
    
    let BEAN_NAME = "Seos"
    let BEAN_SCRATCH_UUID =
        CBUUID(string: "a495ff21-c5b1-4b44-b512-1370f02d74de")
    let BEAN_SERVICE_UUID =
        CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74de")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: nil)
        statusLabel.text = "loading"
        resultLabel.text = "00.00"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
            statusLabel.text = "Searching for bluetooth Devices"
        } else {
            print("Bluetooth not available.")
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let device = (advertisementData as NSDictionary)
            .object(forKey: CBAdvertisementDataLocalNameKey)
            as? NSString
        print("fuck you tag \(device)")
        if device?.contains(BEAN_NAME) == true {
            
            self.statusLabel.text = "User Found"
            self.manager.stopScan()
            self.peripheral = peripheral
            self.peripheral.delegate = self
            
            manager.connect(peripheral, options: nil)
        } else {
            self.statusLabel.text = "User Not Found"
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        self.statusLabel.text = "Looking at peripheral services"
        for service in peripheral.services! {
            let thisService = service as CBService
            
            print("fuck sange \(service.uuid)")
            if service.uuid == IRTemperatureServiceUUID {
                //BEAN_SERVICE_UUID {
                peripheral.discoverCharacteristics(
                    nil,
                    for: thisService
                )
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            
            self.statusLabel.text = "Enabling sensors"
            
            // 0x01 data byte to enable sensor
            var enableValue = 1
            let enablyBytes = NSData(bytes: &enableValue, length: MemoryLayout<UInt8>.size)
            
            
            let thisCharacteristic = characteristic as CBCharacteristic
            
            print("fuck third \(thisCharacteristic.uuid)")
            if thisCharacteristic.uuid == IRTemperatureDataUUID {
                //BEAN_SCRATCH_UUID {
                print("fuck succeed")
                self.peripheral.setNotifyValue(
                    true,
                    for: thisCharacteristic
                )
            }
            
            if thisCharacteristic.uuid == IRTemperatureConfigUUID {
                //BEAN_SCRATCH_UUID {
                self.peripheral.writeValue(enablyBytes as Data, for: thisCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        self.statusLabel.text = "Connected"
        print("fuck fourth \(characteristic.uuid)")
        var count:UInt32 = 0
        if characteristic.uuid == IRTemperatureDataUUID {
            // Convert NSData to array of signed 16 bit values
            print("finally succeed")
            let dataBytes = characteristic.value
            let dataLength = dataBytes?.count
            let ambientTemperature = String([UInt8](dataBytes!)[0])
            print("\(ambientTemperature)")
            //var dataArray = [Int16](repeating: 0, count: dataLength!)
            //dataBytes?.copyBytes(to: &UInt8(count), count: MemoryLayout<UInt8>.size)
            //dataBytes?.copyBytes(to: &UInt8(count), count: MemoryLayout<UInt32>.size)
            // Element 1 of the array will be ambient temperature raw value
            //let ambientTemperature = Double(dataArray[1])/128
            //print("fuck \(ambientTemperature)")
            
            // Display on the temp label
            self.resultLabel.text = ambientTemperature
        }
    }
    
    /*func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        var count:UInt32 = 0;
        
        if descriptor.uuid == BEAN_SCRATCH_UUID {
            (descriptor.value! as AnyObject).getBytes(&count, length: MemoryLayout<UInt32>.size)
            //labelCount.text = NSString(format: "%llu", count) as String
            print("\(count)")
        }
    }*/
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.statusLabel.text = "Disconnected"
        central.scanForPeripherals(withServices: nil, options: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
