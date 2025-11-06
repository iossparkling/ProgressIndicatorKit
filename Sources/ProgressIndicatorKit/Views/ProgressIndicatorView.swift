//
//  ProgressIndicatorView.swift
//  ProgressIndicatorKit
//
//  Created by Deltrin Sam on 10/07/25.
//

import SwiftUI

public struct ProgressIndicatorView: View {
    @State private var isJumping = false
    @State private var colorIndex = 0
    @State private var currentMessageIndex = 0
    private let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
    
    private let colors: [Color] = [Color(hex: "99AABB"), Color(hex: "CCDDEE")]
    private let animationDuration: Double = 0.3
    private let circleSize: CGFloat = 12
    
    private let messageProvider: ProgressMessageProvider
    
    public init(messageProvider: ProgressMessageProvider) {
        self.messageProvider = messageProvider
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.0))
                    .frame(width: 60, height: 35)
                
                HStack(spacing: 2) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(colors[colorIndex])
                            .frame(width: circleSize, height: circleSize)
                            .offset(y: isJumping ? -10 : 0)
                            .animation(animation(for: index), value: isJumping)
                    }
                }
            }
            
            Text(messageProvider.messages[currentMessageIndex])
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .onAppear {
            startAnimation()
        }
        .onReceive(timer) { _ in
            nextMessage()
        }
    }
    
    private func startAnimation() {
        
        withAnimation {
            isJumping = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration / 2) {
            isJumping = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            colorIndex = (colorIndex + 1) % colors.count
        }
    }
    
    private func nextMessage() {
        currentMessageIndex = (currentMessageIndex + 1) % messageProvider.messages.count
        startAnimation()
    }
    
    private func animation(for index: Int) -> Animation {
        .easeInOut(duration: animationDuration)
        .repeatCount(1, autoreverses: true)
        .delay(Double(index) * 0.2)
    }
}

