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

import ImmutableData
import SwiftUI

//  https://github.com/apple/swift-evolution/blob/main/proposals/0423-dynamic-actor-isolation.md

public struct DependencySelector<State, Dependency> {
  let select: @Sendable (State) -> Dependency
  let didChange: @Sendable (Dependency, Dependency) -> Bool
  
  public init(
    select: @escaping @Sendable (State) -> Dependency,
    didChange: @escaping @Sendable (Dependency, Dependency) -> Bool
  ) {
    self.select = select
    self.didChange = didChange
  }
}

public struct OutputSelector<State, Output> {
  let select: @Sendable (State) -> Output
  let didChange: @Sendable (Output, Output) -> Bool
  
  public init(
    select: @escaping @Sendable (State) -> Output,
    didChange: @escaping @Sendable (Output, Output) -> Bool
  ) {
    self.select = select
    self.didChange = didChange
  }
}

@MainActor @propertyWrapper public struct Selector<Store, each Dependency, Output> where Store : ImmutableData.Selector, Store : ImmutableData.Streamer, Store : AnyObject, repeat each Dependency : Sendable, Output : Sendable {
  @Environment private var store: Store
  @State private var listener: Listener<Store.State, Store.Action, repeat each Dependency, Output>
  
  private let id: AnyHashable?
  private let label: String?
  private let filter: (@Sendable (Store.State, Store.Action) -> Bool)?
  private let dependencySelector: (repeat DependencySelector<Store.State, each Dependency>)
  private let outputSelector: OutputSelector<Store.State, Output>
  
  public init(
    _ keyPath: WritableKeyPath<EnvironmentValues, Store>,
    id: some Hashable,
    label: String? = nil,
    filter isIncluded: (@Sendable (Store.State, Store.Action) -> Bool)? = nil,
    dependencySelector: repeat DependencySelector<Store.State, each Dependency>,
    outputSelector: OutputSelector<Store.State, Output>
  ) {
    self._store = Environment(keyPath)
    self.listener = Listener(
      id: id,
      label: label,
      filter: isIncluded,
      dependencySelector: repeat each dependencySelector,
      outputSelector: outputSelector
    )
    self.id = AnyHashable(id)
    self.label = label
    self.filter = isIncluded
    self.dependencySelector = (repeat each dependencySelector)
    self.outputSelector = outputSelector
  }
  
  public init(
    _ keyPath: WritableKeyPath<EnvironmentValues, Store>,
    label: String? = nil,
    filter isIncluded: (@Sendable (Store.State, Store.Action) -> Bool)? = nil,
    dependencySelector: repeat DependencySelector<Store.State, each Dependency>,
    outputSelector: OutputSelector<Store.State, Output>
  ) {
    self._store = Environment(keyPath)
    self.listener = Listener(
      label: label,
      filter: isIncluded,
      dependencySelector: repeat each dependencySelector,
      outputSelector: outputSelector
    )
    self.id = nil
    self.label = label
    self.filter = isIncluded
    self.dependencySelector = (repeat each dependencySelector)
    self.outputSelector = outputSelector
  }
  
  public var wrappedValue: Output {
    self.listener.output
  }
}

extension Selector: @preconcurrency DynamicProperty {
  public mutating func update() {
    if let id = self.id {
      self.listener.update(
        id: id,
        label: self.label,
        filter: self.filter,
        dependencySelector: repeat each self.dependencySelector,
        outputSelector: self.outputSelector
      )
    } else {
      self.listener.update(
        label: self.label,
        filter: self.filter,
        dependencySelector: repeat each self.dependencySelector,
        outputSelector: self.outputSelector
      )
    }
    self.listener.listen(to: self.store)
  }
}
