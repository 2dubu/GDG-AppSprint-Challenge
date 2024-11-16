//
//  SimpleButton.swift
//  GDG-AppSprint-Challenge
//
//  Created by 이건우 on 11/16/24.
//

import SwiftUI

struct SimpleButton: View {
    typealias Action = () -> Void
    
    private var text: String
    private var font: Font
    private var enable: Bool
    private var action: Action
    private var width: CGFloat
    
    init(
        text: String,
        font: Font = .wantedSans(family: .Bold, size: 14),
        enable: Bool = true,
        width: CGFloat = 130,
        action: @escaping Action
    ) {
        self.text = text
        self.font = font
        self.enable = enable
        self.width = width
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(font)
                .foregroundColor(enable ? .white : .disabledText)
                .frame(width: width, height: 43)
                .background(RoundedRectangle(cornerRadius: 12).fill(enable ? Color.primaryBlue : .disabledBG))
        }
        .disabled(!enable)
    }
}

#Preview {
    VStack(spacing: 20) {
        SimpleButton(text: "활성화 버튼") {}
        SimpleButton(text: "비활성화 버튼", enable: false) {}
    }
    .padding(.horizontal)
}
