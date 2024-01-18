//
//  TideStationDetailView.swift
//  Tidey
//
//  Created by Ben Reed on 12/01/2024.
//

import SwiftUI
import GeoJSON
import SwiftDate

struct TideStationDetailView: View, TideDataConsuming, StateRepresentableView {
    
    @State var state: ViewState = .loadingData
    var tideDataProvider: TideDataProvider
    var station: TideStation
    
    @State var events:Dictionary<String, TidalEvents> = Dictionary<String, TidalEvents>()
    @State var lastTide:TidalEvent?
    @State var nextTide:TidalEvent?
    
    var body: some View {
        
        VStack {
            
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
            
        }
        .navigationTitle(station.getStationName())
        .task {
            
            do {
                
                let tideEvents = try await tideDataProvider.getTidalEvents(stationId: station.getStationId() ?? "")
                
                self.state = .loaded
                
                events = Dictionary(grouping: tideEvents) {
                    let date = Calendar.current.startOfDay(for: $0.getEventDate())
                    return date.toFormat("dd MMM")
                }
                
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
}

#Preview {
    NavigationView {
        TideStationDetailView(tideDataProvider: MockTideDataProvider(), station: TideStation.init(feature: Feature(geometry: nil)))
    }
}
