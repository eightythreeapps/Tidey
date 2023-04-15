//
//  StationDetailView.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 13/04/2023.
//

import SwiftUI

struct StationDetailView: View {
    
    @EnvironmentObject var viewModel:TideStationListViewModel
    var stationName:String
    var id:String?
    
    var body: some View {
        
        VStack {
            Text(stationName)
            List(viewModel.tidalEvents) { event in
                VStack(alignment: .leading) {
                    Text(event.getFormttedEventName())
                    Text(event.getFormattedDate())
                        .font(.footnote)
                }
            }
        }.onAppear {
            if let id = id {
                Task {
                    await viewModel.getEventsForStation(stationId:id)
                }
            }
        }
        
    }
}

struct StationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeStationDetailView()
    }
}
