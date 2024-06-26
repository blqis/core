// Copyright 2024 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Creates an `Option` containing a value if the given condition is true, otherwise returns `None`.
///
/// # Arguments
///
/// * `condition`: A boolean value indicating whether the option should contain a value.
/// * `value`: A function that returns the value to be contained in the option.
///
/// # Returns
///
/// An `Option` containing the value if the condition is true, otherwise `None`.
///
/// # Example
///
/// ```
/// let result = when(true, fn(){ "Hello, World!" })
/// debug(result) //output: Some("Hello, World!"
/// ```
pub fn when[T](condition : Bool, value : () -> T) -> Option[T] {
  if condition {
    Some(value())
  } else {
    None
  }
}

test "when" {
  let result = when(true, fn() { "Hello, World!" })
  let result2 = when(false, fn() { "Hello, World!" })
  @assertion.assert_eq(result, Some("Hello, World!"))?
  @assertion.assert_eq(result2, None)?
}

/// The `unless` function returns an `Option` value based on a condition.
///
/// `unless(condition, value)` is equivalent to `when(not(condition), value)`.
///
/// # Arguments
///
/// * `condition`: A boolean value indicating whether the condition is true or false.
/// * `value`: A function that returns a value of type `T`.
///
/// # Returns
///
/// An `Option` value that is `Some(value())` if the condition is false, otherwise `None`.
///
pub fn unless[T](condition : Bool, value : () -> T) -> Option[T] {
  when(condition.not(), value)
}

test "unless" {
  let result = unless(true, fn() { "Hello, World!" })
  let result2 = unless(false, fn() { "Hello, World!" })
  @assertion.assert_eq(result, None)?
  @assertion.assert_eq(result2, Some("Hello, World!"))?
}

/// Creates an empty `Option` of type `T`.
pub fn empty[T]() -> Option[T] {
  None
}

test "empty" {
  let x : Option[Int] = None
  let y : Option[Int] = empty()
  @assertion.assert_eq(x, y)?
}

/// Creates an `Option` that contains a value.
pub fn some[T](value : T) -> Option[T] {
  Some(value)
}

test "some" {
  let x : Option[Int] = Some(5)
  let y : Option[Int] = some(5)
  @assertion.assert_eq(x, y)?
}

/// Maps the value of an `Option` using a provided function.
///
/// # Example
///
/// ```
/// let a = Some(5)
/// debug(a.map(fn(x){ x * 2 })) //output: Some(10)
///
/// let b = None
/// debug(b.map(fn(x){ x * 2 })) //output: None
/// ```
pub fn map[T, U](self : Option[T], f : (T) -> U) -> Option[U] {
  Some(f(self?))
}

test "map" {
  let a = Option::Some(5)
  let b : Option[Int] = None
  @assertion.assert_eq(a.map(fn(x) { x * 2 }), Some(10))?
  @assertion.assert_eq(b.map(fn(x) { x * 2 }), None)?
}

/// Binds an option to a function that returns another option.
///
/// # Example
///
/// ```
/// let a = Option::Some(5)
/// let r1 = a.bind(fn(x){ Some(x * 2) })
/// debug(r1) //output: Some(10)
///
/// let b : Option[Int] = None
/// let r2 = b.bind(fn(x){ Some(x * 2) })
/// debug(r2) //output: None
/// ```
pub fn bind[T, U](self : Option[T], f : (T) -> Option[U]) -> Option[U] {
  f(self?)
}

test "bind" {
  let a = Option::Some(5)
  let b : Option[Int] = None
  @assertion.assert_eq(a.bind(fn(x) { Some(x * 2) }), Some(10))?
  @assertion.assert_eq(b.bind(fn(x) { Some(x * 2) }), None)?
}

/// Flattens an `Option` of `Option` into a single `Option`.
///
/// If the input `Option` is `Some(Some(value))`, the function returns `Some(value)`.
///
/// # Example
///
/// ```
/// let a = Some(Some(42));
/// debug(flatten(a)) //output: Some(42)
/// let b = Some(None)
/// debug(flatten(b)) //output: None
/// ```
pub fn flatten[T](self : Option[Option[T]]) -> Option[T] {
  self?
}

test "flatten" {
  let a : Option[Option[Int]] = Some(Some(42))
  @assertion.assert_eq(flatten(a), Some(42))?
  let b : Option[Option[Int]] = Some(None)
  @assertion.assert_eq(flatten(b), None)?
}

/// Checks if the option is empty.
pub fn is_empty[T](self : Option[T]) -> Bool {
  match self {
    None => true
    _ => false
  }
}

test "is_empty" {
  let x = Option::Some(3)
  let y : Option[Int] = None
  @assertion.assert_false(x.is_empty())?
  @assertion.assert_true(y.is_empty())?
}

/// Filters the option by applying the given predicate function `f`.
///
/// If the predicate function `f` returns `true` for the value contained in the option,
/// the same option is returned. Otherwise, `None` is returned.
///
/// # Example
/// ```
/// let x = Some(3)
/// debug(x.filter(fn(x){ x > 5 })) //output: None
/// debug(x.filter(fn(x){ x < 5 })) //output: Some(3)
/// ```
pub fn filter[T](self : Option[T], f : (T) -> Bool) -> Option[T] {
  if f(self?) {
    self
  } else {
    None
  }
}

test "filter" {
  let x = Option::Some(3)
  @assertion.assert_eq(x.filter(fn(x) { x > 5 }), None)?
  @assertion.assert_eq(x.filter(fn(x) { x < 5 }), Some(3))?
}

/// Return the contained `Some` value or the provided default.
pub fn or[T](self : Option[T], default : T) -> T {
  match self {
    None => default
    Some(t) => t
  }
}

test "or" {
  let x = Option::Some(3)
  @assertion.assert_eq(x.or(5), 3)?
  @assertion.assert_eq((None : Option[Int]).or(5), 5)?
}

/// Return the contained `Some` value or the provided default.
///
/// Default is lazily evaluated
pub fn or_else[T](self : Option[T], default : () -> T) -> T {
  match self {
    None => default()
    Some(t) => t
  }
}

test "or else" {
  let x = Option::Some(3)
  @assertion.assert_eq(x.or_else(fn() { 5 }), 3)?
  @assertion.assert_eq((None : Option[Int]).or_else(fn() { 5 }), 5)?
}

pub fn compare[X : Compare](self : Option[X], other : Option[X]) -> Int {
  match self {
    None =>
      match other {
        None => 0
        Some(_) => -1
      }
    Some(x) =>
      match other {
        None => 1
        Some(y) => x.compare(y)
      }
  }
}

test "compare" {
  let some1 = Option::Some(1)
  let some2 = Option::Some(2)
  let none = Option::None
  @assertion.assert_eq(0, some1.compare(Option::Some(1)))?
  @assertion.assert_eq(-1, some1.compare(some2))?
  @assertion.assert_eq(1, some2.compare(some1))?
  @assertion.assert_eq(0, none.compare(none))?
  @assertion.assert_eq(-1, none.compare(some1))?
  @assertion.assert_eq(1, some2.compare(none))?
}

/// Extract the value in `Some`.
/// Panic if input is `None`.
pub fn unwrap[X](self : Option[X]) -> X {
  match self {
    None => abort("called `Option::unwrap()` on a `None` value")
    Some(x) => x
  }
}

/// `None`
pub fn Option::default[X]() -> Option[X] {
  None
}
