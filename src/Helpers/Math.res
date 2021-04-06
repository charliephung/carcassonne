// Only use for square matrix
let rotateClockwise = (matrix: array<array<'a>>) =>
  matrix->Belt.Array.mapWithIndex((rowi, row) =>
    row->Belt.Array.mapWithIndex((columni, _) =>
      Belt.Array.getExn(matrix, columni)->Belt.Array.getExn(Belt.Array.length(row) - 1 - rowi)
    )
  )

// Only use for square matrix
let rotateCounterClockwise = (matrix: array<array<'a>>) =>
  matrix->Belt.Array.mapWithIndex((rowi, row) =>
    row->Belt.Array.mapWithIndex((columni, _) =>
      Belt.Array.getExn(matrix, columni)->Belt.Array.getExn(Belt.Array.length(row) - 1 - rowi)
    )
  )
