//
//  MoreInformation.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import SwiftUI

struct WindInformation: View {
    var wind: Wind?
    
    var body: some View {
        VStack {
            List {
                Section (header: Text(Constanst.Messages.WIND_INFORMATION)){
                    Text("Speed: " + "\(wind?.speed ?? 0.0)")
                    Text("Degree: " + "\(wind?.deg ?? 0)")
                    Text("Gust: " + "\(wind?.gust ?? 0.0)")
                }
            }
        }
    }
    
}

struct WindInformation_Provider: PreviewProvider {
    static var previews: some View {
        WindInformation(wind: Wind(speed: 10, deg: 10, gust: 11))
    }
}
