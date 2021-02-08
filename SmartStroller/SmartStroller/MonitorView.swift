//
//  MonitorView.swift
//  SmartStroller
//
//  Created by 李杨 on 2021/2/7.
//

import SwiftUI
import SwiftUICharts

struct MonitorView: View {
    
    @Binding var showMonitors:Bool
    
    var body: some View {
        ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false) {
            
            LazyVStack{
            
            HStack{
                Text("传感器数据")
                    .font(.system(size: 40))
                Spacer()
                Image(systemName: "multiply.circle.fill")
                    .font(.system(size: 50))
                    .onTapGesture {
                        showMonitors = false
                    }
            }
            .padding(.horizontal)
            
            
            HStack{
                BarChartView(data: ChartData(values: [("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]), title: "Sales", legend: "Quarterly")
                
                BarChartView(data: ChartData(values: [("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]), title: "Sales", legend: "Quarterly")
            }
            
            
            
            
            
            
                LineView(data: [948.65,958.56,1011.7,1000.6,955.87], title: "气压数据", legend: "过去24小时气压数据")
                    .frame(height:380)
                
            
                LineView(data: [527,589,480,457,600,78,], title: "海拔高度", legend: "过去24小时海拔变化")
                    .frame(height:380)
            
            HStack {
                LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title", legend: "Legendary")
                LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title", legend: "Legendary")
            }
            
            
        }

        }
        .padding(.all)

    }
}

struct MonitorView_Previews: PreviewProvider {
    static var previews: some View {
        MonitorView(showMonitors: .constant(false))
            .preferredColorScheme(.dark)
    }
}
