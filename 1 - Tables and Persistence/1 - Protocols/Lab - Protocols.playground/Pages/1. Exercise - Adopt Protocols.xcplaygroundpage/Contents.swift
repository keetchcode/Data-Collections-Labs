/*:
 ## Exercise - Adopt Protocols: CustomStringConvertible, Equatable, and Comparable

 Create a `Human` class with two properties: `name` of type `String`, and `age` of type `Int`. You'll need to create a memberwise initializer for the class. Initialize two `Human` instances.
 */
import Foundation

class Human: CustomStringConvertible, Equatable, Comparable, Codable {
  var description: String {
    return "name: \(name), age: \(age)"
  }

  var name: String = ""
  var age: Int = 0

  // Comparable protocol

  static func < (lhs: Human, rhs: Human) -> Bool {
    if lhs.age == rhs.age {
      return lhs.name < rhs.name
    }
    return lhs.age < rhs.age
  }

  // Equatable protocol

  static func == (lhs: Human, rhs: Human) -> Bool {
    return lhs.name == rhs.name && lhs.name == rhs.name
  }

  init(name: String, age: Int) {
    self.name = name
    self.age = age

  }
}

let human1 = Human(name: "Wesley", age: 25)
let human2 = Human(name: "Kelly", age: 24)

//:  Make the `Human` class adopt the `CustomStringConvertible` protocol. Print both of your previously initialized `Human` objects.
print(human1)
print(human2)
//:  Make the `Human` class adopt the `Equatable` protocol. Two instances of `Human` should be considered equal if their names and ages are identical to one another. Print the result of a boolean expression evaluating whether or not your two previously initialized `Human` objects are equal to eachother (using `==`). Then print the result of a boolean expression evaluating whether or not your two previously initialized `Human` objects are not equal to eachother (using `!=`).
if human1 == human2 {
  print("These are the same people.")
}

if human1 != human2 {
  print("These are different people")
}
//:  Make the `Human` class adopt the `Comparable` protocol. Sorting should be based on age. Create another three instances of a `Human`, then create an array called `people` of type `[Human]` with all of the `Human` objects that you have initialized. Create a new array called `sortedPeople` of type `[Human]` that is the `people` array sorted by age.
let human3 = Human(name: "Bob", age: 44)
let human4 = Human(name: "Joe", age: 52)
let human5 = Human(name: "Steve", age: 61)

var groupOfHumans: [Human] = [human1, human2, human3, human4, human5]

var sortedPeople: [Human] = groupOfHumans.sorted { $0.age < $1.age }

//:  Make the `Human` class adopt the `Codable` protocol. Create a `JSONEncoder` and use it to encode as data one of the `Human` objects you have initialized. Then use that `Data` object to initialize a `String` representing the data that is stored, and print it to the console.
let encoder = JSONEncoder()

do {
  let data = try encoder.encode(human1)
  let string = String(data: data, encoding: .utf8)
  print(string!)
} catch {
  print("Error encoding human data: \(error)")
}
/*:
 page 1 of 5  |  [Next: App Exercise - Printable Workouts](@next)
 */
