window.Demo.Conf = do ->

  gradient-factory = (topLeft, bottomRight) ->
    (cxt, offset) !->
      grd = cxt.createLinearGradient Conf.width, Conf.height, 0, 0
      grd.addColorStop 0, bottomRight offset
      grd.addColorStop 1, topLeft offset 
      cxt.fillStyle = grd

  solid-color-factory = (color) ->
    (cxt) !->
      cxt.fillStyle = color

  coolish = gradient-factory( 
    Demo.Math.colorCurve([
      [0,   [247, 82, 170]],
      [0.3, [224, 72,  74]],
      [0.6, [255, 221,  0]],
      [1,   [247, 82, 170]],
    ]),
    Demo.Math.colorCurve([
      [0,   [224,  72,  74]],
      [0.3, [255, 191,   0]],
      [0.6, [245,  0,  139]],
      [1,   [224,  72,  74]],
    ])
  )

  warmish = gradient-factory(
    Demo.Math.colorCurve([
      [0,   [82, 247, 159]],
      [0.3, [72, 224, 224]],
      [0.6, [0,   34, 225]],
      [1,   [82, 247, 159]],
    ]),
    Demo.Math.colorCurve([
      [0,   [72,  224, 224]],
      [0.3, [0,    64, 255]],
      [0.6, [0,   245, 106]],
      [1,   [72,  224, 224]],
    ])
  )

  return
    song: './tune/zedd.mp3'
    width: window.inner-width 
    height: window.inner-height
    colors:
      gradients:
        coolish: coolish
        warmish: warmish
      solid:
        black: solid-color-factory \#000
        white: solid-color-factory \#fff
    init:
      theshold:
        drop: 190 # / 1.1
        ugh: 250 
      grid-size: 2
      grid-sink: 0.8
      flux-rate: 0.0025
    live:
      theshold:
        drop: 190 # / 1.1
      grid-size: 2
      grid-sink: 0.8
      flux-rate: 0.0025
      colors:
        grid: coolish
        bg: warmish

