//
//  ViewStateView.swift
//  Tidey
//
//  Created by Ben Reed on 12/01/2024.
//

import SwiftUI

struct ViewStateView: View {
    
    @Binding var state:ViewState
    
    var body: some View {
        
        if state == .loaded {
            EmptyView()
        }
        
        if state == .loadingData {
            Text("Loading")
        }
        
        if state == .error {
            Text("Oops")
        }
        
    }
}

#Preview {
    ViewStateView(state: .constant(.loaded))
}
