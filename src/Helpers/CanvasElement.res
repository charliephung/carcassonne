module CanvasElement = {
  // https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/drawImage
  @bs.send
  external drawImage: (
    Webapi__Canvas.Canvas2d.t,
    ~image: Webapi.Dom.HtmlImageElement.t,
    float,
    float,
    float,
    float,
  ) => unit = ""
}
