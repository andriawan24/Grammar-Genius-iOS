//
//  ShortcutProvider.swift
//  Grammar Genius
//
//  Created by Naufal Fawwaz Andriawan on 26/10/24.
//

import AppIntents

struct GrammarCheckShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] = [
        AppShortcut(
            intent: GrammarCheckerAppIntent(),
            phrases: [
                "Check my grammar on \(.applicationName)",
                "Check my grammar"
            ],
            shortTitle: "Check Grammar",
            systemImageName: "magnifyingglass"
        ),
        AppShortcut(
            intent: GrammarCheckerAppIntent(),
            phrases: [
                "Fix my grammar on \(.applicationName)",
                "Fix my grammar"
            ],
            shortTitle: "Fix Grammar",
            systemImageName: "gear"
        )
    ]
}
