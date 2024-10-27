//
//  GrammarGeniusApp.swift
//  Grammar Genius
//
//  Created by Naufal Fawwaz Andriawan on 22/10/24.
//

import SwiftUI

@main
struct GrammarGeniusApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    do {
                        try await Constants.loadApiKeys()
                    } catch {
                        debugPrint(error.localizedDescription)
                    }
                }
        }
    }
}
