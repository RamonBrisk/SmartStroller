//
//  DataStore.swift
//  DashBoard
//
//  Created by 李杨 on 2021/1/27.
//

import SwiftUI


class DataStore: ObservableObject{
    @Published var BluetoothState:String
    //0压力值，1压力温度，2环境温度，3物体温度，4空气质量，5声音,6经度，7纬度，8卫星海拔，9速度，10卫星数
    @Published var sensorData:[Float]
    init() {
        BluetoothState = ""
        sensorData = [0,0,0,0,0,0,0,0,0,0,0]
    }
    
}
