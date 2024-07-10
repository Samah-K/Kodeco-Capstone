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
      return "Enter something to search"
    case .noResultsFound:
      return "No Results"
    case .foundResults:
      return ""
    case .searching:
      return "Searching ....."
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
              Text("Searching...")
            }
            .foregroundStyle(.accent)
          }
        }
      } else {
        VStack(spacing: 10) {
          Image(systemName: "magnifyingglass")
            .resizable()
            .frame(width: 40, height: 40)
          VStack(spacing: 4) {
            Text(searchStateTitle)
              .font(.title3)
            if searchState == .noResultsFound {
              Text(searchStateCaption)
                .font(.caption)
            }
          }
        }
        .foregroundStyle(.accent)
      }
    }
  }
}

#Preview {
  SearchStateView(searchState: .constant(.enterASearch))
}
