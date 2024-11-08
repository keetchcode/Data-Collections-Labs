/*:
 ## App Exercise - Printable Workouts

 >These exercises reinforce Swift concepts in the context of a fitness tracking app.

 The `Workout` objects you have created so far in app exercises don't show a whole lot of useful information when printed to the console. They also aren't very easy to compare or sort. Throughout these exercises, you'll make the `Workout` class below adopt certain protocols that will solve these issues.
 */
import Foundation

class Workout: CustomStringConvertible, Equatable, Comparable, Codable {

  var description: String {
    return "Workout \(identifier): \(distance) km in \(time) minutes."
  }

  var distance: Double
  var time: Double
  var identifier: Int

  static func < (lhs: Workout, rhs: Workout) -> Bool {
    return lhs.identifier < rhs.identifier
  }

  static func == (lhs: Workout, rhs: Workout) -> Bool {
    return lhs.identifier == rhs.identifier
  }

  init(distance: Double, time: Double, identifier: Int) {
    self.distance = distance
    self.time = time
    self.identifier = identifier
  }
}

//:  Make the `Workout` class above conform to the `CustomStringConvertible` protocol so that printing an instance of `Workout` will provide useful information in the console. Create an instance of `Workout`, give it an identifier of 1, and print it to the console.
let workout1 = Workout(distance: 22.3, time: 10.3, identifier: 1)
print(workout1)
let workout2 = Workout(distance: 24.5, time: 12.7, identifier: 2)
print(workout2)
let workout3 = Workout(distance: 19.8, time: 11.4, identifier: 1)
print(workout3)
//:  Make the `Workout` class above conform to the `Equatable` protocol. Two `Workout` objects should be considered equal if they have the same identifier. Create another instance of `Workout`, giving it an identifier of 2, and print a boolean expression that evaluates to whether or not it is equal to the first `Workout` instance you created.
print(workout1 == workout2)
print(workout1 == workout3)

/*:
 Make the `Workout` class above conform to the `Comparable` protocol so that you can easily sort multiple instances of `Workout`. `Workout` objects should be sorted based on their identifier.

 Create three more `Workout` objects, giving them identifiers of 3, 4, and 5, respectively. Then create an array called `workouts` of type `[Workout]` and assign it an array literal with all five `Workout` objects you have created. Place these objects in the array out of order. Then create another array called `sortedWorkouts` of type `[Workout]` that is the `workouts` array sorted by identifier.
 */
let workout4 = Workout(distance: 22.3, time: 10.3, identifier: 4)
let workout5 = Workout(distance: 15.8, time: 8.20, identifier: 5)
let workout6 = Workout(distance: 17.4, time: 9.99, identifier: 6)

let groupOfWorkouts: [Workout] = [workout1, workout2, workout3, workout4, workout5, workout6]

let sortedWorkouts: [Workout] = groupOfWorkouts.sorted(by: <)

//:  Make `Workout` adopt the `Codable` protocol so you can easily encode `Workout` objects as data that can be stored between app launches. Use a `JSONEncoder` to encode one of your `Workout` instances. Then use the encoded data to initialize a `String`, and print it to the console.
let encoder = JSONEncoder()

if let workoutData = try? encoder.encode(groupOfWorkouts),
let workoutString = String(data: workoutData, encoding: .utf8) {
  print(workoutString)
}
/*:
 [Previous](@previous)  |  page 2 of 5  |  [Next: Exercise - Create a Protocol](@next)
 */
