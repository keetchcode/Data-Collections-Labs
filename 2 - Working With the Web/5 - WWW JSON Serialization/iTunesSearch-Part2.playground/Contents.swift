import UIKit
import Foundation

struct StoreItem: Codable {
  let trackName: String
  let artistName: String
  let collectionName: String
  let trackPrice: Double
  let artworkURL: URL
  let description: String

  enum CodingKeys: String, CodingKey {
    case trackName
    case artistName
    case collectionName
    case trackPrice
    case artworkURL = "artworkUrl100"
    case description
  }

  enum AdditionalKeys: String, CodingKey {
    case longDescription
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    trackName = try values.decode(String.self, forKey: .trackName)
    artistName = try values.decode(String.self, forKey: .artistName)
    collectionName = try values.decode(String.self, forKey: .collectionName)
    trackPrice = try values.decode(Double.self, forKey: .trackPrice)
    artworkURL = try values.decode(URL.self, forKey: .artworkURL)

    if let descriptionValue = try? values.decode(String.self, forKey: .description) {
      description = descriptionValue
    } else {
      let additionalValues = try decoder.container(keyedBy: AdditionalKeys.self)
      description = (try? additionalValues.decode(String.self, forKey: .longDescription)) ?? "No description available."
    }
  }
}

struct SearchResponse: Codable {
  let results: [StoreItem]
}

enum FetchError: Error, LocalizedError {
  case invalidURL
  case invalidResponse
  case decodingError

  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "The URL provided is invalid."
    case .invalidResponse:
      return "The server response was invalid."
    case .decodingError:
      return "Failed to decode the JSON response."
    }
  }
}

func fetchItems(matching query: [String: String]) async throws -> [StoreItem] {
  var urlComponents = URLComponents(string: "https://itunes.apple.com/search")
  urlComponents?.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }

  guard let url = urlComponents?.url else {
    throw FetchError.invalidURL
  }

  do {
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw FetchError.invalidResponse
    }

    let decoder = JSONDecoder()
    let searchResponse = try decoder.decode(SearchResponse.self, from: data)

    return searchResponse.results
  } catch {
    throw FetchError.decodingError
  }
}

let queryDictionary: [String: String] = [
  "term": "Yoke Lore",
  "country": "US",
  "media": "music",
  "limit": "10",
  "entity": "musicTrack"
]

Task {
  do {
    let storeItems = try await fetchItems(matching: queryDictionary)

    for item in storeItems {
      print("""
            Track: \(item.trackName)
            Artist: \(item.artistName)
            Album: \(item.collectionName)
            Price: \(item.trackPrice)
            Artwork URL: \(item.artworkURL)
            Description: \(item.description)
            """)
      print("-----------------------------------")
    }
  } catch {
    print("Error: \(error.localizedDescription)")
  }
}


