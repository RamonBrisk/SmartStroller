//
//  ContentView.swift
//  SmartStroller
//
//  Created by 李杨 on 2021/2/6.
//

import SwiftUI
import CocoaMQTT

var myBluetooth = Bluetooth()
let mqttManager = MqttManager.shared
let screenBounds:CGRect = UIScreen.main.bounds

struct ContentView: View {
    var body: some View {
        ControllerView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .previewDevice("iPad (8th generation)")
        }
    }
}




