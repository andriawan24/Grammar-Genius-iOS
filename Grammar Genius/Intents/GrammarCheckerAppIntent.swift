//
//  GrammarCheckerAppIntent.swift
//  Grammar Genius
//
//  Created by Naufal Fawwaz Andriawan on 26/10/24.
//

import AppIntents
import SwiftUI

struct GrammarCheckerAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Check Grammar"
    static var openAppWhenRun: Bool = true
    
    @Parameter(title: "Type text to check")
    var text: String

    @MainActor
    func perform() async throws -> some IntentResult {
        let grammarChecker = GrammarChecker.shared
        grammarChecker.selectedIndex = 0
        grammarChecker.text = text
        await grammarChecker.checkAndFix()
        await UIApplication.shared.open(URL(string: "grammar-genius://")!)
        return .result()
    }
}
