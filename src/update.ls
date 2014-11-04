trigged = false

Demo.Update = ->
  spec = Demo.fft.analyze!

  if spec[400] > 195 
    unless trigged
      Demo.Conf.live.bg = Demo.Conf.colors.soild.white
      Demo.Conf.live.grid = Demo.Conf.colors.soild.black
    else
      [Demo.Conf.live.bg, Demo.Conf.live.grid] = [Demo.Conf.live.grid, Demo.Conf.live.bg]
