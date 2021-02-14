//
//  MapView.swift
//  SmartStroller
//
//  Created by 李杨 on 2021/2/10.
//

import SwiftUI
import MapKit


struct MapView: View {
    @Binding var showMap: Bool

    var body: some View{
        
        ZStack {
            VStack {
                MapkitView()
                    .frame(width: screenBounds.width, height: screenBounds.height * 0.5)
                    .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                
                Spacer()
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
        
        .background(Color(#colorLiteral(red: 1, green: 0.8894598995, blue: 0.6746887569, alpha: 1)))
    }
}



struct MapkitView: UIViewRepresentable {
    
//    let location = CLLocationCoordinate2D(latitude: 31.094547, longitude: 104.42346)
    
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 31.094454, longitude: 104.37935), latitudinalMeters: .leastNormalMagnitude, longitudinalMeters: .leastNormalMagnitude)
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> some UIView {
        
        
        let map = MKMapView()
        map.showsUserLocation = true
        map.setRegion(region, animated: true)
        map.addAnnotation(map.userLocation)
        
        return map
        
        
        
        
    }

    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(showMap: .constant(true))
    }
}
