//
//  PhotosPickerItemExtension.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 11/07/2024.
//

import SwiftUI
import PhotosUI


extension PhotosPickerItem {
  // From SwiftUI Views Mastery by [Big Mountine Studio] - page 377
  // Load and return an image from a PhotosPickerItem
  @MainActor
  func convert() async -> Image {
    do {
      if let data = try await self.loadTransferable(type: Data.self) {
        if let uiImage = UIImage(data: data) {
          return Image(uiImage: uiImage)
        }
      }
    } catch {
      print(error.localizedDescription)
    }
    return Image(systemName: "xmark.octagon")
  }

  // Load and return a data
  @MainActor
  func convertToData() async -> Data? {
    do {
      if let data = try await self.loadTransferable(type: Data.self) {
        return data
      }
    } catch {
      print(error.localizedDescription)
    }
    return nil
  }
}
