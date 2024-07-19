//
//  EmptyView.swift
//  Homework9-Pexels
//
//  Created by Samah Ktaifan on 20/06/2024.
//

import SwiftUI

struct SearchStateView: View {
  @Binding var searchState: SearchState
  var searchStateTitle: String {
    switch searchState {
    case .enterASearch:
      return "What Are You Craving?"
    case .noResultsFound:
      return "No Recipes were found"
    case .foundResults:
      return ""
    case .searching:
      return "Looking for recipes ..."
    case .additionalSearch:
      return ""
    case .none:
      return ""
    }
  }
  var searchStateCaption: String {
    switch searchState {
    case .enterASearch:
      return ""
    case .noResultsFound:
      return "Check the spelling or try a new result"
    case .foundResults:
      return ""
    case .searching:
      return ""
    case .additionalSearch:
      return ""
    case .none:
      return ""
    }
  }
  var body: some View {
    ZStack {
      if searchState == .searching {
        ZStack {
          VStack {
            ProgressView {
              Text("\(searchStateTitle)")
                .font(.title3.smallCaps())
            }
            .accessibilityIdentifier("ProgressView")
            .foregroundStyle(.accent)
          }
        }
      } else {
        VStack(spacing: 10) {
          Image(systemName: "magnifyingglass")
            .resizable()
            .frame(width: 40, height: 40)
            .accessibilityIdentifier("searchStateImage")
          VStack(spacing: 4) {
            Text(searchStateTitle)
              .font(.title3.smallCaps())
              .accessibilityIdentifier("searchStateTitle")
            if searchState == .noResultsFound {
              Text(searchStateCaption)
                .font(.caption)
            }
          }
        }
        .foregroundStyle(.accent)
      }
    }
    .accessibilityIdentifier("SearchStateView")
  }
}

#Preview {
  SearchStateView(searchState: .constant(.enterASearch))
}
