//
//  ControllerView.swift
//  SmartStroller
//
//  Created by 李杨 on 2021/2/6.
//

import SwiftUI
import CoreBluetooth

struct ControllerView: View {
    
    enum WheelDrive: String, CaseIterable, Identifiable {
        case frontdrive
        case reardrive
        case Fourwheeldrive
        var id: String { self.rawValue }
    }
    @ObservedObject var centralManager = myBluetooth
    
    @Environment(\.colorScheme) var colorScheme
    @State var showMonitors = false
    @State var barState = CGSize.zero
    @State var selecteddrive = WheelDrive.Fourwheeldrive
    
    @State var commandUIsSent = false
    @State var commandDIsSent = false
    @State  var commandLIsSent = false
    @State var commandRIsSent = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)).opacity(0.4), Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                .onAppear{
                    myBluetooth.centralManager = CBCentralManager(delegate: myBluetooth, queue: nil)
                }
            VStack {
                Image("clothes")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 375, height: 100, alignment: .center)
                HStack {
                    Spacer()
                    Image("babyTV")
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(1.5)
                        .frame(width: 50, height: 50, alignment: .center)
                        .onTapGesture {
                            showMonitors = true
                        }
                }

                
                
                HStack {
                    
                    ZStack {
                        Image("stroller1")
                            .resizable()
                            .rotation3DEffect(
                                .degrees(180),
                                axis: (x: 0.0, y: 1.0, z: 0.0) )
                            .scaledToFit()
                            .colorInvert()
                            .overlay(
                                GeometryReader{ geometry in
                                        
                                Circle()
                                    .stroke(Color(selecteddrive.rawValue == WheelDrive.Fourwheeldrive.rawValue ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : selecteddrive.rawValue == WheelDrive.frontdrive.rawValue ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)), lineWidth: 18)
                                    .opacity(selecteddrive.rawValue == WheelDrive.Fourwheeldrive.rawValue ? 1 : selecteddrive.rawValue == WheelDrive.frontdrive.rawValue ? 1 : 0.1)
                                    .frame(width: geometry.size.width/8, height: geometry.size.width/8, alignment: .center)
                                    .offset(x: geometry.size.width/4.0, y: geometry.size.height/1.3)
                                    //除数加左减右，加上减下
                                
                                }
                                
                            )
                            .overlay(
                                GeometryReader{ geometry in
                                Circle()
                                    .stroke(Color(selecteddrive.rawValue == WheelDrive.Fourwheeldrive.rawValue ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : selecteddrive.rawValue == WheelDrive.reardrive.rawValue ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)), lineWidth: geometry.size.width/18)
                                    .opacity(selecteddrive.rawValue == WheelDrive.Fourwheeldrive.rawValue ? 1 : selecteddrive.rawValue == WheelDrive.reardrive.rawValue ? 1 : 0.1)
                                    .frame(width: geometry.size.width/8, height: geometry.size.width/8, alignment: .center)
                                    .offset(x: geometry.size.width/1.715, y: geometry.size.height/1.335)
                                //除数加左减右，加上减下
                                }
                                
                                
                            )

                        
                    }
                    
                    
                    Picker(selection: $selecteddrive, label: Text("WheelDrive")) {
                        
                        Text("前驱").tag(WheelDrive.frontdrive)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        Text("后驱").tag(WheelDrive.reardrive)
                            .foregroundColor(.white)
                        
                        Text("四驱").tag(WheelDrive.Fourwheeldrive)
                            .foregroundColor(.white)
                    }
                    .frame(width: 120, height: 180, alignment: .center)
                    .background(Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)).opacity(0.1))
                    .cornerRadius(30)
                    .gesture( DragGesture()
                                .onChanged{ value  in
                                    if centralManager.isControllable{
                                        switch selecteddrive {
                                        case .frontdrive :
                                            centralManager.carPeripheral.writeValue(Data([0x03]), for: centralManager.carCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
                                        case .reardrive:
                                            centralManager.carPeripheral.writeValue(Data([0x04]), for: centralManager.carCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
                                        case .Fourwheeldrive:
                                            centralManager.carPeripheral.writeValue(Data([0x05]), for: centralManager.carCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
                                        }
                                    }
                                }
                    )
                    
                    
                    
                    
                }
                .padding(.trailing)
                .background( LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)).opacity(0.7), Color(#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1))]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(50)
                
                
                ZStack {
                    
                    ZStack {
                        Image("train1")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 375, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .blur(radius: /*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                        
                        Circle()
                            .stroke(Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)), lineWidth: 10)
                            
                            .opacity(0.4)
                        Circle()
                            .foregroundColor(Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)))
                            .opacity(0.4)
                        //                            .blur(radius: 10)
                        
                        
                        
                        
                        Image(systemName: centralManager.isControllable ? "location.circle" : "location.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100, alignment: .center)
                            .font(.system(size: 80))
                            .foregroundColor(Color(centralManager.isControllable ? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)))
                            .padding()
                            .animation(.spring())
                            .offset(x: barState.width, y: barState.height)
                            .gesture(
                                DragGesture()
                                    .onChanged{ value  in
                                        barState = value.translation
                                        
                                        //                                    print(value.translation)
                                        
                                        
                                        switch value.translation.width {
                                        case 40 ... 200:
                                            print("右转\(value.translation.width)")
                                            if centralManager.isControllable, commandRIsSent == false {
                                                centralManager.carPeripheral.writeValue(Data([0xDD]), for: centralManager.carCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
                                                commandRIsSent = true
                                                commandLIsSent = false
                                            }
                                        case -200  ...  -40:
                                            print("左转\(value.translation.width)")
                                            if centralManager.isControllable, commandLIsSent == false {
                                                centralManager.carPeripheral.writeValue(Data([0xCC]), for: centralManager.carCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
                                                commandLIsSent = true
                                                commandRIsSent = false
                                            }
                                        default:
                                            print("default")
                                        }
                                        
                                        switch value.translation.height {
                                        case 40 ... 200:
                                            print("后退\(value.translation.height)")
                                            if centralManager.isControllable, commandDIsSent == false {
                                                centralManager.carPeripheral.writeValue(Data([0xBB]), for: centralManager.carCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
                                                commandDIsSent = true
                                                commandUIsSent = false
                                            }
                                        case -200  ...  -40:
                                            print("前进\(value.translation.height)")
                                            if centralManager.isControllable, commandUIsSent == false {
                                                centralManager.carPeripheral.writeValue(Data([0xAA]), for: centralManager.carCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
                                                commandUIsSent = true
                                                commandDIsSent = false
                                            }
                                            
                                        default:
                                            print("default")
                                        }
                                        
                                    }
                                    .onEnded(){_ in
                                        
                                        barState = .zero
                                        if centralManager.isControllable{
                                            //01 动力停止
                                            centralManager.carPeripheral.writeValue(Data([0x01]), for:  centralManager.carCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
                                            commandUIsSent = false
                                            commandDIsSent = false
                                            centralManager.carPeripheral.writeValue(Data([0x02]), for:  centralManager.carCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
                                            commandLIsSent = false
                                            commandRIsSent = false
                                        }
                                        
                                        
                                        
                                        
                                    }
                                
                            )
                    }
                }
            }
            .padding([.leading, .bottom, .trailing])
            .blur(radius: showMonitors ? 5 : 0 )
            
            
            
            MonitorView(showMonitors: $showMonitors)
                .background(colorScheme == .light ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                .offset(x: 0, y: showMonitors ? 0 : 1000)
                
                
            
            
            
            
            
            
            
            
            
        }
        .animation(.easeInOut)
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct ControllerView_Previews: PreviewProvider {
    static var previews: some View {
        ControllerView()
            
            
            
        
        
    }
}
