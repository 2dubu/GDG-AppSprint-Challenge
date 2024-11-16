//
//  CapsuleView.swift
//  GDG-AppSprint-Challenge
//
//  Created by 이건우 on 11/16/24.
//

import SwiftUI

struct CapsuleView: View {
    private let title: String
    private var titleColor: Color = .darkGray
    private var backgroundColor: Color = .lightGray
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.wantedSans(family: .Medium, size: 12))
            .foregroundStyle(titleColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 10).fill(backgroundColor)
            )
    }
}

#Preview {
    CapsuleView(title: "GCU • KHU")
}
