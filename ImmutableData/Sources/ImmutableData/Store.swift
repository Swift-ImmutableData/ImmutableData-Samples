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

@MainActor final public class Store<State, Action> : Sendable where State : Sendable, Action : Sendable {
  private let registrar = StreamRegistrar<(oldState: State, action: Action)>()
  
  private var state: State
  private let reducer: @Sendable (State, Action) throws -> State
  
  public init(
    initialState state: State,
    reducer: @escaping @Sendable (State, Action) throws -> State
  ) {
    self.state = state
    self.reducer = reducer
  }
}

extension Store : Dispatcher {
  public func dispatch(action: Action) throws {
    let oldState = self.state
    self.state = try self.reducer(self.state, action)
    self.registrar.yield((oldState: oldState, action: action))
  }
  
  public func dispatch(thunk: @Sendable (Store, Store) throws -> Void) rethrows {
    try thunk(self, self)
  }
  
  public func dispatch(thunk: @Sendable (Store, Store) async throws -> Void) async rethrows {
    try await thunk(self, self)
  }
}

extension Store : Selector {
  public func select<T>(_ selector: @Sendable (State) -> T) -> T where T : Sendable {
    selector(self.state)
  }
}

extension Store : Streamer {
  public func makeStream() -> AsyncStream<(oldState: State, action: Action)> {
    self.registrar.makeStream()
  }
}
