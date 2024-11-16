//
//  Font+Extension.swift
//  GDG-AppSprint-Challenge
//
//  Created by 이건우 on 11/16/24.
//

import SwiftUI

extension Font {
    enum FontFamily: String {
        case Regular = "Regular"
        case Medium = "Medium"
        case SemiBold = "SemiBold"
        case Bold = "Bold"
    }
    
    static func wantedSans(family: FontFamily, size: CGFloat) -> Font {
        return Font(UIFont(name: "WantedSans-\(family.rawValue)", size: size)!)
    }
}
