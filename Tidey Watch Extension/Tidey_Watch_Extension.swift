//
//  Tidey_Watch_Extension.swift
//  Tidey Watch Extension
//
//  Created by Ben Reed on 21/04/2023.
//

import AppIntents

struct Tidey_Watch_Extension: AppIntent {
    static var title: LocalizedStringResource = "Tidey Watch Extension"
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
