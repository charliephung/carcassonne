type t = {
  grid: int,
  egde: int,
  length: int,
}

let grid = 10
let egde = 800
let length = egde / grid

let context = React.createContext({
  grid: grid,
  egde: egde,
  length: length,
})

let provider = React.Context.provider(context)

@react.component
let make = (~children) => {
  React.createElement(
    provider,
    {
      "value": {
        grid: grid,
        egde: egde,
        length: length,
      },
      "children": children,
    },
  )
}
