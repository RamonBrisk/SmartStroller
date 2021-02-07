//
//  ControllerView.swift
//  SmartStroller
//
//  Created by 李杨 on 2021/2/6.
//

import SwiftUI

struct ControllerView: View {
    
    enum WheelDrive: String, CaseIterable, Identifiable {
        case frontdrive
        case reardrive
        case Fourwheeldrive
        var id: String { self.rawValue }
    }
    @State var isControllable = false
    @State var barState = CGSize.zero
    @State var selecteddrive = WheelDrive.Fourwheeldrive
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)).opacity(0.4), Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
            VStack {
                Image("clothes")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 375, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                HStack {
                    Spacer()
                    Image("babyTV")
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(1.5)
                        .frame(width: 50, height: 50, alignment: .center)
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
                        
                        Circle()
                            .stroke(Color(selecteddrive.rawValue == WheelDrive.Fourwheeldrive.rawValue ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : selecteddrive.rawValue == WheelDrive.frontdrive.rawValue ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)), lineWidth: 18)
                            .opacity(selecteddrive.rawValue == WheelDrive.Fourwheeldrive.rawValue ? 1 : selecteddrive.rawValue == WheelDrive.frontdrive.rawValue ? 1 : 0.1)
                            .frame(width: 30, height: 30, alignment: .center)
                            .offset(x: -43, y: 77)
                        
                        Circle()
                            .stroke(Color(selecteddrive.rawValue == WheelDrive.Fourwheeldrive.rawValue ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : selecteddrive.rawValue == WheelDrive.reardrive.rawValue ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)), lineWidth: 18)
                            .opacity(selecteddrive.rawValue == WheelDrive.Fourwheeldrive.rawValue ? 1 : selecteddrive.rawValue == WheelDrive.reardrive.rawValue ? 1 : 0.1)
                            .frame(width: 30, height: 30, alignment: .center)
                            .offset(x: 34, y: 72)
                        
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
                        
                        
                        
                        
                        Image(systemName: isControllable ? "location.circle" : "location.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100, alignment: .center)
                            .font(.system(size: 80))
                            .foregroundColor(Color(isControllable ? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)))
                            .padding()
                            .animation(.spring())
                            .offset(x: barState.width, y: barState.height)
                            .onTapGesture {
                                isControllable.toggle()
                            }
                            .gesture(DragGesture()
                                        .onChanged(){
                                            value  in
                                            self.barState = value.translation
                                            
                                        }
                                        .onEnded(){
                                            _ in
                                            
                                            barState = .zero
                                        })
                    }
                }
            }
            .padding(.bottom)
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
