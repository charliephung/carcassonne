open React
open Belt
open Emotion
open Webapi

module Styles = {
  let blockOnMouse = (~x, ~y) =>
    rawCss(
      `
      position: fixed;
      pointer-events: none;
      z-index: 99999;
      top: ${Int.toString(y - 40)}px;
      left: ${Int.toString(x - 40)}px;
  `,
    )
}

@react.component
let make = (~block: option<Block.t>, ~length, ~egde) => {
  let ((x, y), setPosition) = useState(_ => (0, 0))

  useEffect1(() => {
    let handleMouseMove = e => {
      setPosition(_ => (Dom.MouseEvent.clientX(e), Dom.MouseEvent.clientY(e)))
    }
    Dom.Document.addMouseMoveEventListener(handleMouseMove, Dom.document)

    Some(
      () => {
        Dom.Document.removeMouseMoveEventListener(handleMouseMove, Dom.document)
      },
    )
  }, [block])

  switch block {
  | None => <ReactNull />
  | Some(block) =>
    <Block
      onClick={_ => ()}
      className={Styles.blockOnMouse(~x, ~y)}
      rowi=0
      columni=0
      pixel=block.pixel
      length
      egde
    />
  }
}
