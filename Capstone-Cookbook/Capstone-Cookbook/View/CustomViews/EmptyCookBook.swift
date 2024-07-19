//
//  EmptyCookBook.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 19/07/2024.
//

import SwiftUI

struct EmptyCookBook: View {
  var body: some View {
    VStack(spacing: 30) {
      Image(ImagesConstants.EmptyCookBook)
        .resizable()
        .scaledToFit()
        .shadow(color: Color.black.opacity(0.5), radius: 10, x: -20, y: 20)
      Text(TextsConstants.emptyCookBook)
        .font(.body.smallCaps())
        .multilineTextAlignment(.center)
        .foregroundColor(.text)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
  EmptyCookBook()
}
