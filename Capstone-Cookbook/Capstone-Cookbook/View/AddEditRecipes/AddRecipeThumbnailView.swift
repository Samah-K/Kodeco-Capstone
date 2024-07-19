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
  var addOrEdit: AddOrEditEnum
  var body: some View {
    ZStack(alignment: .bottom) {
      if addOrEdit == .addRecipe {
        if let thumbnailURL = thumbnailURL {
          if let uiImage = UIImage(contentsOfFile: thumbnailURL) {
            Image(uiImage: uiImage)
              .resizable()
          } else {
            ImagePlaceHolderView()
          }
        } else {
          ImagePlaceHolderView()
        }
      } else {
        RecipeImage(thumbnailURL: thumbnailURL)
      }
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
            print(imageURL)
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
        recipeID: "\(String(describing: recipeID))",
        addOrEdit: .addRecipe
      )
      .environmentObject(RecipesStore())
    }
  }
  return Preview()
}
