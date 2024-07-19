//
//  SpoonacularNetworkService].swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 07/07/2024.
//

import Foundation

class SpoonacularNetworkService {
  var session: URLSession

  init() {
    let configuration = URLSessionConfiguration.default
    let header = SpoonacularAPI().getAPIHeader()
    configuration.httpAdditionalHeaders = header
    self.session = URLSession(configuration: configuration)
  }

  private func connectToSpoonacularEndPoint(unitAmount: UnitAmounts) async throws -> Data {
    let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/convert"

    guard var urlComponents = URLComponents(string: urlString) else {
      throw NetworkError.invalidURL
    }
    urlComponents.queryItems = [
      URLQueryItem(name: "ingredientName", value: unitAmount.ingredient),
      URLQueryItem(name: "sourceAmount", value: "\(unitAmount.sourceAmount)"),
      URLQueryItem(name: "sourceUnit", value: unitAmount.sourceUnit),
      URLQueryItem(name: "targetUnit", value: unitAmount.targetUnit)
    ]
    guard let url = urlComponents.url else {
      throw NetworkError.invalidURL
    }

    let (data, response) = try await session.data(from: url)
    guard (response as? HTTPURLResponse)?.statusCode == 200
    else {
      print("\(String(describing: unitAmount.ingredient)) - ", terminator: "\n")
      print((String(describing: (response as? HTTPURLResponse)?.statusCode), terminator: "\n"))
      throw NetworkError.invalidResponse
    }
    return data
  }

  func covertingAmounts(ingredient: String, sourceUnit: String, sourceAmount: Double, targetUnit: String) async throws -> UnitAmounts {
    do {
      let unitAmount = UnitAmounts(
        sourceUnit: sourceUnit,
        sourceAmount: sourceAmount,
        targetUnit: targetUnit,
        targetAmount: 0,
        ingredient: ingredient
      )
      let data = try await connectToSpoonacularEndPoint(unitAmount: unitAmount)
      var convertedAmount = try JSONDecoder().decode(UnitAmounts.self, from: data)
      print("\(ingredient) - \(convertedAmount.sourceAmount)\(convertedAmount.sourceUnit) ->", terminator: "\n")
      print("\(convertedAmount.targetAmount)\(convertedAmount.targetUnit)", terminator: "\n")
      convertedAmount.ingredient = ingredient
      return convertedAmount
      //      print(ingredient)
      //      print(convertAmount.sourceUnit)
      //      print(convertAmount.sourceAmount)
      //      print(convertAmount.targetUnit)
      //      print(convertAmount.targetAmount)
    } catch {
      print(error)
      throw error
    }
  }
}
