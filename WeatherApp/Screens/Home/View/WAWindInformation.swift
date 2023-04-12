//
//  MoreInformation.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import SwiftUI

struct WAWindInformation: View {
    var wind: Wind?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(WAConstants.Messages.WIND_INFORMATION)
                .font(.title)
                .bold()
            Divider()
                .overlay(.black)
            Text("Speed: " + "\(wind?.speed ?? 0.0)")
            Text("Degree: " + "\(wind?.deg ?? 0)")
            Text("Gust: " + "\(wind?.gust ?? 0.0)")
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.cyan)
        .font(.title3)
    }
}

struct WindInformation_Provider: PreviewProvider {
    static var previews: some View {
        WAWindInformation(wind: Wind(speed: 10, deg: 10, gust: 11))
    }
}
