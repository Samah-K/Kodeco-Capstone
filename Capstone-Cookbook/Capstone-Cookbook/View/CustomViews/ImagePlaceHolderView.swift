//
//  ImagePlaceHolder.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 18/07/2024.
//

import SwiftUI

struct ImagePlaceHolderView: View {
  var isProgressViewPresented = false
  var body: some View {
    ZStack {
      Color.accentColor
      Image(ImagesConstants.ImagePlaceHolder)
        .resizable()
        .frame(width: 160, height: 160)
      if isProgressViewPresented {
        ProgressView()
          .tint(.highlights)
          .font(.title)
      }
    }
  }
}


#Preview {
  struct Preview: View {
    var body: some View {
      ImagePlaceHolderView()
    }
  }
  return Preview()
}
