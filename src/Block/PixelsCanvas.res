open Emotion
open Belt
open React
open Webapi

module Styles = {
  let pixel = (~ix, ~iy, ~color, ~length) =>
    css({
      "height": `${Int.toString(length / 8)}px`,
      "width": `${Int.toString(length / 8)}px`,
      "position": "absolute",
      "top": `${Int.toString(length / 8 * ix)}px`,
      "left": `${Int.toString(length / 8 * iy)}px`,
      "backgroundColor": color,
      "zIndex": 1,
    })

  let pixels = css({
    "position": "relative",
  })

  let block = (~rowi, ~columni, ~length, ~egde) =>
    css({
      "height": `${Int.toString(length)}px`,
      "width": `${Int.toString(length)}px`,
      "position": "absolute",
      "top": `${Int.toString(egde / 2 + length * rowi)}px`,
      "left": `${Int.toString(egde / 2 + length * columni)}px`,
      "boxShadow": "2px 2px 2px 2px gray",
      "zIndex": "2",
    })
}

let fillCanvas = (ctx, ~length, ~ix, ~iy, ~color) => {
  let (s, v) = Canvas.Canvas2d.reifyStyle(color)
  Canvas.Canvas2d.setFillStyle(ctx, s, v)
  Canvas.Canvas2d.fillRect(
    ctx,
    ~x=Belt.Int.toFloat(length / 8 * ix),
    ~y=Belt.Int.toFloat(length / 8 * iy),
    ~w=Belt.Int.toFloat(length / 8),
    ~h=Belt.Int.toFloat(length / 8),
  )
}

@react.component
let make = (~data, ~length) => {
  let canvasRef = React.useRef(Js.Nullable.null)
  let setCanvasRef = useCallback1(element => {
    canvasRef.current = element
  }, [])

  useEffect2(() => {
    canvasRef.current
    ->Js.Nullable.toOption
    ->Belt.Option.forEach(canvas => {
      let ctx = Canvas.CanvasElement.getContext2d(canvas)

      let _ = data->Belt.Array.forEachWithIndex((iy, row) =>
        row->Belt.Array.forEachWithIndex((ix, value) => {
          let color = switch value {
          | (0, _) => "blue"
          | (1, _) => "green"
          | (2, _) => "brown"
          | (3, _) => "yellow"
          | (4, _) => "red"
          | _ => "white"
          }

          let _ = fillCanvas(ctx, ~length, ~ix, ~iy, ~color)
        })
      )
    })

    Some(() => ())
  }, (data, length))

  <canvas
    ref={ReactDOM.Ref.callbackDomRef(setCanvasRef)}
    width={Int.toString(length)}
    height={Int.toString(length)}
  />
}
