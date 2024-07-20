//
//  OnboardingCardView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 19/07/2024.
//

import SwiftUI

struct OnboardingCardView: View {
  var model: OnboardingModel
  @State private var isAnimating = false
  @Environment(\.verticalSizeClass)
  var verticalSizeClass
  @Environment(\.horizontalSizeClass)
  var horizontalSizeClass

  var body: some View {
    let isPortraitMode = verticalSizeClass == .regular && horizontalSizeClass == .compact
    let tagPercentage = isPortraitMode ? 0.2 : 0.1
    ZStack(alignment: .center) {
      GeometryReader { proxy in
        VStack(alignment: .center, spacing: 0) {
          Image(model.image)
            .resizable()
            .scaledToFit()
            .shadow(
              color: Color(red: 0, green: 0, blue: 0, opacity: 0.15),
              radius: 8,
              x: 6,
              y: 8)
            .padding(40)
            .scaleEffect(isAnimating ? 1.0 : 0.4)
            .frame(height: proxy.size.height * 0.5)
            .accessibilityIdentifier("OnboardingImage")

          Text(model.title)
            .font(.largeTitle.smallCaps())
            .foregroundStyle(Color.white)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .frame(maxWidth: 480)
            .frame(height: proxy.size.height * 0.2)
            .accessibilityIdentifier("OnboardingText")
          // Start button here
          OnboardingStartButtonView()
            .frame(height: proxy.size.height * tagPercentage)
            .accessibilityIdentifier("OnboardingButton")
          // Empty view, represents the tabs
          ZStack {
          }
          .frame(height: proxy.size.height * (0.1))
        }
        .frame(width: proxy.size.width, height: proxy.size.height)
      }
    }
    .onAppear {
      withAnimation(.bouncy(duration: 1.0)) {
        isAnimating = true
      }
    }
    .onDisappear {
      isAnimating = false
    }
    .frame(
      minWidth: 0,
      maxWidth: .infinity,
      minHeight: 0,
      maxHeight: .infinity)
    .background(Color.accentColor.gradient)
    .cornerRadius(20)
    .padding(.horizontal, 20)
  }
}

#Preview {
  OnboardingCardView(model: OnboardingData().data[0])
}
