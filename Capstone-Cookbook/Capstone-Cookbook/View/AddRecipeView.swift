//
//  AddRecipe.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 08/07/2024.
//

import SwiftUI

struct AddRecipeView: View {
  @State private var recipeName = ""
  var body: some View {
    Form {
      Section {
        TextField("Recipe Name", text: $recipeName)
      }
    }
  }
}

#Preview {
  AddRecipeView()
}
