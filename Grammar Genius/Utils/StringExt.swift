//
//  StringExt.swift
//  Grammar Genius
//
//  Created by Naufal Fawwaz Andriawan on 26/10/24.
//

import SwiftUI

extension LocalizedStringKey {

    /**
     Return localized value of thisLocalizedStringKey
     */
    public func toString(arguments: CVarArg...) -> String {
        //use reflection
        let mirror = Mirror(reflecting: self)
        
        //try to find 'key' attribute value
        let attributeLabelAndValue = mirror.children.first { (arg0) -> Bool in
            let (label, _) = arg0
            if(label == "key"){
                return true;
            }
            return false;
        }
        
        if(attributeLabelAndValue != nil) {
            //ask for localization of found key via NSLocalizedString
            return String.localizedStringWithFormat(NSLocalizedString(attributeLabelAndValue!.value as! String, comment: ""), arguments);
        }
        else {
            return "Swift LocalizedStringKey signature must have changed. @see Apple documentation."
        }
    }
}
