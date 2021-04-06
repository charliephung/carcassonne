module Styles = {
  open Emotion
  let root = rawCss(`
    display: none
  `)
}

@react.component
let make = () => {
  <div className={Styles.root} />
}
