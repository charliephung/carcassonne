module IntCmp = Belt.Id.MakeComparable({
  type t = int
  let cmp = (a, b) => Pervasives.compare(a, b)
})

module StringCmp = Belt.Id.MakeComparable({
  type t = string
  let cmp = (a, b) => Pervasives.compare(a, b)
})
