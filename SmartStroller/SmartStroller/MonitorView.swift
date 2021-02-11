//
//  MonitorView.swift
//  SmartStroller
//
//  Created by 李杨 on 2021/2/7.
//

import SwiftUI
import SwiftUICharts
import Progress_Bar

struct MonitorView: View {
    
    @Binding var showMonitors:Bool
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var DataStore:DataStore = myBluetooth.DataStore
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
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
                
                BarChartView(data: ChartData(values: DataStore.pressurePair), title: "气压数据")
                
                
                LineView(data: [948.65,958.56,1011.7,1000.6,955.87], title: "气压数据", legend: "过去24小时气压数据")
                    .frame(height:380)
                
                
                
                VStack {
                    
                    Text("空气湿度")
                        .font(.title)
                        .foregroundColor(colorScheme == .light ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)): Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    
                    CircularProgress(percentage:  CGFloat(DataStore.sensorData[11]/100),
                                     fontSize: 25,
                                     backgroundColor: colorScheme == .light ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
                                     fontColor : colorScheme == .light ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)): Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)),
                                     borderColor1: .blue,
                                     borderColor2: LinearGradient(gradient: Gradient(colors: [.pink, .blue]),startPoint: .top, endPoint: .bottom),
                                     borderWidth: 20
                    )
                    .frame(width: 200, height: 200)
                }
                .padding()
                .background(colorScheme == .light ? Color(#colorLiteral(red: 0.09554057568, green: 0.6370621324, blue: 0.3586583138, alpha: 1)): Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)))
                .cornerRadius(30)
                
                
                
                
            
                
                HStack{
                    BarChartView(data: ChartData(values: [("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]), title: "Sales", legend: "Quarterly")
                    
                    BarChartView(data: ChartData(values: [("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]), title: "Sales", legend: "Quarterly")
                }
                
                
                
                
                
                
                
                
                
                LineView(data: [527,589,480,457,600,78,], title: "海拔高度", legend: "过去24小时海拔变化")
                    .frame(height:380)
                
                HStack {
                    LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "温度", legend: "温度记录")
                    LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "湿度", legend: "适度记录")
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
