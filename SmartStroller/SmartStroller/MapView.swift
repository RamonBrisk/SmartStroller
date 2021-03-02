//
//  MapView.swift
//  SmartStroller
//
//  Created by 李杨 on 2021/2/10.
//

import SwiftUI
import MapKit
import SwiftUICharts
import Progress_Bar


struct MapView: View {
    @Binding var showMap: Bool
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var DataStore:DataStore = myBluetooth.DataStore
    let objectAnnotation = MKPointAnnotation()
    
    var body: some View{
        
        ZStack {
            VStack {
                MapkitView()
                    .frame(width: screenBounds.width, height: screenBounds.height * 0.35)
                ZStack{
                    colorScheme == .light ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                    LazyVStack{
                        
                        
                        
                        HStack {
                            LineChartView(data: Array(Array(DataStore.distanceData.dropFirst(2)).dropFirst(
                                                        Array(DataStore.distanceData.dropFirst(2)).count > 15 ? Array(DataStore.distanceData.dropFirst(2)).count - 15: 0)), title: "障碍物距离", legend: "曲线")
                            VStack(spacing: 10) {
                                Text("可见卫星").font(.title)
                                    .foregroundColor(colorScheme == .light ? Color(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)): Color(#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)))
                                Text(String(Int(DataStore.sensorData[10])) + " 颗")
                                Spacer()
                                CircularProgress(percentage: CGFloat(DataStore.sensorData[10] / 24) ,
                                                 fontSize: 25,
                                                 backgroundColor: .white,
                                                 fontColor : .black,
                                                 borderColor1: .blue,
                                                 borderColor2: LinearGradient(gradient: Gradient(colors: [.pink, .blue]),startPoint: .top, endPoint: .bottom),
                                                 borderWidth: 20
                                )
                            }
                            .padding(.horizontal)
                            .background(Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)))
                            .frame(width: 160, height: 240, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                        }
                        
                        BarChartView(data: ChartData(points: Array(Array(DataStore.altitudeData.dropFirst(2)).dropFirst(
                                                                    Array(DataStore.altitudeData.dropFirst(2)).count > 15 ? Array(DataStore.altitudeData.dropFirst(2)).count - 15: 0))), title: "高度记录", form: ChartForm.large)
                        Spacer()
                    }
                    .padding(.horizontal)
                    //                .
                }
                
            }

            
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "multiply.circle.fill")
                        .font(.system(size: 40))
                        .onTapGesture {
                            showMap = false
                        }
                }
                .padding()
                Spacer()
            }
            .padding()
        }
        .ignoresSafeArea(.all)
        .background(colorScheme == .light ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)): Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
    }
}



struct MapkitView: UIViewRepresentable {
    
    
    @ObservedObject var DataStore:DataStore = myBluetooth.DataStore
    
    //创建一个大头针对象
    let objectAnnotation = MKPointAnnotation()
    
    
    //手动换成MKMapView
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        
        uiView.removeAnnotations(uiView.annotations)
        
        //创建一个大头针对象
        let objectAnnotation = MKPointAnnotation()
        //设置大头针的显示位置
        objectAnnotation.coordinate = CLLocation(latitude: CLLocationDegrees(DataStore.sensorData[7]),
                                                 longitude: CLLocationDegrees(DataStore.sensorData[6])).coordinate

        //设置点击大头针之后显示的标题
        objectAnnotation.title = "实时婴儿车位置"

        //设置点击大头针之后显示的描述
        objectAnnotation.subtitle = "实时婴儿车位置详细信息"
        
        uiView.addAnnotation(objectAnnotation)

        var aaa = uiView.annotations
        
        
        
        
        
    }
    
    
    //手动换成MKMapView
    func makeUIView(context: Context) -> MKMapView {
        
        let map = MKMapView()
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(DataStore.sensorData[7]), longitude: CLLocationDegrees(DataStore.sensorData[6])), span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0))
        
        map.setRegion(region, animated: true)
        
        return map
        
        
        
        
    }
    
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(showMap: .constant(true))
            .previewDevice("iPhone 8")
    }
}
