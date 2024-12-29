//
//  Copyright 2024 Rick van Voorden and Bill Fisher
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

public struct Animal: Hashable, Sendable {
  public let animalId: String
  public let name: String
  public let diet: Diet
  public let categoryId: String
  
  package init(
    animalId: String,
    name: String,
    diet: Diet,
    categoryId: String
  ) {
    self.animalId = animalId
    self.name = name
    self.diet = diet
    self.categoryId = categoryId
  }
}

extension Animal {
  public enum Diet: String, CaseIterable, Hashable, Sendable {
    case herbivorous = "Herbivore"
    case carnivorous = "Carnivore"
    case omnivorous = "Omnivore"
  }
}

extension Animal: Identifiable {
  public var id: String {
    self.animalId
  }
}

extension Animal {
  public static var dog: Self {
    Self(
      animalId: "Dog",
      name: "Dog",
      diet: .carnivorous,
      categoryId: "Mammal"
    )
  }
  public static var cat: Self {
    Self(
      animalId: "Cat",
      name: "Cat",
      diet: .carnivorous,
      categoryId: "Mammal"
    )
  }
  public static var kangaroo: Self {
    Self(
      animalId: "Kangaroo",
      name: "Red kangaroo",
      diet: .herbivorous,
      categoryId: "Mammal"
    )
  }
  public static var gibbon: Self {
    Self(
      animalId: "Bibbon",
      name: "Southern gibbon",
      diet: .herbivorous,
      categoryId: "Mammal"
    )
  }
  public static var sparrow: Self {
    Self(
      animalId: "Sparrow",
      name: "House sparrow",
      diet: .omnivorous,
      categoryId: "Bird"
    )
  }
  public static var newt: Self {
    Self(
      animalId: "Newt",
      name: "Newt",
      diet: .carnivorous,
      categoryId: "Amphibian"
    )
  }
}
