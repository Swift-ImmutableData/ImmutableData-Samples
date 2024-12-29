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
import ImmutableUI
import QuakesData
import QuakesUI
import Services
import SwiftUI

//  https://github.com/swiftlang/swift-evolution/blob/main/proposals/0364-retroactive-conformance-warning.md

@main @MainActor struct QuakesApp {
  @State private var store = Store(
    initialState: QuakesState(),
    reducer: QuakesReducer.reduce
  )
  @State private var listener = Listener(
    localStore: Self.makeLocalStore(),
    remoteStore: Self.makeRemoteStore()
  )
  
  init() {
    self.listener.listen(to: self.store)
  }
}

extension QuakesApp {
  private static func makeLocalStore() -> LocalStore {
    do {
      return try LocalStore()
    } catch {
      fatalError("\(error)")
    }
  }
}

extension NetworkSession: @retroactive RemoteStoreNetworkSession {
  
}

extension QuakesApp {
  private static func makeRemoteStore() -> RemoteStore<NetworkSession<URLSession>> {
    let session = NetworkSession(urlSession: URLSession.shared)
    return RemoteStore(session: session)
  }
}

extension QuakesApp: App {
  var body: some Scene {
    WindowGroup {
      Provider(self.store) {
        Content()
      }
    }
  }
}
