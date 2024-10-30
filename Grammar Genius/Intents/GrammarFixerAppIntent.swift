//
//  GrammarFixerAppIntent.swift
//  Grammar Genius
//
//  Created by Naufal Fawwaz Andriawan on 30/10/24.
//

import SwiftUI
import AppIntents

struct GrammarFixerAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Fix Grammar"
    static var openAppWhenRun: Bool = true
    
    @Parameter(title: "Type text to check")
    var text: String

    @MainActor
    func perform() async throws -> some IntentResult {
        let grammarChecker = GrammarChecker.shared
        grammarChecker.selectedIndex = 1
        grammarChecker.text = text
        await grammarChecker.checkAndFix()
        await UIApplication.shared.open(URL(string: "grammar-genius://")!)
        return .result()
    }
}
