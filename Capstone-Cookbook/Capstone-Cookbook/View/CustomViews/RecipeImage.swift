//
//  RecipeImage.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 17/07/2024.
//

import SwiftUI

struct RecipeImage: View {
  @EnvironmentObject var recipeStore: RecipesStore
  @State var thumbnailURL: String?
  var body: some View {
    ZStack(alignment: .bottom) {
      if let thumbnailURL = thumbnailURL {
        ZStack {
          if thumbnailURL.starts(with: "https") {
            // Async Image
            AsyncImage(url: URL(string: thumbnailURL)) { phase in
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
          } else if thumbnailURL.starts(with: "/") {
            if let uiImage = UIImage(contentsOfFile: thumbnailURL) {
              Image(uiImage: uiImage)
                .resizable()
            } else {
              ImagePlaceHolderView()
            }
          } else {
            if let imagePath = recipeStore.loadImage(imageName: thumbnailURL) {
              if let uiImage = UIImage(contentsOfFile: imagePath) {
                Text(thumbnailURL)
                Image(uiImage: uiImage)
                  .resizable()
              } else {
                ImagePlaceHolderView()
              }
            } else {
              ImagePlaceHolderView()
            }
          }
        }
      } else {
        ImagePlaceHolderView()
      }
    }
  }
}

#Preview {
  struct Preview: View {
    let url = "https://img.buzzfeed.com/thumbnailer-prod-us-east-1/7041188b99254834baa326731d068eb0/One-PotVeganDinnersFBFinal.jpg"
    var body: some View {
      RecipeImage(thumbnailURL: url)
        .environmentObject(RecipesStore())
    }
  }
  return Preview()
}
