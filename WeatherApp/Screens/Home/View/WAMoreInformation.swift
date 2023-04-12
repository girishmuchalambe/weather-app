//
//  WAMoreInformation.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 12/04/23.
//

import SwiftUI

struct WAMoreInformation: View {
    var humidity: Int
    var visibility: Int
    var body: some View {
        VStack(alignment: .leading) {
            Text(WAConstants.Messages.MORE_INFORMATION)
                .font(.title)
                .bold()
            Divider()
                .overlay(.black)
            Text("\(WAConstants.Messages.HUMIDITY) " + "\(humidity) %")
            Text("\(WAConstants.Messages.VISIBILITY) " + "\(visibility) %")
        
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.cyan)
        .font(.title3)
    }
}

struct WAMoreInformation_Previews: PreviewProvider {
    static var previews: some View {
        WAMoreInformation(humidity: 80, visibility: 35)
    }
}
