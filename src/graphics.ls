window.Demo.Graphics = do ->

  Demo = window.Demo
  Conf = window.Demo.Conf

  background-fill = do
    bg-color-state = 0
    (cxt) !->
      bg-color-state := 0 if bg-color-state > 1 
      bg-color-state += Conf.live.flux-rate
      Conf.live.colors.bg cxt, bg-color-state
      cxt.fillRect 0, 0, Conf.width, Conf.height

  square-grid-fill = do
    grid-color-state = 0
    (cxt) !->
      {width, height} = Conf

      if height < width
        v-offset = (width - height)/2 + height/20
        h-offset = height/20
        arean-size = height - h-offset*2
      else
        v-offset = width/20
        h-offset = (height - width)/2 + width/20
        arean-size = width - v-offset*2

      grid-color-state := 0 if grid-color-state > 1
      grid-color-state += Conf.live.flux-rate

      Conf.live.colors.grid cxt, grid-color-state

      grid-size = Conf.live.grid-size 

      box-size = arean-size / grid-size
      b-offset = box-size * (Conf.live.grid-sink / grid-size) 
      draw-size = box-size - b-offset * Conf.live.grid-sink

      for x in [0 til grid-size]
        for y in [0 til grid-size]
          cxt.fill-rect(
            (b-offset+v-offset)+(y*box-size),
            (b-offset+h-offset)+(x*box-size), 
            draw-size - b-offset,
            draw-size - b-offset,
          )

  return
    background-fill: background-fill
    square-grid-fill: square-grid-fill
