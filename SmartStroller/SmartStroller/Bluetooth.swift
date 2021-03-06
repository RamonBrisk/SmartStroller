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
        if peripheral.name == "MLT-BT05" {
            carPeripheral = peripheral
            print("赋值peripheral")
            carPeripheral.delegate = self
            print("设置代理成功")
            central.stopScan()
            print("停止扫描")
            centralManager.connect(carPeripheral)
            print("尝试连接")
        }
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("蓝牙连接成功")
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
        
        
        var packageArray = [UInt8](repeating: 0, count: 4)
        var pressureArray = [UInt8](repeating: 0, count: 4)
        var temperatureArray = [UInt8](repeating: 0, count: 4)
        var ambientArray = [UInt8](repeating: 0, count: 4)
        var objectArray = [UInt8](repeating: 0, count: 4)
        var airQualityArray = [UInt8](repeating: 0, count: 4)
        var soundArray = [UInt8](repeating: 0, count: 4)
        var longitudeArray = [UInt8](repeating: 0, count: 4)
        var latitudeArray = [UInt8](repeating: 0, count: 4)
        var altitudeArray = [UInt8](repeating: 0, count: 4)
        var speedArray = [UInt8](repeating: 0, count: 4)
        var sateliteArray = [UInt8](repeating: 0, count: 4)
        var humidityArray = [UInt8](repeating: 0, count: 4)
        var distanceArray = [UInt8](repeating: 0, count: 4)
        
        
        if byteArray.count == 20{
            
            //解析出包数据头
            for i in 0...3 {
                packageArray[i] = byteArray[i]
            }
            
            
            // 判断是第一包数据
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
                
                DataStore.sensorData[0] = Float(pressureu32) / 100
                DataStore.sensorData[1] = Float(temperatureu32) / 10
                DataStore.sensorData[2] = Float(bitPattern: ambient32)
                DataStore.sensorData[3] = Float(bitPattern: object32)
                
                
            }
            //判断是第二包数据
            if packageArray[0] == 1 {
                
                
                for i in 4...7 {
                    airQualityArray[i-4] = byteArray[i]
                }
                
                for i in 8...11 {
                    soundArray[i-8] = byteArray[i]
                }
                
                for i in 12...15 {
                    longitudeArray[i-12] = byteArray[i]
                }
                
                for i in 16...19 {
                    latitudeArray[i-16] = byteArray[i]
                }
                
                let airQuality32 = airQualityArray.reversed().reduce(0) { soFar, byte in
                    return soFar << 8 | UInt32(byte)
                }
                
                let sound32 = soundArray.reversed().reduce(0) { soFar, byte in
                    return soFar << 8 | UInt32(byte)
                }
                
                let longitude32 = longitudeArray.reversed().reduce(0) { soFar, byte in
                    return soFar << 8 | UInt32(byte)
                }
                
                let latitude32 = latitudeArray.reversed().reduce(0) { soFar, byte in
                    return soFar << 8 | UInt32(byte)
                }
           
                DataStore.sensorData[4] = Float(bitPattern: airQuality32)
                DataStore.sensorData[5] = Float(bitPattern: sound32)
                
                if Float(bitPattern: longitude32) != 0 {
                DataStore.sensorData[6] = Float(bitPattern: longitude32)
                }
                
                if Float(bitPattern: latitude32) != 0 {
                DataStore.sensorData[7] = Float(bitPattern: latitude32)
                }
            }
            
            
            //判断是第三包数据
            if packageArray[0] == 2 {
                
                for i in 4...7 {
                    altitudeArray[i-4] = byteArray[i]
                }
                
                for i in 8...11 {
                    speedArray[i-8] = byteArray[i]
                }
                for i in 12...15 {
                    sateliteArray[i-12] = byteArray[i]
                }
                for i in 16...19 {
                    humidityArray[i-16] = byteArray[i]
                }
                
                
                
                let altitude32 = altitudeArray.reversed().reduce(0) { soFar, byte in
                    return soFar << 8 | UInt32(byte)
                }
                
                let speed32 = speedArray.reversed().reduce(0) { soFar, byte in
                    return soFar << 8 | UInt32(byte)
                }
                
                let satelite32 = sateliteArray.reversed().reduce(0) { soFar, byte in
                    return soFar << 8 | UInt32(byte)
                }
                
                let humidity32 = humidityArray.reversed().reduce(0) { soFar, byte in
                    return soFar << 8 | UInt32(byte)
                }
                
                DataStore.sensorData[8] = Float(bitPattern: altitude32)
                DataStore.sensorData[9] = Float(bitPattern: speed32)
                DataStore.sensorData[10] = Float(Int(satelite32))
                DataStore.sensorData[11] = Float(bitPattern: humidity32)
                
                
                
            }
            
            
            
            
            //判断是第四包数据
            if packageArray[0] == 3 {
                
                for i in 4...7 {
                    distanceArray[i-4] = byteArray[i]
                }
                
            
            
                let distance32 = distanceArray.reversed().reduce(0) { soFar, byte in
                    return soFar << 8 | UInt32(byte)
                }
            
            
                DataStore.sensorData[12] = Float(bitPattern: distance32)

            }
            
            for i in 0...12 {
                print(DataStore.sensorData[i])
            }
            
            
        }
        
        
        
        var JSON = "{\"pressure\":\(DataStore.sensorData[0]),\"pressureTemp\":\(DataStore.sensorData[1]),\"ambientTemp\":\(DataStore.sensorData[2]),\"objectTemp\":\(DataStore.sensorData[3]),\"airQuality\":\(DataStore.sensorData[4]),\"sound\":\(DataStore.sensorData[5]),\"longitude\":\(DataStore.sensorData[6]),\"attitude\":\(DataStore.sensorData[7]),\"altitude\":\(DataStore.sensorData[8]),\"speed\":\(DataStore.sensorData[9]),\"satellites\":\(DataStore.sensorData[10]),\"humidity\":\(DataStore.sensorData[11]),\"distance\":\(DataStore.sensorData[12])}"
        
        //0压力值，1压力温度，2环境温度，3物体温度，4空气质量，
        //5声音,6经度，7纬度，8卫星海拔，9速度，10卫星数,11空气湿度,12距离
        
        mqttManager.publish(message: JSON, topic: "strollerData")
        //...more sensor data
        
    }
}


