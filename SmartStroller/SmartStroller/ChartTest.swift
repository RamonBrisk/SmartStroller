//
//  ChartTest.swift
//  SmartStroller
//
//  Created by 李杨 on 2021/2/24.
//

import SwiftUI
import SwiftUICharts

struct ChartTest: View {
    var body: some View {
        LineView(data: [8,23,54,32,12,37,7,23,43], title: "湿度", legend: "湿度记录")
    }
}

struct ChartTest_Previews: PreviewProvider {
    static var previews: some View {
        ChartTest()
            .preferredColorScheme(.dark)
    }
}
