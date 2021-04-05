module Block = {
  open BsUuid

  type v = (int, string)

  type jsonData = {
    river: Js.Dict.t<array<array<int>>>,
    land: Js.Dict.t<array<array<int>>>,
  }

  type pixelType = River | Land
  type pixel = {data: array<array<v>>}
  type t = {
    id: string,
    pixel: pixel,
  }
  type grid = array<array<option<t>>>

  let data: jsonData = %raw("require('./assets/data.json')")

  let value = t => {
    id: t.id,
    pixel: t.pixel,
  }

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
      ->Belt.Array.map(v => Belt.Option.flatMap(v, v => v))
      ->Belt.Array.every(Belt.Option.isNone)
    ) {
      false
    } else {
      let cmpOptions = (a, b) => Belt.Option.eq(a, b, ((ai, _), (bi, _)) => ai == bi)
      let cmp = ((ai, _), (bi, _)) => ai == bi

      let trimHeadAndTail = row => Belt.Array.slice(row, ~offset=1, ~len=Belt.Array.length(row) - 2)

      let canLinkRight = switch right {
      | None => true
      | Some(None) => true
      | Some(Some(right)) => {
          let blockRightEgde =
            block.pixel.data
            ->Belt.Array.map(row => Belt.Array.get(row, Belt.Array.length(row) - 1))
            ->trimHeadAndTail

          let rightblockLeftEgde =
            right.pixel.data->Belt.Array.map(row => Belt.Array.get(row, 0))->trimHeadAndTail

          Belt.Array.eq(blockRightEgde, rightblockLeftEgde, cmpOptions)
        }
      }

      let canLinkLeft = switch left {
      | None => true
      | Some(None) => true
      | Some(Some(left)) => {
          let blockEgdeLeft =
            block.pixel.data->Belt.Array.map(row => Belt.Array.get(row, 0))->trimHeadAndTail

          let leftblockRightEgde =
            left.pixel.data
            ->Belt.Array.map(row => Belt.Array.get(row, Belt.Array.length(row) - 1))
            ->trimHeadAndTail

          Belt.Array.eq(blockEgdeLeft, leftblockRightEgde, cmpOptions)
        }
      }

      let canLinkTop = switch top {
      | None => true
      | Some(None) => true
      | Some(Some(top)) =>
        switch (
          Belt.Array.get(block.pixel.data, 0),
          Belt.Array.get(top.pixel.data, Belt.Array.length(top.pixel.data) - 1),
        ) {
        | (Some(blockTopEgde), Some(topBlockBottomEgde)) =>
          Belt.Array.eq(blockTopEgde->trimHeadAndTail, topBlockBottomEgde->trimHeadAndTail, cmp)
        | _ => false
        }
      }

      let canLinkBottom = switch top {
      | None => true
      | Some(None) => true
      | Some(Some(bottom)) =>
        switch (
          Belt.Array.get(block.pixel.data, Belt.Array.length(bottom.pixel.data) - 1),
          Belt.Array.get(bottom.pixel.data, 0),
        ) {
        | (Some(blockBottomEgde), Some(topBlockBottomEgde)) =>
          Belt.Array.eq(blockBottomEgde->trimHeadAndTail, topBlockBottomEgde->trimHeadAndTail, cmp)
        | _ => false
        }
      }

      [canLinkBottom, canLinkLeft, canLinkRight, canLinkTop]->Belt.Array.every(e => e == true)
    }
  }

  let createBlock = (~t, ~id) => {
    switch t {
    | River =>
      switch Js_dict.get(data.river, id) {
      | Some(riverPixel) => {
          let uuid = Uuid.V1.toString(Uuid.V1.create())
          Some({
            id: uuid,
            pixel: {
              data: riverPixel->Belt.Array.map(row =>
                row->Belt.Array.map(p => (p, Uuid.V1.toString(Uuid.V1.create())))
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
              data: riverPixel->Belt.Array.map(row =>
                row->Belt.Array.map(p => (p, Uuid.V1.toString(Uuid.V1.create())))
              ),
            },
          })
        }
      | _ => None
      }
    }
  }
}
