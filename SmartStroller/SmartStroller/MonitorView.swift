//
//  MonitorView.swift
//  SmartStroller
//
//  Created by 李杨 on 2021/2/7.
//

import SwiftUI
import SwiftUICharts
import Progress_Bar



enum ActiveSheet {
    case humidity, pressure, pressureTemp, ambientTemp, objectTemp,airQuality
}



struct MonitorView: View {
    
    @Binding var showMonitors:Bool
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var DataStore:DataStore = myBluetooth.DataStore
    @State var dragState = CGSize.zero
    @State var frameHeight:CGFloat = screenBounds.height/1.3
    @State var showHumChart = false
    @State var showPressureChart = false
    @State var showSheet = false
    @State var activeSheet: ActiveSheet = .humidity
    
    
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.990850389, green: 0.6827646494, blue: 0.553073287, alpha: 1)), Color(#colorLiteral(red: 0.5695050359, green: 0.5243335962, blue: 0.5779031515, alpha: 1)).opacity(0.9)]), startPoint: .topLeading, endPoint: .trailing)
            
            
            
            
            ScrollView {
                
            
                    
                    
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
                    .padding(.horizontal, 40.0)
                    
                    
                    VStack {
                        Image(showHumChart ? "" : "snowsunset")
                            .resizable()
                            .scaledToFill()
                            .blur(radius: frameHeight == screenBounds.height/4 ? 3 : 0)
                            .offset(y:frameHeight == screenBounds.height/4 ? -80 : 0)
                            .animation(Animation.linear.delay(0.1))
                            .frame(width: screenBounds.width, height: frameHeight, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
                    }
                    

   
                
                
                
                VStack{
                    ModuleView(DataStore: DataStore, title:"空气湿度", unit: "%", color: Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), number: 11)
                        .onTapGesture {
                            self.showSheet = true
                            self.activeSheet = .humidity
                        }
                    ModuleView(DataStore: DataStore, title:"大气压强", unit: "hPa", color: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), number: 0)
                        .onTapGesture {
                            self.showSheet = true
                            self.activeSheet = .pressure
                        }
                    ModuleView(DataStore: DataStore, title:"压力温度", unit: "°C", color: Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)), number: 1)
                        .onTapGesture {
                            self.showSheet = true
                            self.activeSheet = .pressureTemp
                        }
                    ModuleView(DataStore: DataStore, title:"环境温度", unit: "°C", color: Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), number: 2)
                        .onTapGesture {
                            self.showSheet = true
                            self.activeSheet = .objectTemp
                        }
                    ModuleView(DataStore: DataStore, title:"物体温度", unit: "°C", color: Color(#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)), number: 3)
                        .onTapGesture {
                            self.showSheet = true
                            self.activeSheet = .objectTemp
                        }
                    ModuleView(DataStore: DataStore, title:"空气质量", unit: "mV", color: Color(#colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)), number: 4)
                        .onTapGesture {
                            self.showSheet = true
                            self.activeSheet = .airQuality
                        }
                }
                .onTapGesture {
                    showSheet.toggle()
                }
                
                
                
                
                
                
                
                
                
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
        
        //        .popover(isPresented: $showHumChart, content: {
        //            ZStack{
        //            colorScheme == .light ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        //            LazyVStack{
        //
        //                LineView(data: Array(DataStore.airData.dropFirst(2)), title: "湿度", legend: "湿度记录")
        //            }
        //            .offset(y: -200)
        //
        //        }
        //        })
        
        .sheet(isPresented: $showSheet, content: {
            switch activeSheet {
            case .humidity :
                ZStack{
                    colorScheme == .light ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                    LazyVStack{
                        
                        LineView(data: Array(Array(DataStore.humidityData.dropFirst(2)).dropFirst(
                                                Array(DataStore.humidityData.dropFirst(2)).count > 15 ? Array(DataStore.humidityData.dropFirst(2)).count - 15: 0)), title: "湿度", legend: "湿度记录")
                    }
                    .offset(y: -200)
                }
 
            case .pressure:
                ZStack{
                    colorScheme == .light ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                    LazyVStack{
                        
                        LineView(data: Array(Array(DataStore.pressureData.dropFirst(2)).dropFirst(
                                            Array(DataStore.pressureData.dropFirst(2)).count > 15 ? Array(DataStore.pressureData.dropFirst(2)).count - 15: 0)), title: "压强", legend: "大气压强记录")
                            .animation(.easeInOut)
                    }
                    .offset(y: -200)
                }
            case .pressureTemp:
                ZStack{
                    colorScheme == .light ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                    LazyVStack{
                        
                        LineView(data: Array(Array(DataStore.pressureTempData.dropFirst(2)).dropFirst(
                                                Array(DataStore.pressureTempData.dropFirst(2)).count > 15 ? Array(DataStore.pressureTempData.dropFirst(2)).count - 15: 0)), title: "温度", legend: "压强传感器温度记录")
                    }
                    .offset(y: -200)
                }
            case .ambientTemp:
                ZStack{
                colorScheme == .light ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                LazyVStack{
                    
                    LineView(data: Array(Array(DataStore.ambientData.dropFirst(2)).dropFirst(
                                            Array(DataStore.ambientData.dropFirst(2)).count > 15 ? Array(DataStore.ambientData.dropFirst(2)).count - 15: 0)), title: "温度", legend: "环境温度记录")
                }
                .offset(y: -200)
            }
            case .objectTemp:
                ZStack{
            colorScheme == .light ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            LazyVStack{
                
                LineView(data: Array(Array(DataStore.objectData.dropFirst(2)).dropFirst(
                                        Array(DataStore.objectData.dropFirst(2)).count > 15 ? Array(DataStore.objectData.dropFirst(2)).count - 15: 0)), title: "温度", legend: "物体温度记录")
            }
            .offset(y: -200)
        }
            case .airQuality:
                ZStack{
        colorScheme == .light ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        LazyVStack{
            
            LineView(data: Array(Array(DataStore.airData.dropFirst(2)).dropFirst(
                                    Array(DataStore.airData.dropFirst(2)).count > 15 ? Array(DataStore.airData.dropFirst(2)).count - 15: 0)), title: "空气", legend: "空气质量记录")
        }
        .offset(y: -200)
    }
            }
        })
           
        .ignoresSafeArea(.all)
        
        
        
    }
    
}

struct MonitorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MonitorView(showMonitors: .constant(false))
            MonitorView(showMonitors: .constant(false))
                .previewDevice("iPad (8th generation)")
        }
        
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
