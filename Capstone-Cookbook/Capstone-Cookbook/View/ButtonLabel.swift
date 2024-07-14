//
//  ButtonLabel.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 14/07/2024.
//

import SwiftUI

struct ButtonLabel: View {
  var buttonText: String
  var padding: Double = 20.0
  var background = Color.accent
  var foregroundColor = Color.white
  var cornerRadius = 20.0
  var font = Font.title2
    var body: some View {
      Text(buttonText)
        .frame(maxWidth: .infinity)
        .font(font)
        .padding(padding)
        .background(background)
        .foregroundColor(foregroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .multilineTextAlignment(.center)
    }
}

#Preview {
  ButtonLabel(buttonText: "Example")
}
