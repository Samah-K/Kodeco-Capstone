//
//  OnboardingView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 19/07/2024.
//

import SwiftUI

struct OnboardingView: View {
  var onboardingData = OnboardingData().data
  var body: some View {
    TabView {
      ForEach(onboardingData) { onboardingItem in
        OnboardingCardView(model: onboardingItem)
      }
    }
    .tabViewStyle(.page)
//    .padding(20)
  }
}

#Preview {
  OnboardingView()
}
