open React
open Emotion
open Belt
include Cmp

let root = Block.select(~t=River, ~id="1")

module Styles = {
  let root = css({
    "display": "flex",
  })

  let right = css({
    "width": "800px",
    "height": "800px",
    "margin": "20px",
    "position": "relative",
    "boxShadow": "1px 1px 2px 1px black",
    "display": "flex",
  })
}

module Root = {
  @react.component
  let make = () => {
    let (matrix, setMatrix) = useState(() => Matrix.make(root))
    let {length, egde} = useContext(GameContext.context)
    let (selectedBlock, setSelectedBlock) = useState(_ => None)

    Matrix.print(matrix)

    <div className={Styles.root}>
      <Panel selectedBlock onBlockChange={block => setSelectedBlock(_ => block)} />
      <div className={Styles.right}>
        <Grid
          onClick={(~rowi, ~columni) => {
            let right = Matrix.getValue(matrix, ~columni=columni + 1, ~rowi)
            let left = Matrix.getValue(matrix, ~columni=columni - 1, ~rowi)
            let bottom = Matrix.getValue(matrix, ~columni, ~rowi=rowi + 1)
            let top = Matrix.getValue(matrix, ~columni, ~rowi=rowi - 1)

            switch selectedBlock {
            | Some(selectedBlock) =>
              switch Block.canLink(selectedBlock, ~top, ~right, ~bottom, ~left, ()) {
              | true =>
                setMatrix(m => {
                  switch top {
                  | None => ()
                  | Some(top) =>
                    let keyMap = Array.zipBy(Block.bottomEgde(top), Block.topEgde(selectedBlock), (
                      (_value1, key1),
                      (_value2, key2),
                    ) => {
                      (key1, key2)
                    }) -> Belt.Map.fromArray( ~id=module(StringCmp))
                  }

                  Matrix.add(m, ~rowi, ~columni, ~value=Some(selectedBlock))
                })
              | false => ()
              }
            | None => ()
            }
          }}
        />
        {Matrix.map(matrix, (row, rowi) =>
          Belt_Array.map(row, ((columni, block)) => {
            switch block {
            | None => <div key={Belt.Int.toString(rowi) ++ Belt.Int.toString(columni)} />
            | Some(block) =>
              <Block
                key={Js.Json.stringifyAny(block)->Belt.Option.getExn ++
                Belt.Int.toString(rowi) ++
                Belt.Int.toString(columni)}
                onClick={_ => ()}
                length
                egde
                pixel=block.pixel
                columni
                rowi
              />
            }
          })->React.array
        )->React.array}
      </div>
    </div>
  }
}

@react.component
let make = () => <GameContext> <Root /> </GameContext>
