//
//  Bluetooth.swift
//  DashBoard
//
//  Created by 李杨 on 2021/1/27.
//

import Foundation
import CoreBluetooth
import Combine
import SwiftUI


class Bluetooth: NSObject, CBCentralManagerDelegate,CBPeripheralDelegate,ObservableObject
{
    
    @ObservedObject var DataStore:DataStore
    @Published var isControllable = false
    var centralManager: CBCentralManager!
    var carPeripheral: CBPeripheral!
    let carServiceCBUUID = CBUUID(string: "FFE0")
    var carCharacteristic:CBCharacteristic?
    
    override init() {
        DataStore = SmartStroller.DataStore()
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("found unknown")
        case .resetting:
            print("found resetting")
        case .unsupported:
            print("found unsupported")
        case .unauthorized:
            print("found unauthorized")
        case .poweredOff:
            print("found poweredOff")
        case .poweredOn:
            print("found poweredOn")
            DataStore.BluetoothState = "蓝牙已开启"
            print(central.isScanning)
            central.scanForPeripherals(withServices: nil, options: nil)
            print(centralManager.isScanning)
        @unknown default:
            print("found default")
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        if peripheral.name == "HC-08" {
            carPeripheral = peripheral
            carPeripheral.delegate = self
            central.stopScan()
            centralManager.connect(carPeripheral)
        }
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected")
        DataStore.BluetoothState = "蓝牙已连接"
        carPeripheral.discoverServices([carServiceCBUUID])
        isControllable = true
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        DataStore.BluetoothState = "蓝牙连接失败"
    }
    
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        
        
        for characteristic in characteristics {
            print(characteristic)
            carCharacteristic = characteristic
            peripheral.discoverDescriptors(for: characteristic)
            
            
            
            
            
            //            if characteristic.properties.contains(.read) {
            //                print("\(characteristic.uuid): properties contains .read")
            //                peripheral.readValue(for: characteristic)
            //            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        print("didDiscoverDescriptors")
    }
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        DataStore.BluetoothState = "蓝牙已断开连接"
        centralManager.connect(carPeripheral)
        isControllable = false
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        
        guard let characteristicData = characteristic.value else { return }
        let byteArray = [UInt8](characteristicData)
        print(byteArray)
        
        
        var packageArray = [UInt8](repeating: 0, count: 4)
        var pressureArray = [UInt8](repeating: 0, count: 4)
        var temperatureArray = [UInt8](repeating: 0, count: 4)
        var ambientArray = [UInt8](repeating: 0, count: 4)
        var objectArray = [UInt8](repeating: 0, count: 4)
        var airQualityArray = [UInt8](repeating: 0, count: 4)
        var soundArray = [UInt8](repeating: 0, count: 4)
        
        
        if byteArray.count == 20{
            
            
            for i in 0...3 {
                packageArray[i] = byteArray[i]
            }
            
            
            
            if packageArray[0] == 0
            
            {
                
                for i in 4...7 {
                    pressureArray[i-4] = byteArray[i]
                }
                
                
                for i in 8...11 {
                    temperatureArray[i-8] = byteArray[i]
                }
                
                
                for i in 12...15 {
                    ambientArray[i-12] = byteArray[i]
                }
                
                
                for i in 16...19 {
                    objectArray[i-16] = byteArray[i]
                }
                
                
                
                
                
                
                let pressureu32 = pressureArray.reversed().reduce(0) { soFar, byte in
                    return soFar << 8 | UInt32(byte)
                }
                
                let temperatureu32 = temperatureArray.reversed().reduce(0) { soFar, byte in
                    return soFar << 8 | UInt32(byte)
                }
                
                let ambient32 = ambientArray.reversed().reduce(0) { soFar, byte in
                    return soFar << 8 | UInt32(byte)
                }
                
                let object32 = objectArray.reversed().reduce(0) { soFar, byte in
                    return soFar << 8 | UInt32(byte)
                }
                
                DataStore.sensorData[0] = Double(pressureu32) / 100
                DataStore.sensorData[1] = Double(temperatureu32) / 10
                DataStore.sensorData[2] = Double(ambient32)/100
                DataStore.sensorData[3] = Double(object32)/100

                
            }
            
            if packageArray[0] == 1 {
                
                
                for i in 4...7 {
                    airQualityArray[i-4] = byteArray[i]
                }
                
                
                for i in 8...11 {
                    soundArray[i-8] = byteArray[i]
                }

                
                let airQuality32 = airQualityArray.reversed().reduce(0) { soFar, byte in
                    return soFar << 8 | UInt32(byte)
                }
                
                let sound32 = soundArray.reversed().reduce(0) { soFar, byte in
                    return soFar << 8 | UInt32(byte)
                }
                

                DataStore.sensorData[4] = Double(airQuality32)
                
                if sound32 == 0 {
                    DataStore.sensorData[5] = 0
                } else {
                    DataStore.sensorData[5] = 1
                }
                
            }
            
            
            
            
        }
        

        //...more sensor data

    }
}


