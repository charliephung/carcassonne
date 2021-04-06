open React
open Belt
open Emotion

let data = Block.data
let blocks = Js.Dict.keys(data.river)->Array.map(id => Block.select(~t=River, ~id))

module Styles = {
  let root = rawCss(`
    display: flex;
    flex-direction: column;
    margin: 20px;
  `)

  let block = rawCss(`
    margin-bottom: 8px;
    top: auto;
    left: auto;
    cursor: pointer;
    position: relative;
  `)

  let highlighted = rawCss(`
    outline: 5px solid yellow;
  `)
}

@react.component
let make = (~selectedBlock: option<Block.t>, ~onBlockChange) => {
  let {length, egde} = useContext(GameContext.context)
  let handleClick = useCallback1((block: Block.t) => {
    onBlockChange(Some(block))
  }, [onBlockChange])
  let handleRotate = useCallback2(_ => {
    switch selectedBlock {
    | None => ()
    | Some(block) =>
      block.pixel.data
      ->Math.rotateClockwise
      ->(pixel => Block.create(~pixel, ~id=block.id))
      ->Some
      ->onBlockChange
    }
  }, (onBlockChange, selectedBlock))
  let handleEnter = useCallback2(_ => {
    onBlockChange(None)
  }, (onBlockChange, selectedBlock))

  <div className={Styles.root}>
    <BlockOnMouse length egde block=selectedBlock />
    <KeyPressHandler onRotate={handleRotate} onEnter={handleEnter} />
    {blocks
    ->Array.map(block =>
      switch block {
      | None => <div key="none" />
      | Some(block) =>
        let highlighted = Option.eq(Some(block), selectedBlock, (a, b) => {
          a.id == b.id
        })
          ? Styles.highlighted
          : ""

        <Block
          onClick={_ => handleClick(block)}
          key=block.id
          className={cx([Styles.block, highlighted])}
          rowi=0
          columni={0}
          pixel=block.pixel
          length
          egde
        />
      }
    )
    ->React.array}
  </div>
}
