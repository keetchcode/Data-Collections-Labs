//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by Wesley Keetch on 12/15/24.
//

import Foundation

extension Data {
  func prettyPrintedJSONString() {
    guard
      let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
      let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
      let prettyJSONString = String(data: jsonData, encoding: .utf8) else {
      print("Failed to read JSON Object.")
      return
    }

    print(prettyJSONString)
  }
}

class StoreItemController {
  func fetchItems(matching query: [String: String]) async throws -> [StoreItem] {
    var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!

    urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }

    let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)

    print(response)
    print(String(data: data, encoding: .utf8)!)

    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
      throw itemsError.itemNotFound
    }

    data.prettyPrintedJSONString()

    let decoder = JSONDecoder()
    let searchResponse = try decoder.decode(SearchResponse.self, from: data)

    return searchResponse.results
  }
}
