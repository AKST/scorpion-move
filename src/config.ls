window.Demo.Conf = do ->

  gradient-factory = (top-left, bottom-right) ->
    (cxt, offset) !->
      Conf = Demo.Conf
      grd = cxt.createLinearGradient Conf.width, Conf.height, 0, 0
      grd.addColorStop 0, bottom-right offset
      grd.addColorStop 1, top-left offset 
      cxt.fillStyle = grd

  solid-color-factory = (color) ->
    (cxt) !->
      cxt.fillStyle = color

  warmish = gradient-factory( 
    Demo.Math.colorCurve([
      [0,   [247, 82, 170]]
      [0.3, [224, 72,  74]]
      [0.6, [255, 221,  0]]
      [1,   [247, 82, 170]]
    ]),
    Demo.Math.colorCurve([
      [0,   [224,  72,  74]]
      [0.3, [255, 191,   0]]
      [0.6, [245,  0,  139]]
      [1,   [224,  72,  74]]
    ])
  )

  coolish = gradient-factory(
    Demo.Math.colorCurve([
      [0,   [82, 247, 159]]
      [0.3, [72, 224, 224]]
      [0.6, [0,   34, 225]]
      [1,   [82, 247, 159]]
    ]),
    Demo.Math.colorCurve([
      [0,   [72,  224, 224]]
      [0.3, [0,    64, 255]]
      [0.6, [0,   245, 106]]
      [1,   [72,  224, 224]]
    ])
  )

  invert = (color) ->
    if color == @solid.black
      @solid.white
    else if color == @solid.white
      @solid.black
    else if color == @gradients.coolish
      @gradients.warmish
    else if color == @gradients.warmish
      @gradients.coolish
    else
      throw new Error "wrong color"

  return
    song: do
      song-name = Demo.Url.name \song
      if song-name
        "./tune/#{song-name}.mp3"
      else
        \./tune/zedd.mp3
    width: window.inner-width 
    height: window.inner-height
    colors:
      gradients:
        coolish: coolish
        warmish: warmish
      solid:
        black: solid-color-factory \#000
        white: solid-color-factory \#fff
      invert: invert
    init:
      theshold:
        drop: 190
        ugh: 250 
      grid-size: 2
      grid-sink: 0.8
      flux-rate: 0.0025
    live:
      theshold:
        drop: 190
      grid-size: 2
      grid-sink: 0.8
      flux-rate: 0.0025
      colors:
        grid: warmish
        bg: coolish

