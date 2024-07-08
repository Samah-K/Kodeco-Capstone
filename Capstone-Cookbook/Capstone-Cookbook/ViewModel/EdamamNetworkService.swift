//
//  EdamamNetworkService.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 07/07/2024.
//

import Foundation

class EdamamNetworkService {
  private func connectToEdamamEndPoint(ingredient: String) async throws -> Data {
    let urlString = "https://api.edamam.com/api/nutrition-data"
    guard var urlComponent = URLComponents(string: urlString) else {
      throw NetworkError.invalidURL
    }

    let edamamAPI = EdamamAPI()
    urlComponent.queryItems = [
      URLQueryItem(name: "app_id", value: edamamAPI.getAppID()),
      URLQueryItem(name: "app_key", value: edamamAPI.getAppKey()),
      URLQueryItem(name: "ingr", value: ingredient)
    ]

    guard let url = urlComponent.url else {
      throw NetworkError.invalidURL
    }

    let session = URLSession(configuration: .default)

    let (data, response) = try await session.data(from: url)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      print((String(describing: (response as? HTTPURLResponse)?.statusCode), terminator: "\n"))
      throw NetworkError.invalidResponse
    }
    return data
  }

  func getNutrientsData(for ingredient: String) {
    Task {
      do {
        let data = try await connectToEdamamEndPoint(ingredient: ingredient)
        let edamamNutrition = try JSONDecoder().decode(EdamamNutritionData.self, from: data)
        print(ingredient)
        print("totalWeight: \(edamamNutrition.totalWeight)")
        if let energy = edamamNutrition.totalNutrients.energy {
          print("energy: \(energy.quantity) \(energy.unit)")
        }
        if let fat = edamamNutrition.totalNutrients.fat {
          print("fat: \(fat.quantity) \(fat.unit)")
        }
        if let carbohydrates = edamamNutrition.totalNutrients.carbohydrates {
          print("carbohydrates: \(carbohydrates.quantity) \(carbohydrates.unit)")
        }
        if let sugar = edamamNutrition.totalNutrients.sugar {
          print("sugar: \(sugar.quantity) \(sugar.unit)")
        }
        if let protein = edamamNutrition.totalNutrients.protein {
          print("protein: \(protein.quantity) \(protein.unit)")
        }
        if let fiber = edamamNutrition.totalNutrients.fiber {
          print("fiber: \(fiber.quantity) \(fiber.unit)")
        }
        if let water = edamamNutrition.totalNutrients.water {
          print("water: \(water.quantity) \(water.unit)")
        }


        //      print("energy: \(String(describing: edamamNutrition.totalNutrients.energy?.quantity + edamamNutrition.totalNutrients.energy?.unit))")
        //      print("fat: \(String(describing: edamamNutrition.totalNutrients.fat))")
        //      print("carbohydrates: \(String(describing: edamamNutrition.totalNutrients.carbohydrates))")
        //      print("sugar: \(String(describing: edamamNutrition.totalNutrients.sugar))")
        //      print("protein: \(String(describing: edamamNutrition.totalNutrients.protein))")
        //      print("fiber: \(String(describing: edamamNutrition.totalNutrients.fiber))")
        //      print("water: \(String(describing: edamamNutrition.totalNutrients.water))")


      } catch {
        print(error)
      }
    }
  }
}
