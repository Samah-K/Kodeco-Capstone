//
//  TastyNetworkService.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import Foundation

class TastyNetworkService {
  private func connectToEndPoint(urlString: String, printResult: Bool = false) async throws -> Data {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = getAPIHeader()
    let session = URLSession(configuration: configuration)
    guard let url = URL(string: urlString)
    else {
      throw NetworkError.invalidURL
    }
    let (data, response) = try await session.data(from: url)
    guard (response as? HTTPURLResponse)?.statusCode == 200
    else {
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
      let data = try await connectToEndPoint(urlString: urlString)
      let tasty = try JSONDecoder().decode(Tasty.self, from: data)
      return tasty
    } catch {
      throw error
    }
  }
  // Auto complete
  func autoComplete(prefix: String) async throws -> AutoComlete {
    let autoCompleteURLString = "https://tasty.p.rapidapi.com/recipes/auto-complete?prefix=\(prefix)"
    do {
      let data = try await connectToEndPoint(urlString: autoCompleteURLString)
      let autoComplete = try JSONDecoder().decode(AutoComlete.self, from: data)
      //        for result in autoComplete.results {
      //          print(result.display)
      //          print(result.searchValue)
      //          print(result.type)
      //          print("---")
      //        }
      return autoComplete
    } catch {
      throw error
    }
  }

  // get more info [recipe id]
  func getMoreInfo(recipeID: Int) async throws -> Recipe {
    let getMoreInfoURLString = "https://tasty.p.rapidapi.com/recipes/get-more-info?id=\(recipeID)"
    do {
      let data = try await connectToEndPoint(urlString: getMoreInfoURLString)
      let tastyRecipe = try JSONDecoder().decode(Recipe.self, from: data)
      //        print(tastyResult.name)
      return tastyRecipe
    } catch {
      throw error
    }
  }
  // list of similar recipes [recipe id]
  func listOfsimilarRecipes(recipeID: Int) async throws -> Tasty {
    let listSimilaritiesURLString = "https://tasty.p.rapidapi.com/recipes/list-similarities?recipe_id=\(recipeID)"
    do {
      let data = try await connectToEndPoint(urlString: listSimilaritiesURLString)
      let tasty = try  JSONDecoder().decode(Tasty.self, from: data)
      //        for recipe in tasty.recipes {
      //          print(recipe.name)
      //        }
      return tasty
    } catch {
      throw error
    }
  }
  // tips (comments) [receipe id]
  func tips(recipeID: Int, from: Int = 0, size: Int = 30) async throws -> Tips {
    let tipsURLString = "https://tasty.p.rapidapi.com/tips/list?from=\(from)&size=\(size)&id=\(recipeID)"
    do {
      let data = try await connectToEndPoint(urlString: tipsURLString, printResult: false)
      let tipsList = try JSONDecoder().decode(Tips.self, from: data)
      //    for tip in tips.results {
      //      print("authoName: \(tip.authoName ?? "-")")
      //      print("authorUsername: \(tip.authorUsername)")
      //      print("upvotesTotal: \(tip.upvotesTotal)")
      //      print("createdAt: \(Date(timeIntervalSince1970: TimeInterval(tip.createdAt ?? 0)))")
      //      print("updatedAt: \(Date(timeIntervalSince1970: TimeInterval(tip.updatedAt)))")
      //      print("tipBody: \(tip.tipBody)")
      //      print("-")
      //    }
      return tipsList
    } catch {
      throw error
    }
  }
  func getTagsList() async throws -> TagsList {
    let urlString = "https://tasty.p.rapidapi.com/tags/list"
    do {
      //      var tagsSet = Set<String>()
      var tagsDictionary: [String: [String]] = [:]
      let data = try await connectToEndPoint(urlString: urlString, printResult: false)
      let tagsList = try JSONDecoder().decode(TagsList.self, from: data)
      //          for tag in tagsList.results {
      //            tagsDictionary[tag.type, default: []].append(tag.name)
      //            //        print("\(tag.displayName ) | \(tag.name) | \(tag.type)")
      //          }
      // remove some value and keys
      tagsDictionary.removeValue(forKey: "cocktails")
      removeTagsInList(tagsDictionary: &tagsDictionary, key: "drinks", tagToRemove: "Cocktails")
      removeTagsInList(tagsDictionary: &tagsDictionary, key: "meats", tagToRemove: "Pork")
      removeTagsInList(tagsDictionary: &tagsDictionary, key: "dinner", tagToRemove: "Pork")
      removeTagsInList(tagsDictionary: &tagsDictionary, key: "business_tags", tagToRemove: "pork")
      return tagsList
    } catch {
      throw error
    }
  }
}
