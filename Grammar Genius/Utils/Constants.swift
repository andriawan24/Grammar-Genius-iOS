//
//  Constants.swift
//  Grammar Genius
//
//  Created by Naufal Fawwaz Andriawan on 27/10/24.
//

import Foundation

enum Constants {
    static func loadApiKeys() async throws {
        let request = NSBundleResourceRequest(tags: ["APIKeys"])
        try await request.beginAccessingResources()
        
        let url = Bundle.main.url(forResource: "APIKeys", withExtension: "json")!
        let data = try Data(contentsOf: url)
    
        APIKeys.storage = try JSONDecoder().decode([String: String].self, from: data)
        
        request.endAccessingResources()
    }
    
    enum APIKeys {
        static fileprivate(set) var storage = [String: String]()
        static var geminiApiKey: String { storage["GeminiAPIKey"] ?? "" }
        static var geminiUrl: String { storage["GeminiUrl"] ?? "" }
    }
}
