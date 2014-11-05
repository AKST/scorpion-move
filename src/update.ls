

window.Demo.Update = do ->
  Conf = Demo.Conf

  wait = (n, f) -> 
    setTimeout f, n 

  # visual state
  trigged = false
  buelling = false
  fuzzing = false

  return
    initTimed: ->
      Conf.live.grid-size = 0

      wait 500, ->

    grid-sizing: do ->
      ignore = false
      shown = false
      return (spec) ->
        if spec[5] > 180 and not shown
          Conf.live.grid-size = 2
          ignore := true
          wait 10, ->
            ignore := false
            shown := true
            wait (if spec[5] < 180 then 200 else 10), ->
              shown := false
        else if not ignore
          down = ->
            wait 10, ->
              if Conf.live.grid-size > 2
                Conf.live.grid-size -= 1
                down()
              else
                Conf.live.grid-size = 0
          down()

    low5s: (spec) ->
      ugh = spec[5]
      if ugh > 250 and Conf.live.grid-size
        Conf.live.grid-size = 2
        buelling := true
      else if buelling
        Conf.live.grid-size = 0
        buelling := false

      if spec[700] > 100
        Conf.live.flux-rate += (spec[800] * 0.0001)
      else
        Conf.live.flux-rate = Conf.init.flux-rate
      if spec[800] > 100
        Conf.live.flux-rate = 0.0025 + (spec[800] * 0.0002)
      else
        Conf.live.flux-rate = 0.0025
      if spec[900] > 80
        Conf.live.flux-rate += 0.1

    high800s: (spec) ->
      if spec[900] > 90
        Conf.live.grid-size += 3

    mid400s: (spec) -> 
      if spec[400] > Conf.live.theshold.drop
        unless trigged
          Conf.live.colors.bg = Conf.colors.solid.white
          Conf.live.colors.grid = Conf.colors.solid.black
          Conf.live.theshold.drop = Conf.live.theshold.drop * 0.97
          trigged := true
        {bg, grid} = Conf.live.colors
        Conf.live.colors.grid = Conf.colors.invert bg
        Conf.live.colors.bg = Conf.colors.invert grid
        Conf.live.grid-size += spec[400] / 40

      if spec[400] < 20 and trigged
        switch Demo.Math.randInt(0,3)
          case 0
            Conf.live.colors.bg = Conf.colors.gradients.warmish
            Conf.live.colors.grid = Conf.colors.solid.white
          case 1
            Conf.live.colors.bg = Conf.colors.gradients.coolish
            Conf.live.colors.grid = Conf.colors.solid.white
          case 2
            Conf.live.colors.bg = Conf.colors.gradients.warmish
            Conf.live.colors.grid = Conf.colors.solid.black
          case 3
            Conf.live.theshold.drop = Conf.init.theshold.drop
            switch Demo.Math.randInt 0, 1 
              case 0
                Conf.live.colors.bg = Conf.colors.gradients.coolish
                Conf.live.colors.grid = Conf.colors.gradients.warmish
              case 1
                Conf.live.colors.bg = Conf.colors.gradients.warmish
                Conf.live.colors.grid = Conf.colors.gradients.coolish
            trigged := false

    update: ->
      spec = Demo.fft.analyze!

      @low5s spec
      @high800s spec
      @grid-sizing spec
      @mid400s spec


      
