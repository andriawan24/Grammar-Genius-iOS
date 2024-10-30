//
//  ShortcutProvider.swift
//  Grammar Genius
//
//  Created by Naufal Fawwaz Andriawan on 26/10/24.
//

import AppIntents

struct GrammarCheckShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: GrammarCheckerAppIntent(),
            phrases: [
                "Check my grammar on \(.applicationName)",
                "Check my grammar"
            ],
            shortTitle: "Grammar Check",
            systemImageName: "magnifyingglass"
        )
    }
}
