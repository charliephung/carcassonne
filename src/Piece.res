module Piece = {
  module Styles = {
    open Emotion
    let root = css({
      "display": "flex",
      "flexDirection": "column",
      "border": "1px solid lightgray",
    })
    let field = css({
      "background": "green",
      "height": "60px",
      "width": "60px",
      "border": "1px solid lightgray",
    })
    let river = css({
      "background": "blue",
      "height": "60px",
      "width": "60px",
      "border": "1px solid lightgray",
    })
    let casstle = css({
      "background": "gray",
      "height": "60px",
      "width": "60px",
      "border": "1px solid lightgray",
    })
    let road = css({
      "background": "chocolate",
      "height": "60px",
      "width": "60px",
      "border": "1px solid lightgray",
    })
    let tower = css({
      "background": "yellow",
      "height": "60px",
      "width": "60px",
      "border": "1px solid lightgray",
    })

    let blocks = css({
      "display": "flex",
    })
  }

  open Belt
  type block = [#Field | #River | #Casstle | #Road | #Tower]
  type blocks = array<block>
  type grid = array<blocks>

  @react.component
  let make = (~data: grid, ~onTopBorderClick: grid => unit) => {
    <div className={Styles.root} onClick={_ => onTopBorderClick(data)}>
      {data
      ->Array.mapWithIndex((blocksIndex, blocks) => {
        <div key={Int.toString(blocksIndex)} className={Styles.blocks}>
          {blocks
          ->Array.mapWithIndex((blockIndex, block) =>
            switch block {
            | #Field => <div key={Int.toString(blockIndex)} className={Styles.field} />
            | #River => <div key={Int.toString(blockIndex)} className={Styles.river} />
            | #Casstle => <div key={Int.toString(blockIndex)} className={Styles.casstle} />
            | #Road => <div key={Int.toString(blockIndex)} className={Styles.road} />
            | #Tower => <div key={Int.toString(blockIndex)} className={Styles.tower} />
            }
          )
          ->ReasonReact.array}
        </div>
      })
      ->ReasonReact.array}
    </div>
  }
}
