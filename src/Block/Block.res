open BsUuid
open Belt

type v = (int, string)

type jsonData = {
  river: Js.Dict.t<array<array<float>>>,
  land: Js.Dict.t<array<array<float>>>,
}

type pixelType = River | Land
type pixel = {data: array<array<v>>}
type t = {
  id: string,
  pixel: pixel,
}
type grid = array<array<option<t>>>

let data: jsonData = %raw("require('../assets/data.json')")

let value = t => {
  id: t.id,
  pixel: t.pixel,
}

let trimHeadAndTail = row => Array.slice(row, ~offset=1, ~len=Array.length(row) - 2)

let rightEgde = block =>
  block.pixel.data->Array.map(row => row[Array.length(row) - 1]->Option.getExn)->trimHeadAndTail

let leftEgde = block => block.pixel.data->Array.map(row => row[0]->Option.getExn)->trimHeadAndTail

let topEgde = block => block.pixel.data[0]->Option.getExn

let bottomEgde = block => block.pixel.data[Array.length(block.pixel.data) - 1]->Option.getExn

let canLink = (
  block: t,
  ~top: option<option<t>>=?,
  ~right: option<option<t>>=?,
  ~bottom: option<option<t>>=?,
  ~left: option<option<t>>=?,
  (),
) => {
  if (
    [top, right, bottom, left]
    ->Array.map(v => Option.flatMap(v, v => v))
    ->Array.every(Option.isNone)
  ) {
    false
  } else {
    let cmp = ((ai, _), (bi, _)) => ai == bi

    let canLinkRight = switch right {
    | None => true
    | Some(None) => true
    | Some(Some(right)) => Array.eq(rightEgde(block), leftEgde(right), cmp)
    }

    let canLinkLeft = switch left {
    | None => true
    | Some(None) => true
    | Some(Some(left)) => Array.eq(leftEgde(block), rightEgde(left), cmp)
    }

    let canLinkTop = switch top {
    | None => true
    | Some(None) => true
    | Some(Some(top)) => Array.eq(topEgde(block), bottomEgde(top), cmp)
    }

    let canLinkBottom = switch bottom {
    | None => true
    | Some(None) => true
    | Some(Some(bottom)) => Array.eq(topEgde(bottom), bottomEgde(block), cmp)
    }

    [canLinkTop, canLinkRight, canLinkBottom, canLinkLeft]->Array.every(e => e == true)
  }
}

let create = (~pixel, ~id) => {
  {
    id: id,
    pixel: {data: pixel},
  }
}

let update = (t, fn) => {
  id: t.id,
  pixel: {data: t.pixel.data->Array.map(fn)},
}

let select = (~t, ~id) => {
  switch t {
  | River =>
    switch Js_dict.get(data.river, id) {
    | Some(riverPixel) => {
        let uuid = Uuid.V1.toString(Uuid.V1.create())
        Some({
          id: uuid,
          pixel: {
            data: riverPixel->Array.map(row =>
              row->Array.map(p => {
                (Float.toInt(p), Float.toString(p))
              })
            ),
          },
        })
      }
    | _ => None
    }
  | Land =>
    switch Js_dict.get(data.river, id) {
    | Some(riverPixel) => {
        let uuid = Uuid.V1.toString(Uuid.V1.create())
        Some({
          id: uuid,
          pixel: {
            data: riverPixel->Array.map(row =>
              row->Array.map(p => (Float.toInt(p), Float.toString(p)))
            ),
          },
        })
      }
    | _ => None
    }
  }
}

open Emotion

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

@react.component
let make = (~pixel, ~rowi, ~columni, ~length, ~egde, ~className: option<string>=?, ~onClick) => {
  <div
    onClick={onClick}
    key={Int.toString(rowi) ++ Int.toString(columni)}
    className={Emotion.cx([
      Styles.block(~columni, ~rowi, ~length, ~egde),
      Option.getWithDefault(className, ""),
    ])}>
    <div className={Styles.pixels}> <PixelsCanvas data=pixel.data length /> </div>
  </div>
}
