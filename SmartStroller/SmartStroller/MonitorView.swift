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
    @State var dragState = CGSize.zero
    @State var frameHeight:CGFloat = screenBounds.height/1.3
    
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.990850389, green: 0.6827646494, blue: 0.553073287, alpha: 1)), Color(#colorLiteral(red: 0.5695050359, green: 0.5243335962, blue: 0.5779031515, alpha: 1)).opacity(0.9)]), startPoint: .topLeading, endPoint: .trailing)
            
            
            
            
            ScrollView {
                
                Image("snowsunset")
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenBounds.width, height: frameHeight, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
                    .blur(radius: frameHeight == screenBounds.height/4 ? 3 : 0)
                    .animation(Animation.easeInOut.delay(0.1))
                    .offset(y:frameHeight == screenBounds.height/4 ? -80 : 0)
                    
                    
                    .overlay(
                        
                        VStack {
                            HStack{
                                Text("传感器数据")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "multiply.circle.fill")
                                    .font(.system(size: 50))
                                    .onTapGesture {
                                        showMonitors = false
                                    }
                            }
                            .padding(.horizontal)
                            Spacer()
                        }
                        .padding(.top)
                        
                        
                    )
                    
                ModuleView(DataStore: DataStore, title:"空气湿度", unit: "%", color: Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), number: 11)
                ModuleView(DataStore: DataStore, title:"大气压强", unit: "hPa", color: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), number: 0)
                ModuleView(DataStore: DataStore, title:"压力温度", unit: "°C", color: Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)), number: 1)
                ModuleView(DataStore: DataStore, title:"环境温度", unit: "°C", color: Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), number: 2)
                ModuleView(DataStore: DataStore, title:"物体温度", unit: "°C", color: Color(#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)), number: 3)
                ModuleView(DataStore: DataStore, title:"空气质量", unit: "mV", color: Color(#colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)), number: 4)
                    
                

                
                
                
                
                
                
                
            }
            .padding(.horizontal)
            .animation(.linear)
            
            .simultaneousGesture(
                DragGesture()
                    .onChanged{ value  in
                        dragState = value.translation
                        
                        print(dragState)
                        
                        if dragState.height < -5 {
                            frameHeight = screenBounds.height/4
                        } else if dragState.height > 5 {
                            frameHeight = screenBounds.height/1.3
                        }
                        
                    }
            )
            
            
        }
        .ignoresSafeArea(.all)
        
        
        
    }
    
    
    
    
    
    //    var body: some View {
    //        ScrollView(.vertical, showsIndicators: false) {
    //
    //            LazyVStack{
    //
    //                HStack{
    //                    Text("传感器数据")
    //                        .font(.system(size: 40))
    //                    Spacer()
    //                    Image(systemName: "multiply.circle.fill")
    //                        .font(.system(size: 50))
    //                        .onTapGesture {
    //                            showMonitors = false
    //                        }
    //                }
    //                .padding(.horizontal)
    //
    //
    //
    //
    ////                BarChartView(data: ChartData(values: Array(DataStore.pressurePair.dropFirst(2))), title: "气压数据")
    //
    //
    //
    //
    //                LineView(data: Array(DataStore.pressureData.dropFirst(2)), title: "气压数据", legend: "过去24小时气压数据")
    //                    .frame(height:380)
    //
    //
    //
    //                VStack {
    //
    //                    Text("空气湿度")
    //                        .font(.title)
    //                        .foregroundColor(colorScheme == .light ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)): Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
    //
    //                    CircularProgress(percentage:  CGFloat(DataStore.sensorData[11]/100),
    //                                     fontSize: 25,
    //                                     backgroundColor: colorScheme == .light ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
    //                                     fontColor : colorScheme == .light ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)): Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)),
    //                                     borderColor1: .blue,
    //                                     borderColor2: LinearGradient(gradient: Gradient(colors: [.pink, .blue]),startPoint: .top, endPoint: .bottom),
    //                                     borderWidth: 20
    //                    )
    //                    .frame(width: 200, height: 200)
    //                }
    //                .padding()
    //                .background(colorScheme == .light ? Color(#colorLiteral(red: 0.09554057568, green: 0.6370621324, blue: 0.3586583138, alpha: 1)): Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)))
    //                .cornerRadius(30)
    //
    //
    //
    //
    //
    //
    //                HStack{
    //                    BarChartView(data: ChartData(values: [("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]), title: "Sales", legend: "Quarterly")
    //
    //                    BarChartView(data: ChartData(values: [("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]), title: "Sales", legend: "Quarterly")
    //                }
    //
    //
    //                LineView(data: Array(DataStore.airData.dropFirst(2)), title: "空气污染", legend: "空气污染变化")
    //                    .frame(height:380)
    //
    //
    ////                LineChartView(data: DataStore.airData, title: "空气质量变化")
    //
    //
    //
    //                LineView(data: [527,589,480,457,600,78,], title: "海拔高度", legend: "过去24小时海拔变化")
    //                    .frame(height:380)
    //
    //                HStack {
    //                    LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "温度", legend: "温度记录")
    //                    LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "湿度", legend: "适度记录")
    //                }
    //
    //
    //            }
    //
    //        }
    //        .padding(.all)
    //
    //    }
}

struct MonitorView_Previews: PreviewProvider {
    static var previews: some View {
        MonitorView(showMonitors: .constant(false))
            .previewDevice("iPhone 8")
            .preferredColorScheme(.light)
        
    }
}

struct ModuleView: View {
    @ObservedObject var DataStore:DataStore
    var title: String
    var unit: String
    var color: Color
    var number: Int
    var body: some View {
        HStack{
            
            Text(title)
            Spacer()
            Text(String(format: "%.2f", DataStore.sensorData[number]) + unit)
            
        }
        .foregroundColor(.white)
        .font(.title)
        .padding()
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
