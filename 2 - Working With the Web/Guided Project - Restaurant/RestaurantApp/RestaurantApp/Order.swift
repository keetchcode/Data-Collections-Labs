//
//  Order.swift
//  RestaurantApp
//
//  Created by Wesley Keetch on 1/4/25.
//

import Foundation

struct Order: Codable {
  var menuItems: [MenuItem]
  
  init(menuItems: [MenuItem] = []) {
    self.menuItems = menuItems
  }
}
