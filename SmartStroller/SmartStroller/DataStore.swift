//
//  DataStore.swift
//  DashBoard
//
//  Created by 李杨 on 2021/1/27.
//

import SwiftUI


class DataStore: ObservableObject{
    @Published var BluetoothState:String
    //压力值，压力温度，环境温度，物体温度，空气质量，声音
    @Published var sensorData:[Double]
    init() {
        BluetoothState = ""
        sensorData = [0,0,0,0,0,0]
    }
    
}
