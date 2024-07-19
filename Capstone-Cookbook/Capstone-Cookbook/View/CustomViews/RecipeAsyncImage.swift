//
//  RecipeAsyncImage.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 18/07/2024.
//

import SwiftUI

struct RecipeAsyncImage: View {
  @State var thumbnailURL: URL?
  var body: some View {
    if let thumbnailURL = thumbnailURL {
      AsyncImage(url: thumbnailURL) { phase in
        switch phase {
        case .empty:
          ImagePlaceHolderView()
        case .success(let image):
          image.resizable()
        case .failure(let error):
          ZStack {
            // To silent the warning
            Text(error.localizedDescription)
              .foregroundStyle(.white.opacity(0))
            ImagePlaceHolderView()
          }
        @unknown default:
          ImagePlaceHolderView()
        }
      }
    } else {
      ImagePlaceHolderView(isProgressViewPresented: true)
    }
  }
}

#Preview {
  struct Preview: View {
    let urlString = "https://img.buzzfeed.com/thumbnailer-prod-us-east-1/2b422cd19f6c488fbe649da9739b5542/fb.jpg"
    var body: some View {
      if let url = URL(string: urlString) {
        RecipeAsyncImage(thumbnailURL: url)
      }
    }
  }
  return Preview()
}
