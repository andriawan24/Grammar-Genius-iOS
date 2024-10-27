//
//  Helper.swift
//  Grammar Genius
//
//  Created by Naufal Fawwaz Andriawan on 26/10/24.
//

import Foundation

func clearMarkdown(on str: String) -> String {
    // we build markdown open and close regular expressions we ensure that they are valid
    guard let match = try? NSRegularExpression(pattern: "<[^>]+>|\\n+") else { return str }
    
    // we get the range of the string to analize, in this case the whole string
    let range = NSRange(location: 0, length: str.lengthOfBytes(using: .utf8))
    
    // we match all opening markdown
    let matches = match.matches(in: str, range: range)
    
    // we start replacing with empty strings
    return matches.reversed().reduce(into: str) { current, result in
        let range = Range(result.range, in: current)!
        current.replaceSubrange(range, with: "")
    }.replacingOccurrences(of: "&nbsp;", with: " ")
}
