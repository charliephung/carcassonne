module App = {
  open React
  include Block
  include Matrix

  let root = Block.createBlock(~t=River, ~id="1")
  let block2 = Block.createBlock(~t=River, ~id="2")
  let grid = 10
  let egde = 800
  let length = egde / grid

  module Styles = {
    open Css
    let root = style(list{
      width(px(800)),
      height(px(800)),
      margin(px(20)),
      position(relative),
      boxShadow(Shadow.box(~y=px(1), ~x=px(1), ~blur=px(2), ~spread=px(1), black)),
    })

    let pixel = (~rowi, ~columni, ~ix, ~iy, ~color) =>
      style(list{
        height(px(length / 8)),
        width(px(length / 8)),
        position(absolute),
        top(px(egde / 2 + length * rowi + length / 8 * ix)),
        left(px(egde / 2 + length * columni + length / 8 * iy)),
        backgroundColor(color),
        zIndex(1),
      })

    let block = (~rowi, ~columni) =>
      style(list{
        height(px(length)),
        width(px(length)),
        position(absolute),
        top(px(egde / 2 + length * rowi)),
        left(px(egde / 2 + length * columni)),
        boxShadow(Shadow.box(~y=px(2), ~x=px(2), ~blur=px(2), ~spread=px(2), gray)),
        zIndex(2),
      })

    let gridBlock = (~rowi, ~columni) =>
      style(list{
        height(px(length)),
        width(px(length)),
        position(absolute),
        top(px(length * rowi)),
        left(px(length * columni)),
        boxShadow(Shadow.box(~y=px(1), ~x=px(1), ~blur=px(2), ~spread=px(1), black)),
        zIndex(1),
      })
  }

  module Grid = {
    @react.component
    let make = (~onClick) => {
      Belt.Array.range(0, grid)
      ->Belt.Array.map(rowi =>
        Belt.Array.range(0, grid)
        ->Belt.Array.map(columni => {
          <div
            onClick={_ => onClick(~rowi=rowi - grid / 2, ~columni=columni - grid / 2)}
            className={Styles.gridBlock(~rowi, ~columni)}
            key={Belt.Int.toString(rowi) ++ Belt.Int.toString(columni)}
          />
        })
        ->React.array
      )
      ->React.array
    }
  }

  module Root = {
    @react.component
    let make = () => {
      let (matrix, setMatrix) = useState(() => Matrix.make(root))

      <div className={Styles.root}>
        <Grid
          onClick={(~rowi, ~columni) => {
            let right = Matrix.getValue(matrix, ~columni=columni + 1, ~rowi)
            let left = Matrix.getValue(matrix, ~columni=columni - 1, ~rowi)
            let bottom = Matrix.getValue(matrix, ~columni, ~rowi=rowi + 1)
            let top = Matrix.getValue(matrix, ~columni, ~rowi=rowi - 1)

            switch block2 {
            | Some(block2) =>
              switch Block.canLink(block2, ~top, ~right, ~bottom, ~left, ()) {
              | true => setMatrix(m => Matrix.add(m, ~rowi, ~columni, ~value=Some(block2)))
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
              <React.Fragment>
                <div
                  key={Belt.Int.toString(rowi) ++ Belt.Int.toString(columni)}
                  onClick={_ => {
                    ()
                  }}
                  className={Styles.block(~columni, ~rowi)}
                />
                {block.pixel.data
                ->Belt.Array.mapWithIndex((ix, row) =>
                  row
                  ->Belt.Array.mapWithIndex((iy, value) => {
                    let (strColor, color) = switch value {
                    | (0, _) => ("blue", Css.blue)
                    | (1, _) => ("green", Css.green)
                    | (2, _) => ("brown", Css.brown)
                    | (3, _) => ("yellow", Css.yellow)
                    | (4, _) => ("red", Css.red)
                    | _ => ("white", Css.white)
                    }

                    <div
                      key={Belt.Int.toString(rowi) ++
                      Belt.Int.toString(columni) ++
                      Belt.Int.toString(ix) ++
                      Belt.Int.toString(iy) ++
                      strColor}
                      className={Styles.pixel(~columni, ~ix, ~iy, ~rowi, ~color)}
                    />
                  })
                  ->React.array
                )
                ->React.array}
              </React.Fragment>
            }
          })->React.array
        )->React.array}
      </div>
    }
  }

  @react.component
  let make = () => <Root />
}
