open React
open Webapi

@react.component
let make = (~onRotate, ~onEnter) => {
  useEffect1(() => {
    let handleKeyPress = e => {
      switch Dom.KeyboardEvent.key(e) {
      | "r" => onRotate(e)
      | "Enter" => onEnter(e)
      | _ => ()
      }
    }

    Dom.Document.addKeyPressEventListener(handleKeyPress, Dom.document)

    Some(
      () => {
        Dom.Document.removeKeyPressEventListener(handleKeyPress, Dom.document)
      },
    )
  }, [onRotate, onEnter])

  <ReactNull />
}
