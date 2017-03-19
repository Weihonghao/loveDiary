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
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    
    
    let BEAN_NAME = "Yiwei"
    let BEAN_SCRATCH_UUID =
        CBUUID(string: "a495ff21-c5b1-4b44-b512-1370f02d74de")
    let BEAN_SERVICE_UUID =
        CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74de")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth not available.")
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let device = (advertisementData as NSDictionary)
            .object(forKey: CBAdvertisementDataLocalNameKey)
            as? NSString
        
        if device?.contains(BEAN_NAME) == true {
            self.manager.stopScan()
            
            self.peripheral = peripheral
            self.peripheral.delegate = self
            
            manager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            
            if service.uuid == BEAN_SERVICE_UUID {
                peripheral.discoverCharacteristics(
                    nil,
                    for: thisService
                )
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            
            if thisCharacteristic.uuid == BEAN_SCRATCH_UUID {
                self.peripheral.setNotifyValue(
                    true,
                    for: thisCharacteristic
                )
            }
        }
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        var count:UInt32 = 0;
        
        if descriptor.uuid == BEAN_SCRATCH_UUID {
            (descriptor.value! as AnyObject).getBytes(&count, length: MemoryLayout<UInt32>.size)
            //labelCount.text = NSString(format: "%llu", count) as String
            print("\(count)")
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
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
