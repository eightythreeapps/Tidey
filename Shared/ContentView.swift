//
//  ContentView.swift
//  Tidey Watch Watch App
//
//  Created by Ben Reed on 14/04/2023.
//

import SwiftUI
import CoreLocation
import Combine

@MainActor

struct ContentView: View {
  
    @State var selectedSection:AppSection?
    @State var selectedTideStation:TideStation?
    @State var tideListStationViewModel:TideStationListViewModel?
    
    var body: some View {
        Text("Hello")
    }

}

#Preview {
    ContentView(selectedSection: nil, selectedTideStation: nil)
}
