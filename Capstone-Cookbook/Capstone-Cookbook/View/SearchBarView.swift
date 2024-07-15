//
//  SearchBarView.swift
//  Homework9-Pexels
//
//  Created by Samah Ktaifan on 19/06/2024.
//

import SwiftUI

struct SearchBarView: View {
  @Binding var searchQuery: String
  @Binding var resetSearchPressed: Bool
  var body: some View {
    HStack(spacing: 0) {
      Image(systemName: "magnifyingglass")
        .resizable()
        .foregroundStyle(.accent)
        .frame(width: 20, height: 20)
        .padding(.leading, 10)
      TextField("Search A Recipe...", text: $searchQuery)
        .autocorrectionDisabled()
        .frame(maxWidth: 240, maxHeight: 50)
        .padding(.horizontal, 10)
        .submitLabel(.search)
        .accessibilityIdentifier("searchTextField")
      Button {
        searchQuery = ""
        resetSearchPressed = true
      } label: {
        Text("X")
      }
      .padding(.trailing, 15)
      .foregroundStyle(.accent)
    }
    .overlay {
      RoundedRectangle(cornerRadius: 20)
        .fill(.clear)
        .stroke(.accent, lineWidth: 2)
    }
  }
}

#Preview {
  SearchBarView(
    searchQuery: .constant("Add"),
    resetSearchPressed: .constant(false))
}
