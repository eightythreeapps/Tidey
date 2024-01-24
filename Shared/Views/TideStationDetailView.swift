//
//  TideStationDetailView.swift
//  Tidey
//
//  Created by Ben Reed on 12/01/2024.
//

import SwiftUI
import GeoJSON
import SwiftDate

struct TideStationDetailView: View {
    
    @EnvironmentObject var applicationDataModel:ApplicationDataModel
    @State var events:TidalEventDictionary = TidalEventDictionary()
    @Binding var station: TideStation?
        
    var body: some View {
        
        VStack {
            
            if let station {
                List {
                    Section {
            
                        HStack {
                            
                            RecentTideTimeView(tideTime: .last, tideType: .highWater, dateTime: "04:37")
                            
                            Divider()
                                .frame(height: 85)
                            
                            RecentTideTimeView(tideTime: .next, tideType: .lowWater, dateTime: "09:27")
                            
                        }
                        .background(.yellow)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding()
                    }
                    ForEach(events.keys.sorted(), id: \.self) { group in
                        Section {
                            
                            ForEach(events[group]!) { event in
                                HStack {
                                    Image(systemName: event.getType().iconName())
                                    VStack(alignment: .leading) {
                                        Text(event.getFormattedEventDate())
                                        Text("\(event.getEventHeight())m")
                                    }
                                }
                            }
                            
                        } header: {
                            Text("\(group)")
                        }
                        
                    }
                    
                }
                .navigationTitle(station.getStationName())
                .onChange(of: station, initial: true, { oldState, newState in
                    Task {
                        guard let stationId = station.getStationId() else { return }
                        self.events = await applicationDataModel.getEventsFor(stationId: stationId)
                    }
                })
                
            }else{
                Text("Nah")
            }
            
        }
        
    }
}

#Preview {
    NavigationView {
        TideStationDetailView(station: .constant(TideStation(feature: Feature(geometry: nil))))
            .environmentObject(ApplicationDataModel.PreviewApplicationModel())
    }
}
