//
//  DataController.swift
//  Vexillum
//
//  Created by Saad Anis on 06/07/2024.
//

import SwiftData

@MainActor
class DataController {
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: FlagCollection.self, configurations: config)

            for flagCollection in VexillumApp.generateFlagCollections() {
                container.mainContext.insert(flagCollection)
            }

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
