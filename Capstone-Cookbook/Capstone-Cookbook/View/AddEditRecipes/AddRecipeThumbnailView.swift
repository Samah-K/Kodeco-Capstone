//
//  AddRecipeThumbnailView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 13/07/2024.
//

import SwiftUI
import PhotosUI

struct AddRecipeThumbnailView: View {
  @EnvironmentObject var recipeStore: RecipesStore
  @State private var photo: PhotosPickerItem?
  @Binding var thumbnailURL: String?
  var recipeID: String
  var body: some View {
    ZStack(alignment: .bottom) {
//      if let thumbnailURL = thumbnailURL {
        RecipeImage(thumbnailURL: thumbnailURL)
//      }
//        ZStack {
//          if thumbnailURL.starts(with: "https") {
//            // Async Image
//            AsyncImage(url: URL(string: thumbnailURL)) { phase in
//              switch phase {
//              case .empty:
//                ImagePlaceHolderView()
//              case .success(let image):
//                image.resizable()
//              case .failure( _):
//                ZStack {
//                  ImagePlaceHolderView()
//                }
//              @unknown default:
//                ImagePlaceHolderView()
//              }
//            }
//          } else {
//            if let imagePath = recipeStore.loadImage(imageName: recipeID) {
//              if let uiImage = UIImage(contentsOfFile: imagePath) {
//                Text(thumbnailURL)
//                Image(uiImage: uiImage)
//                  .resizable()
//              } else {
//                ImagePlaceHolderView()
//              }
//            } else {
//              ImagePlaceHolderView()
//            }
//          }
//        }
//      } else {
//        ImagePlaceHolderView()
//      }
      PhotosPicker(selection: $photo, matching: .images) {
        VStack(spacing: 1) {
          Image(systemName: "photo.badge.plus")
            .font(.callout)
          Text("Select an image")
            .font(.callout)
        }
        .shadow(radius: 10)
      }
      .frame(width: 200)
      .padding(.vertical, 20)
      .background(.thinMaterial)
      .foregroundStyle(.ultraThickMaterial)
    }
    .clipShape(Circle())
    .frame(width: 200, height: 200)
    .onChange(of: photo) { _, newPhoto in
      if let newPhoto {
        thumbnailURL = nil
        Task {
          let data = await newPhoto.convertToData()
          // Save to disk
          if let data = data {
            let imageURL = try recipeStore.saveImage(imageName: "Image-\(recipeID).jpg", data: data)
              thumbnailURL = imageURL
          }
        }
      }
    }
  }
}

#Preview {
  struct Preview: View {
    private static let recipe = TastyJSONSample().getRecipeFromJSONFile()?.recipes[0]
    //    @State var thumbnailURL = nil
    //    @State var thumbnailURL: String?
    @State var thumbnailURL = Preview.recipe?.thumbnailURL
    //    @State var thumbnailURL = "\(Preview.recipe?.id)"
    //    @State var thumbnailURL = "Preview.recipe?.thumbnailURL"
    let recipeID = Preview.recipe?.id
    var body: some View {
      AddRecipeThumbnailView(
        thumbnailURL: $thumbnailURL,
        recipeID: "\(String(describing: recipeID))")
      .environmentObject(RecipesStore())
    }
  }
  return Preview()
}
