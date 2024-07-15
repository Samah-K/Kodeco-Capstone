//
//  BackNavigationButton.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 15/07/2024.
//

import SwiftUI

struct BackNavigationButton: View {
  var body: some View {
    HStack {
      Image(systemName: "chevron.left")
      Text("Back")
    }
  }
}

#Preview {
  BackNavigationButton()
}
