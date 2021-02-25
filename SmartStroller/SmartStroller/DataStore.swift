//
//  DataStore.swift
//  DashBoard
//
//  Created by 李杨 on 2021/1/27.
//

import SwiftUI
import SwiftUICharts


class DataStore: ObservableObject{
    @Published var BluetoothState:String
    //0压力值，1压力温度，2环境温度，3物体温度，4空气质量，5声音,6经度，7纬度，8卫星海拔，9速度，10卫星数,11空气湿度
    @Published var sensorData:[Float]
    @Published var pressurePair:[(String,Float)]
    @Published var airData:[Double]
    @Published var pressureData:[Double]
    @Published var humidityData:[Double]
    @Published var pressureTempData:[Double]
    @Published var ambientData:[Double]
    @Published var objectData:[Double]
    init() {
        BluetoothState = ""
        sensorData = [0,0,0,0,0,0,0,0,0,0,0,0]
        pressurePair = [("example",2.6)]
        airData = [0]
        pressureData = [0]
        humidityData = [0]
        pressureTempData = [0]
        ambientData = [0]
        objectData = [0]
    }
    
}
