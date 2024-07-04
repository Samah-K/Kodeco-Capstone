//
//  RecipeDetailsView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import SwiftUI

struct RecipeDetailsView: View {
  var recipe: Recipe
  var body: some View {
    VStack {
      // image
      AsyncImage(url: URL(string: recipe.getRecipeImageURL()), content: { image in
        image.resizable()
      }, placeholder: {
        ZStack {
          ProgressView()
        }
        .frame(maxHeight: 100)
      })
      .aspectRatio(contentMode: .fill)
      .frame(maxHeight: 200)
      .aspectRatio(1, contentMode: .fill)
      Spacer()
      // Recipe + rating?
      VStack {
        HStack {
          Text(recipe.name)
            .font(.title)
          Spacer()
        }
        ScrollView {
          Text(recipe.description)
            .lineLimit(2)
        }
      }.padding(.leading, 20)
      // Ingredient List
      //      DetailsSectionView(sectionTitle: "Ingredient")
      HStack {
        Text("Ingredient")
          .font(.title2)
          .padding(.leading, 20)
        Spacer()
      }
      List(recipe.sections) { content in
        ForEach(content.components) {component in
          Text(component.rawText)
        }
      }.listStyle(.plain)
      HStack {
        Text("Process")
          .font(.title2)
          .padding(.leading, 20)
        Spacer()
      }
      // Process
      List(recipe.instructions) { content in
        Text(content.displayText)
      }.listStyle(.plain)
      // Tips (comments)
    }
    .ignoresSafeArea()
  }
}

#Preview {
  RecipeDetailsView(recipe: (TastyRecipeModel().getExample()))
}

struct DetailsSectionView: View {
  @State private var isSectionOpened = false
  var sectionTitle: String
  var body: some View {
    VStack {
      HStack {
        Text(sectionTitle)
          .font(.title2)
        Spacer()
        Button(action: {
          isSectionOpened.toggle()
        }, label: {
          Image(systemName: isSectionOpened ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
        })
      }
      if isSectionOpened {
        VStack {
          HStack {
            Image(systemName: "circle.fill")
              .padding(.trailing, 20)
            Text("Example 1")
          }
          HStack {
            Image(systemName: "circle.fill")
              .padding(.trailing, 20)
            Text("Example 2")
          }
          HStack {
            Image(systemName: "circle.fill")
              .padding(.trailing, 20)
            Text("Example 3")
          }
          HStack {
            Image(systemName: "circle.fill")
              .padding(.trailing, 20)
            Text("Example 4")
          }
          HStack {
            Image(systemName: "circle.fill")
              .padding(.trailing, 20)
            Text("Example 5")
          }
        } .padding(20)
      }
    }.padding(20)
  }
}
