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
    
    private let totalMinutes = 5
    private let circlePadding: CGFloat = 18
    private let strokeWidth: CGFloat = 8
    private let endCircleDiameter: CGFloat = 18

    private var initialTime: Int {
        return totalMinutes * 60
    }
    
    /// "MM:SS" 형식으로 format
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    /// 타이머 시작
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
    
    /// 타이머 초기화
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
                    let radius = (geometry.size.width - 18 * 2) / 2 // 원의 반지름 계산
                    let angle = Angle(degrees: progress * 360 - 90)
                    
                    // ProgressBar의 끝 점의 위치를 계산
                    // xOffset: 원 중심으로부터 x축으로 떨어진 거리
                    // yOffset: 원 중심으로부터 y축으로 떨어진 거리
                    let xOffset = cos(angle.radians) * radius
                    let yOffset = sin(angle.radians) * radius
                    
                    ZStack {
                        Circle()
                            .foregroundStyle(.semiWhite)
                        
                        Group {
                            Circle()
                                .stroke(
                                    .lightGray,
                                    style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                                )
                            
                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(
                                    .primaryBlue,
                                    style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                                )
                                .rotationEffect(Angle(degrees: -90))
                                .animation(.easeInOut(duration: 0.1), value: progress)
                        }
                        .padding(18)
                        
                        // MARK: - Step 3 (도전과제!)
                        Circle()
                            .foregroundStyle(.primaryBlue)
                            .frame(width: endCircleDiameter, height: endCircleDiameter)
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
        .onDisappear {
            timer?.cancel()
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
