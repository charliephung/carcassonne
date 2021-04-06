open Belt
open Emotion
open React

module Styles = {
  let gridBlock = (~rowi, ~columni, ~length) =>
    css({
      "height": `${Int.toString(length)}px`,
      "width": `${Int.toString(length)}px`,
      "position": "absolute",
      "top": `${Int.toString(length * rowi)}px`,
      "left": `${Int.toString(length * columni)}px`,
      "zIndex": "1",
      "boxShadow": "2px 2px 2px 2px black",
    })
}

@react.component
let make = (~onClick) => {
  let {grid, length} = useContext(GameContext.context)

  Belt.Array.range(0, grid - 1)
  ->Belt.Array.map(rowi =>
    Belt.Array.range(0, grid - 1)
    ->Belt.Array.map(columni => {
      <div
        onClick={_ => onClick(~rowi=rowi - grid / 2, ~columni=columni - grid / 2)}
        className={Styles.gridBlock(~rowi, ~columni, ~length)}
        key={Belt.Int.toString(rowi) ++ Belt.Int.toString(columni)}
      />
    })
    ->React.array
  )
  ->React.array
}
