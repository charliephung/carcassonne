open Webapi

include Block
include Matrix
include Piece
include Root
include CanvasElement

type assetUrl = {default: string}
let churchImageUrl: assetUrl = %raw("require('./assets/church.png')")

let root = Block.createBlock(~t=River, ~id="1")
let block2 = Block.createBlock(~t=River, ~id="2")
let block3 = Block.createBlock(~t=River, ~id="3")
let block4 = Block.createBlock(~t=River, ~id="4")
let block5 = Block.createBlock(~t=River, ~id="5")
let block6 = Block.createBlock(~t=River, ~id="6")
let block7 = Block.createBlock(~t=River, ~id="7")
let block8 = Block.createBlock(~t=River, ~id="8")
let block9 = Block.createBlock(~t=River, ~id="9")
let block10 = Block.createBlock(~t=River, ~id="10")

ReactDOMRe.renderToElementWithId(<App />, "root")

// TESTING ON CANVAS

let matrix = Matrix.make(root)
let _ = Matrix.add(matrix, ~rowi=0, ~columni=1, ~value=block2)
let _ = Matrix.add(matrix, ~rowi=0, ~columni=2, ~value=block3)
let _ = Matrix.add(matrix, ~rowi=0, ~columni=3, ~value=block4)
let _ = Matrix.add(matrix, ~rowi=1, ~columni=-1, ~value=block5)
let _ = Matrix.add(matrix, ~rowi=1, ~columni=-2, ~value=block6)
let _ = Matrix.add(matrix, ~rowi=1, ~columni=-4, ~value=block7)
let _ = Matrix.add(matrix, ~rowi=4, ~columni=-2, ~value=block8)
let _ = Matrix.add(matrix, ~rowi=4, ~columni=-4, ~value=block9)
let _ = Matrix.add(matrix, ~rowi=4, ~columni=4, ~value=block10)

let fillCanvas = (~ctx, ~egde, ~length, ~rowi, ~columni, ~ix, ~iy, ~color) => {
  let (s, v) = Canvas.Canvas2d.reifyStyle(color)
  Canvas.Canvas2d.setFillStyle(ctx, s, v)
  Canvas.Canvas2d.fillRect(
    ctx,
    ~x=Belt.Int.toFloat(egde / 2 + length * rowi + length / 8 * ix),
    ~y=Belt.Int.toFloat(egde / 2 + length * columni + length / 8 * iy),
    ~w=Belt.Int.toFloat(length / 8),
    ~h=Belt.Int.toFloat(length / 8),
  )
}

let drawOnCanvas = () =>
  switch Dom.Document.getElementById("canvas1", Dom.document) {
  | Some(canvas) => {
      let canvasEgdeLength = 800
      let length = canvasEgdeLength / 10
      let ctx = Canvas.CanvasElement.getContext2d(canvas)
      let _setCanvasWH = {
        Dom.Element.setAttribute("width", Belt.Int.toString(canvasEgdeLength + length), canvas)
        Dom.Element.setAttribute("height", Belt.Int.toString(canvasEgdeLength + length), canvas)
      }
      let _draw = Matrix.forEach(matrix, (row, rowi) =>
        Belt_Array.forEach(row, ((columni, block)) => {
          switch block {
          | None => ()
          | Some(block) =>
            block.pixel.data->Belt.Array.forEachWithIndex((ix, row) => {
              row->Belt.Array.forEachWithIndex((iy, value) => {
                let color = switch value {
                | (0, _) => "blue"
                | (1, _) => "green"
                | (2, _) => "brown"
                | (3, _) => "yellow"
                | (4, _) => "red"
                | _ => "white"
                }
                fillCanvas(~color, ~egde=canvasEgdeLength, ~ctx, ~length, ~columni, ~rowi, ~ix, ~iy)
              })
            })
          }
        })
      )
    }

  // Canvas.Canvas2d.strokeRect(
  //   ctx,
  //   ~x=Belt.Int.toFloat(canvasEgdeLength / 2 + length * columni),
  //   ~y=Belt.Int.toFloat(canvasEgdeLength / 2 + length * rowi),
  //   ~w=Belt.Int.toFloat(length),
  //   ~h=Belt.Int.toFloat(length),
  // )

  // Canvas.Canvas2d.fillRect(
  //   ctx,
  //   ~x=Belt.Int.toFloat(canvasEgdeLength / 2 + length * x + length / 8 * ix),
  //   ~y=Belt.Int.toFloat(canvasEgdeLength / 2 + length * y + length / 8 * iy),
  //   ~w=Belt.Int.toFloat(length / 8),
  //   ~h=Belt.Int.toFloat(length / 8),
  // )

  // FILL image
  // let img = Dom.HtmlImageElement.make()
  // let _ = Dom.HtmlImageElement.setSrc(img, churchImageUrl.default)
  // let _ = Dom.HtmlImageElement.setWidth(img, length)
  // let _ = Dom.HtmlImageElement.setHeight(img, length)

  // Dom.HtmlImageElement.addLoadEventListener(_ => {
  //   let _ = CanvasElement.drawImage(
  //     ctx,
  //     ~image=img,
  //     Belt.Int.toFloat(canvasEgdeLength / 2 + length * columni),
  //     Belt.Int.toFloat(canvasEgdeLength / 2 + length * rowi),
  //     Belt.Int.toFloat(length),
  //     Belt.Int.toFloat(length),
  //   )
  // }, img)

  | None => Js.log("Error")
  }
