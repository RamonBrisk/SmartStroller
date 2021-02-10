//
//  ContentView.swift
//  SmartStroller
//
//  Created by 李杨 on 2021/2/6.
//

import SwiftUI

var myBluetooth = Bluetooth()
let screenBounds:CGRect = UIScreen.main.bounds

struct ContentView: View {
    var body: some View {
        ControllerView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
