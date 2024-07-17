//
//  TastyNetworkService.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import Foundation

class TastyNetworkService {
  var session: URLSession

  init() {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = TastyAPI().getAPIHeader()
    self.session = URLSession(configuration: configuration)
  }

  private func connectToTastyEndPoint(urlString: String, printResult: Bool = false) async throws -> Data {
    print(urlString)

    guard let url = URL(string: urlString)
    else {
      throw NetworkError.invalidURL
    }
    let (data, response) = try await session.data(from: url)
    guard (response as? HTTPURLResponse)?.statusCode == 200
    else {
      if (response as? HTTPURLResponse)?.statusCode == 429 {
        throw NetworkError.apiPlanExceeded
      }
      if let statusCode = (response as? HTTPURLResponse)?.statusCode {
        print("`connectToTastyEndPoint`: Response - StatusCode: \(statusCode)")
      }
      throw NetworkError.invalidResponse
    }
    if printResult {
      guard let dataAsString = String(data: data, encoding: .utf8)
      else {
        throw NetworkError.invalidData
      }
      print(dataAsString)
    }
    return data
  }
  // list of recipes [search query]
  /*
  *  number of max results per request is [40]
  */
  func getListOfRecipes(from: Int = 0, size: Int = 40, searchQuery: String? = "", tags: String? = "") async throws -> Tasty {
    let urlString = "https://tasty.p.rapidapi.com/recipes/list?from=\(from)&size=\(size)&q=\(searchQuery ?? "")&tags=\(tags ?? "")"
    do {
      let data = try await connectToTastyEndPoint(urlString: urlString)
      let tasty = try JSONDecoder().decode(Tasty.self, from: data)
      return tasty
    } catch {
      throw error
    }
  }
  // Get imageDataURL
  func getImageDataURL(for recipe: TastyRecipe) async throws -> URL? {
    if recipe.imageDataURL == nil {
      let session = URLSession(configuration: .default)
      guard let url = URL(string: recipe.getRecipeImageURL())
      else {
        throw NetworkError.invalidURLForImage
      }
      let (data, response) = try await session.data(from: url)

      guard (response as? HTTPURLResponse)?.statusCode == 200
      else {
        if let statusCode = (response as? HTTPURLResponse)?.statusCode {
          print("`getImageDataURL`: Response - StatusCode: \(statusCode)")
        }
        throw NetworkError.invalidResponse
      }
      guard let imageURLData = URL(string: "data:image/jpeg;base64," + data.base64EncodedString())
      else {
        throw NetworkError.invalidURLForImage
      }
      return imageURLData
    }
    return nil
  }
}
