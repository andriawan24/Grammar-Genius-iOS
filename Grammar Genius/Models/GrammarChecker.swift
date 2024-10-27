//
//  GrammarChecker.swift
//  Grammar Genius
//
//  Created by Naufal Fawwaz Andriawan on 22/10/24.
//

import SwiftUI
import Alamofire

struct GrammarResponse: Codable {
    let candidates: [Candidates]
    
    struct Candidates: Codable {
        let content: Content
    }
    
    struct Content: Codable {
        let parts: [TextParts]
    }
    
    struct TextParts: Codable {
        let text: String
    }
}

struct GrammarCheckerBody: Codable {
    let contents: [GrammarResponse.Content]
}

@MainActor
class GrammarChecker: ObservableObject {
    
    static let shared = GrammarChecker()
    
    @Published var text: String = ""
    @Published var result: LocalizedStringKey? = nil
    @Published var isLoading: Bool = false
    @Published var selectedIndex: Int = 0 {
        didSet {
            result = nil
        }
    }
    
    func checkAndFix() async {
        isLoading = true
        
        let textChecker = """
            Act like you're a great english teacher who focuses in grammar, your job is to check whether the grammar of the text is
            correct or not based on this text right here: \(text)
        
            Only provide whether this text is grammarly correct or not and give the detail of incorrect words with
            explanation and recommendation, make sure the checking structure is like this one
        
            "You're grammar is 40% correct \n\nHere is what you can do to improve your sentence \n1. Make sure you use are instead of is because
            are usually mark plural things" etc.
        
            Answer without any other context, just like that example.
        """
        
        let textFixer = """
            Act like you're a great english teacher who focuses in grammar, your job is to fix the grammar of the text based on this text 
            right here: \(text)
            Only provide the right text as an answer without any other context or explanation.
        """
        
        let body = GrammarCheckerBody(
            contents: [
                GrammarResponse.Content(
                    parts: [
                        GrammarResponse.TextParts(text: selectedIndex == 0 ? textChecker : textFixer)
                    ]
                )
            ]
        )
        
        let apiKey = Constants.APIKeys.geminiApiKey
        let url = "\(Constants.APIKeys.geminiUrl)?key=\(apiKey)"
        let result = await AF.request(
            url,
            method: .post,
            parameters: body,
            encoder: JSONParameterEncoder.json(),
            headers: HTTPHeaders(["Content-Type": "application/json"])
        )
        .cacheResponse(using: .doNotCache)
        .validate()
        .serializingDecodable(GrammarResponse.self)
        .result
        
        isLoading = false
        
        switch result {
        case .success(let grammar):
            self.result = LocalizedStringKey(grammar.candidates.first?.content.parts.first?.text ?? "")
        case .failure(let error):
            print(error)
        }
    }
}
