//
//  BundleExt.swift
//  Grammar Genius
//
//  Created by Naufal Fawwaz Andriawan on 22/10/24.
//

import Foundation

extension Bundle {
    class var applicationName: String {
        if let displayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            return displayName
        } else if let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return bundleName
        }
        return "No Application Name"
    }
}
