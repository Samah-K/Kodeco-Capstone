//
//  OnboardingStartButtonView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 19/07/2024.
//

import SwiftUI

struct OnboardingStartButtonView: View {
  @AppStorage("isOnboarding")
  var isOnboarding: Bool?
  var body: some View {
    Button {
      isOnboarding = true
    } label: {
      Text("Let's Start Cooking")
        .font(.title2.smallCaps())
        .foregroundStyle(.white)
    }
    .padding(.horizontal, 26)
    .padding(.vertical, 16)
    .background(
      Capsule().strokeBorder(
        Color.white,
        lineWidth: 2.0
      )
    )
  }
}

#Preview {
  OnboardingStartButtonView()
}
