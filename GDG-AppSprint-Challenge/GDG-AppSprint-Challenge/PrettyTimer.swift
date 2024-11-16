//
//  PrettyTimer.swift
//  GDG-AppSprint-Challenge
//
//  Created by 이건우 on 11/16/24.
//

import SwiftUI
import Combine

struct PrettyTimer: View {
    @State private var progress: Double = 1
    @State private var remainingTime: Int = 60 * 5
    @State private var formattedTime: String = "05:00"
    @State private var timer: AnyCancellable?
    @State private var isRunning: Bool = false
    
    private let initialTime: Int = 60 * 5 // 5 min
    private var lineWidth: CGFloat = 8
    private var endCircleSize: CGFloat = 18
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startTimer() {
        formattedTime = formatTime(remainingTime)
        isRunning = true
        
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            .sink { _ in
                guard remainingTime > 0 else {
                    timer?.cancel()
                    return
                }
                remainingTime -= 1
                progress = Double(remainingTime) / Double(initialTime)
                formattedTime = formatTime(remainingTime)
            }
    }
    
    private func resetTimer() {
        remainingTime = 60 * 5
        formattedTime = "05:00"
        progress = 1
        
        isRunning = false
        timer?.cancel()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                GeometryReader { geometry in
                    let radius = (geometry.size.width - 18 * 2) / 2
                    let angle = Angle(degrees: progress * 360 - 90)
                    let xOffset = cos(angle.radians) * radius
                    let yOffset = sin(angle.radians) * radius
                    
                    ZStack {
                        Circle()
                            .foregroundStyle(.semiWhite)
                        
                        Group {
                            Circle()
                                .stroke(
                                    .lightGray,
                                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                                )
                            
                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(
                                    .primaryBlue,
                                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                                )
                                .rotationEffect(Angle(degrees: -90))
                                .animation(.easeInOut(duration: 0.1), value: progress)
                        }
                        .padding(18)
                        
                        // MARK: - Step 3
                        Circle()
                            .foregroundStyle(.primaryBlue)
                            .frame(width: endCircleSize, height: endCircleSize)
                            .offset(x: xOffset, y: yOffset)
                            .animation(.easeInOut, value: progress)
                    }
                    .overlay {
                        contentBody
                    }
                }
            }
            .frame(width: 275, height: 275)
            
            Spacer().frame(height: 26)
            
            // MARK: - Buttons
            HStack(spacing: 12) {
                SimpleButton(text: "Start", enable: !isRunning) {
                    startTimer()
                }
                
                SimpleButton(text: "Reset", enable: isRunning) {
                    resetTimer()
                }
            }
        }
    }
}

extension PrettyTimer {
    private var contentBody: some View {
        VStack(spacing: 10) {
            CapsuleView(title: "GCU • KHU")
            
            Text("GDG on Campus")
                .font(.wantedSans(family: .Medium, size: 20))
                .foregroundStyle(.darkGray)
            
            Text(formattedTime)
                .font(.wantedSans(family: .SemiBold, size: 42))
                .foregroundStyle(.darkGray)
        }
    }
}

#Preview {
    PrettyTimer()
}
