include Cmp

type row<'a> = Belt.Map.t<IntCmp.t, 'a, IntCmp.identity>

type t<'a> = {row: Belt.Map.t<IntCmp.t, row<'a>, IntCmp.identity>}

let createTable = matrix => {
  let rowIndices = matrix->Belt.Map.keysToArray->Belt_SortArray.stableSortBy(compare)

  rowIndices->Belt.Array.map(rowIndex => {
    switch Belt.Map.get(matrix, rowIndex) {
    | Some(row) => {
        let data = Belt.Map.toArray(row)
        (rowIndex, data)
      }
    | None => Js.Exn.raiseError("Not found")
    }
  })
}

let getValue = (matrix, ~rowi, ~columni) => {
  switch Belt.Map.get(matrix, rowi) {
  | Some(row) =>
    switch Belt.Map.get(row, columni) {
    | Some(value) => value
    | None => None
    }
  | None => None
  }
}

let map = (matrix, fn) =>
  matrix->createTable->Belt_Array.mapWithIndex((_, (index, value)) => fn(value, index))

let forEach = (matrix, fn) =>
  matrix->createTable->Belt_Array.forEachWithIndex((_, (index, value)) => fn(value, index))

let print = matrix => matrix->createTable->Js.log

let make = (value: 'a) => {
  let matrix: Belt.Map.t<IntCmp.t, row<'a>, IntCmp.identity> = Belt.Map.make(~id=module(IntCmp))
  let row: row<'a> = Belt.Map.make(~id=module(IntCmp))->Belt.Map.set(0, value)
  Belt.Map.set(matrix, 0, row)
}

let add = (matrix, ~rowi: int, ~columni: int, ~value: 'a) => {
  switch Belt.Map.get(matrix, rowi) {
  | Some(row) => Belt.Map.set(matrix, rowi, Belt.Map.set(row, columni, value))
  | None => {
      let row: row<'a> = Belt.Map.make(~id=module(IntCmp))->Belt.Map.set(columni, value)
      Belt.Map.set(matrix, rowi, row)
    }
  }
}
