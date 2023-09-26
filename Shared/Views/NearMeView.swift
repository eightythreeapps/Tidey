//
//  NearMeView.swift
//  Tidey
//
//  Created by Ben Reed on 21/09/2023.
//

import SwiftUI

struct NearMeView: View {
    
    @EnvironmentObject var viewModel:TideStationListViewModel
    
    var body: some View {
        Text("Near me")
            .onAppear {
                
                Task {
                    
                }
                
            }
    }
}

#Preview {
    NearMeView()
}
