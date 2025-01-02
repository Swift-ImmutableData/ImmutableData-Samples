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

import Foundation

public struct AnimalsState: Hashable, Sendable {
  package var categories: Categories
  package var animals: Animals
  
  package init(
    categories: Categories,
    animals: Animals
  ) {
    self.categories = categories
    self.animals = animals
  }
}

extension AnimalsState {
  public init() {
    self.init(
      categories: Categories(),
      animals: Animals()
    )
  }
}

extension AnimalsState {
  package struct Categories: Hashable, Sendable {
    package var data: Dictionary<Category.ID, Category> = [:]
    package var status: Status? = nil
    
    package init(
      data: Dictionary<Category.ID, Category> = [:],
      status: Status? = nil
    ) {
      self.data = data
      self.status = status
    }
  }
}

extension AnimalsState {
  package struct Animals: Hashable, Sendable {
    package var data: Dictionary<Animal.ID, Animal> = [:]
    package var status: Status? = nil
    package var queue: Dictionary<Animal.ID, Status> = [:]
    
    package init(
      data: Dictionary<Animal.ID, Animal> = [:],
      status: Status? = nil,
      queue: Dictionary<Animal.ID, Status> = [:]
    ) {
      self.data = data
      self.status = status
      self.queue = queue
    }
  }
}

extension AnimalsState {
  fileprivate func selectCategories() -> Dictionary<Category.ID, Category> {
    self.categories.data
  }
}

extension AnimalsState {
  public static func selectCategories() -> @Sendable (Self) -> Dictionary<Category.ID, Category> {
    { state in state.selectCategories() }
  }
}

extension AnimalsState {
  fileprivate func selectCategoriesValues(
    sort descriptor: SortDescriptor<Category>
  ) -> Array<Category> {
    self.categories.data.values.sorted(using: descriptor)
  }
}

extension AnimalsState {
  fileprivate func selectCategoriesValues(
    sort keyPath: KeyPath<Category, some Comparable> & Sendable,
    order: SortOrder = .forward
  ) -> Array<Category> {
    self.selectCategoriesValues(
      sort: SortDescriptor(
        keyPath,
        order: order
      ))
  }
}

extension AnimalsState {
  public static func selectCategoriesValues(
    sort keyPath: KeyPath<Category, some Comparable> & Sendable,
    order: SortOrder = .forward
  ) -> @Sendable (Self) -> Array<Category> {
    { state in state.selectCategoriesValues(sort: keyPath, order: order) }
  }
}

extension AnimalsState {
  fileprivate func selectCategoriesStatus() -> Status? {
    self.categories.status
  }
}

extension AnimalsState {
  public static func selectCategoriesStatus() -> @Sendable (Self) -> Status? {
    { state in state.selectCategoriesStatus() }
  }
}

extension AnimalsState {
  fileprivate func selectCategory(categoryId: Category.ID?) -> Category? {
    guard
      let categoryId = categoryId
    else {
      return nil
    }
    return self.categories.data[categoryId]
  }
}

extension AnimalsState {
  public static func selectCategory(categoryId: Category.ID?) -> @Sendable (Self) -> Category? {
    { state in state.selectCategory(categoryId: categoryId) }
  }
}

extension AnimalsState {
  fileprivate func selectCategory(animalId: Animal.ID?) -> Category? {
    guard
      let animalId = animalId,
      let animal = self.animals.data[animalId]
    else {
      return nil
    }
    return self.categories.data[animal.categoryId]
  }
}

extension AnimalsState {
  public static func selectCategory(animalId: Animal.ID?) -> @Sendable (Self) -> Category? {
    { state in state.selectCategory(animalId: animalId) }
  }
}

extension AnimalsState {
  fileprivate func selectAnimals(categoryId: Category.ID?) -> Dictionary<Animal.ID, Animal> {
    guard
      let categoryId = categoryId
    else {
      return [:]
    }
    return self.animals.data.filter { $0.value.categoryId == categoryId }
  }
}

extension AnimalsState {
  public static func selectAnimals(categoryId: Category.ID?) -> @Sendable (Self) -> Dictionary<Animal.ID, Animal> {
    { state in state.selectAnimals(categoryId: categoryId) }
  }
}

extension AnimalsState {
  fileprivate func selectAnimalsValues(categoryId: Category.ID?) -> Array<Animal> {
    guard
      let categoryId = categoryId
    else {
      return []
    }
    return self.animals.data.values.filter { $0.categoryId == categoryId }
  }
}

extension AnimalsState {
  fileprivate func selectAnimalsValues(
    categoryId: Category.ID?,
    sort descriptor: SortDescriptor<Animal>
  ) -> Array<Animal> {
    self.selectAnimalsValues(categoryId: categoryId).sorted(using: descriptor)
  }
}

extension AnimalsState {
  fileprivate func selectAnimalsValues(
    categoryId: Category.ID?,
    sort keyPath: KeyPath<Animal, some Comparable> & Sendable,
    order: SortOrder = .forward
  ) -> Array<Animal> {
    self.selectAnimalsValues(
      categoryId: categoryId,
      sort: SortDescriptor(
        keyPath,
        order: order
      ))
  }
}

extension AnimalsState {
  public static func selectAnimalsValues(
    categoryId: Category.ID?,
    sort keyPath: KeyPath<Animal, some Comparable> & Sendable,
    order: SortOrder = .forward
  ) -> @Sendable (Self) -> Array<Animal> {
    { state in state.selectAnimalsValues(
      categoryId: categoryId,
      sort: keyPath,
      order: order
    ) }
  }
}

extension AnimalsState {
  fileprivate func selectAnimalsStatus() -> Status? {
    self.animals.status
  }
}

extension AnimalsState {
  public static func selectAnimalsStatus() -> @Sendable (Self) -> Status? {
    { state in state.selectAnimalsStatus() }
  }
}

extension AnimalsState {
  fileprivate func selectAnimal(animalId: Animal.ID?) -> Animal? {
    guard
      let animalId = animalId
    else {
      return nil
    }
    return self.animals.data[animalId]
  }
}

extension AnimalsState {
  public static func selectAnimal(animalId: Animal.ID?) -> @Sendable (Self) -> Animal? {
    { state in state.selectAnimal(animalId: animalId) }
  }
}

extension AnimalsState {
  fileprivate func selectAnimalStatus(animalId: Animal.ID?) -> Status? {
    guard
      let animalId = animalId
    else {
      return nil
    }
    return self.animals.queue[animalId]
  }
}

extension AnimalsState {
  public static func selectAnimalStatus(animalId: Animal.ID?) -> @Sendable (Self) -> Status? {
    {state in state.selectAnimalStatus(animalId: animalId) }
  }
}
