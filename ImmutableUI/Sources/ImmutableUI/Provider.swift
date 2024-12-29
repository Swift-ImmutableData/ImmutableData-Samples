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

import SwiftUI

@MainActor public struct Provider<Store, Content> where Content : View {
  private let keyPath: WritableKeyPath<EnvironmentValues, Store>
  private let store: Store
  private let content: Content
  
  public init(
    _ keyPath: WritableKeyPath<EnvironmentValues, Store>,
    _ store: Store,
    @ViewBuilder content: () -> Content
  ) {
    self.keyPath = keyPath
    self.store = store
    self.content = content()
  }
}

extension Provider : View {
  public var body: some View {
    self.content.environment(self.keyPath, self.store)
  }
}
