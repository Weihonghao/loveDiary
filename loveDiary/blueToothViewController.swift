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
    
    //to show current status
    @IBOutlet weak var statusLabel: UILabel!
    
    // show result
    @IBOutlet weak var resultLabel: UILabel!
    
    
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    
    
    let ServiceUUID = CBUUID(string: "00009800-0000-1000-8000-00177A000002")
    let DataUUID   = CBUUID(string: "0000AA00-0000-1000-8000-00177A000002")
    let ConfigUUID = CBUUID(string: "0000AA00-0000-1000-8000-00177A000002")
    
    
    
    let deviceName = "Seos"
    
    
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
    
    
    //search for device
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
            statusLabel.text = "Searching for bluetooth Devices"
        } else {
            print("Bluetooth not available.")
        }
    }
    
    //when user found or not found
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let device = (advertisementData as NSDictionary)
            .object(forKey: CBAdvertisementDataLocalNameKey)
            as? NSString
        if device?.contains(deviceName) == true {
            
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
    
    //see the peripheral services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        self.statusLabel.text = "Looking at peripheral services"
        for service in peripheral.services! {
            let thisService = service as CBService
            
            if service.uuid == ServiceUUID {
                peripheral.discoverCharacteristics(
                    nil,
                    for: thisService
                )
            }
        }
    }
    
    //enable sensots
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            
            self.statusLabel.text = "Enabling sensors"
            
            // 0x01 data byte to enable sensor
            var enableValue = 1
            let enablyBytes = NSData(bytes: &enableValue, length: MemoryLayout<UInt8>.size)
            
            
            let thisCharacteristic = characteristic as CBCharacteristic
            
            if thisCharacteristic.uuid == DataUUID {
                self.peripheral.setNotifyValue(
                    true,
                    for: thisCharacteristic
                )
            }
            
            if thisCharacteristic.uuid == ConfigUUID {
                self.peripheral.writeValue(enablyBytes as Data, for: thisCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    
    // read data, transform from data to array of string
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        self.statusLabel.text = "Connected"
        //var count:UInt32 = 0
        if characteristic.uuid == DataUUID {
            // Convert NSData to array of string
            print("finally succeed")
            let dataBytes = characteristic.value
            //let dataLength = dataBytes?.count
            let ambientTemperature = String([UInt8](dataBytes!)[0])
            print("\(ambientTemperature)")
            
            self.resultLabel.text = ambientTemperature
        }
    }
    
        
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
