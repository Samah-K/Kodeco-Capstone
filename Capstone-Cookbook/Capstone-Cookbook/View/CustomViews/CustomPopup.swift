//
//  CustomPopup.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 15/07/2024.
//

import SwiftUI

struct CustomPopup: View {
  @Binding var isPopPresented: Bool // passing value should be false
  @State var popupAnimation = false // passing value should be false
  var popText: String
  var body: some View {
    ZStack {
      Color.black
        .opacity(0.6)
        .ignoresSafeArea()
        .onTapGesture {
          popupAnimation.toggle()
          DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            isPopPresented = false
          }
        }
      VStack {
        ZStack {
          Circle()
            .fill(.accent)
            .frame(width: 40, height: 40)
            .shadow(radius: 10)
          Image(systemName: "fork.knife")
            .foregroundStyle(.white)
        }
        .padding(.top, 20)
        ScrollView {
          Text(popText)
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 20)
        }
      }
      .background(.white)
      .clipShape(RoundedRectangle(cornerRadius: 25.0))
      .frame(maxWidth: 350, maxHeight: 400)
      .shadow(radius: 20)
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
        popupAnimation.toggle()
      }
    }
    .opacity(popupAnimation ? 1 : 0)
    .animation(.easeInOut(duration: 0.25), value: popupAnimation)
  }
}

#Preview {
  struct Preview: View {
    @State private var isPopPresented = true
    var body: some View {
      CustomPopup(
        isPopPresented: $isPopPresented,
        popText: TextsConstants().measurementHowTo)
    }
  }
  return Preview()
}
