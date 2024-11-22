import UIKit

let queryDictionary: [String: String] = ["term": "Yoke Lore", "country": "US", "media": "music", "limit": "10", "entity": "musicTrack"]

let url = URL(string: "https://itunes.apple.com/search")!

var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!

urlComponents.queryItems = queryDictionary.map { URLQueryItem(name: $0.key, value: $0.value) }

Task {
  let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)

  if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
     let string = String(data: data, encoding: .utf8) {
    print(string)
  }
}

