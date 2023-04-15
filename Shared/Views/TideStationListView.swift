//
//  TideStationListView.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 13/04/2023.
//

import SwiftUI
import GeoJSON
import SwiftDate

class TideStationListViewModel:ObservableObject {
    
    private var tideStationAPIService:UKTidalAPI
    
    @Published var stations:[TideStation] = [TideStation]()
    @Published var viewState:ViewState = .loading
    @Published var path:[TideStation] = [TideStation]()
    @Published var tidalEvents:[TidalEvent] = [TidalEvent]()
    
    init(tideStationAPIService: UKTidalAPI) {
        self.tideStationAPIService = tideStationAPIService
    }
    
    func loadData() async {
        do {
            self.stations = try await tideStationAPIService.getStations()
            self.viewState = .loaded
        } catch {
            self.viewState = .error
        }
    }
    
    func getEventsForStation(stationId:String) async {
        do {
            let events = try await tideStationAPIService.getTidalEvents(stationId: stationId)
            self.tidalEvents = events
        } catch {
            
        }
    }
    
    func getStationDetail(stationId:String) async {
        do {
            let station = try await tideStationAPIService.getStation(stationId: stationId)
        } catch {
            
        }
    }
    
}

struct TideStationListView: View {
    
    @EnvironmentObject var viewModel:TideStationListViewModel
    
    var body: some View {
        
        NavigationStack {
            if viewModel.viewState == .loading {
                ProgressView()
            } else{
                
                List(viewModel.stations) { station in
                    NavigationLink {
                        StationDetailView(stationName: station.getStationName(),
                                          id: station.getStationId())
                    } label: {
                        Text(station.getStationName())
                    }
                }
                .navigationTitle("Stations")
            }
        }
        .onAppear {
            Task {
                await viewModel.loadData()
            }
        }
        
    }
}


struct tideStationAPIService_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory.makeTideStationListPreview()
    }
}
