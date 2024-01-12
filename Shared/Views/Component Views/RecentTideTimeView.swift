//
//  RecentTideTimeView.swift
//  Tidey
//
//  Created by Ben Reed on 18/10/2023.
//

import SwiftUI

struct RecentTideTimeView: View {
    
    var tideTime:TideTime
    var tideType:TideEventType
    var dateTime:String
    
    var body: some View {
        HStack {
            Image(systemName: tideType.iconName())
            VStack(alignment: .leading) {
                Text(tideTime.displayText())
                                    .font(.system(size: 14.0, weight: .bold))
                Text(dateTime)
                    .font(.system(size: 14.0))
                Text("4h 54m ago")
                    .font(.system(size: 12.0, weight: .thin).italic())
            }
        }.padding()
    }
}
