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

public protocol Dispatcher<State, Action> : Sendable {
  associatedtype State : Sendable
  associatedtype Action : Sendable
  associatedtype Dispatcher : ImmutableData.Dispatcher<Self.State, Self.Action>
  associatedtype Selector : ImmutableData.Selector<Self.State>
  
  @MainActor func dispatch(action: Action) throws
  @MainActor func dispatch(thunk: @Sendable (Self.Dispatcher, Self.Selector) throws -> Void) rethrows
  @MainActor func dispatch(thunk: @Sendable (Self.Dispatcher, Self.Selector) async throws -> Void) async rethrows
}
