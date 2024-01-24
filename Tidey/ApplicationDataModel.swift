//
//  ApplicationDataModel.swift
//  Tidey
//
//  Created by Ben Reed on 24/01/2024.
//

import Foundation
import Combine

typealias TidalEventDictionary = Dictionary<String, TidalEvents>

public class ApplicationDataModel:ObservableObject {
    
    @Published var viewState:ViewState = .loadingData
    @Published var error:Error?
    @Published var tideStations:TideStations = []
    @Published var selectedStation:TideStation?
    @Published var selectedMenuItem:MenuItem? = .nearMe
    
    @Published var searchText:String = ""
    
    private var cancellables: Set<AnyCancellable> = []
    
    var searchResults:TideStations {
        if searchText.isEmpty {
            return tideStations
        }else{
            return tideStations.filter { $0.getStationName().contains(searchText)}
        }
    }
    
    private var tideDataPovider:TideDataProvider
    private var config:ApplicationConfiguration
    
    init(config:ApplicationConfiguration, tideDataProvider:TideDataProvider) {
        self.config = config
        self.tideDataPovider = tideDataProvider
    }
    
    func allTideStations() async {
        
        do {
            self.tideStations = try await tideDataPovider.getStations()
        } catch {
            self.error = error
        }
        
    }
    
    func getEventsFor(stationId:String) async -> TidalEventDictionary {
        
        do {
            
            let tideEvents = try await tideDataPovider.getTidalEvents(stationId: stationId)
        
            let events = Dictionary(grouping: tideEvents) {
                let date = Calendar.current.startOfDay(for: $0.getEventDate())
                return date.toFormat("dd MMM")
            }
            
            return events
            
        } catch {
            print(error.localizedDescription)
        }
        
        return TidalEventDictionary()
        
    }

}

extension ApplicationDataModel {
    
    public static func PreviewApplicationModel() -> ApplicationDataModel {
        return ApplicationDataModel(config: ApplicationConfiguration(apiKey: "", baseURL: ""), tideDataProvider: MockTideDataProvider())
    }
    
}
