//
//  LocatingUserView.swift
//  Tidey
//
//  Created by Ben Reed on 04/05/2023.
//

import SwiftUI
import CoreLocation
import Combine

@MainActor
public class LocatingUserViewModel:ObservableObject {
    
    @Published var locationStatus:LocationProviderState = .determiningAuthorisation
    var locationProvider:LocationDataProvider
    
    private var cancellables:Set<AnyCancellable> = Set<AnyCancellable>()
    
    public init(locationProvider:LocationDataProvider) {
        self.locationProvider = locationProvider
    }
    
    public func getLocationProviderState() async {
        for try await state in await locationProvider.getState() {
            locationStatus = state
        }
    }
}

struct LocatingUserView: View {
    
    @StateObject var viewModel:LocatingUserViewModel
    
    var body: some View {
        
        VStack {
            
            switch viewModel.locationStatus {
            case .authorised(status:_):
                ProgressView("Finding your closest station")
            case .denied(status: let status):
                if status == .denied {
                    Text("Access to location data is denied, please check your settings.")
                } else {
                    Text("Access to location data has been restricted on this device.")
                }
            case .determiningAuthorisation:
                ProgressView {
                    Text("Accessing location")
                }
            case .error:
                Text("Error determining location")
            case .determiningUserLocation:
                Text("Fining your location")
            case .locationUpdated(location: let location):
                Text("Found you: Lat:\(location.coordinate.latitude) lon:\(location.coordinate.longitude)")
            }
            
        }.task {
            Task {
                await viewModel.getLocationProviderState()
            }
        }
        
        
    }
}

struct LocatingUserView_Previews: PreviewProvider {
    static var previews: some View {
        LocatingUserView(viewModel: LocatingUserViewModel(locationProvider: LocationService(locationManager: CLLocationManager())))
    }
}
