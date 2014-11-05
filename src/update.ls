

window.Demo.Update = do ->
  Conf = Demo.Conf

  wait = (n, f) !-> 
    setTimeout f, n 

  ### enables drop physics ###
  trigged = false

  ### enables the bueller effect ###
  buelling = false

  monochrome = false

  return
    initTimed: !->
      Conf.live.grid-size = 0

      wait 500, ->

    grid-sizing: do ->
      ignore = false
      shown = false
      return ->
        if @spec[5] > 180 and not shown
          Conf.live.grid-size = 2
          ignore := true
          _ <=! wait 10
          ignore := false
          shown := true
          _ <=! wait (if @spec[5] < 180 then 200 else 10)
          shown := false
        else if not ignore
          down = ->
            _ <- wait 10
            if Conf.live.grid-size > 2
              Conf.live.grid-size -= 1
              down!
            else
              Conf.live.grid-size = 0
          down!

    low5s: ->
      ugh = @spec[5]
      if @spec[5] > 250 and Conf.live.grid-size
        Conf.live.grid-size = 2
        buelling := true
      else if buelling
        Conf.live.grid-size = 0
        buelling := false

    high800s: ->
      if @spec[900] > 90
        Conf.live.grid-size += 3

      if @spec[700] > 100
        Conf.live.flux-rate += (@spec[700] * 0.0001)
      else
        Conf.live.flux-rate = Conf.init.flux-rate
      if @spec[800] > 100
        Conf.live.flux-rate = 0.0025 + (@spec[800] * 0.0002)
      else
        Conf.live.flux-rate = 0.0025
      if @spec[900] > 80
        Conf.live.flux-rate += 0.1

    mid400s: -> 
      if @spec[400] > Conf.live.theshold.drop and not trigged
        switch Demo.Math.randInt(0,1)
          case 0
            Conf.live.colors.bg = Conf.colors.gradients.coolish
            Conf.live.colors.grid = Conf.colors.solid.white
          case 1
            Conf.live.colors.bg = Conf.colors.gradients.warmish
            Conf.live.colors.grid = Conf.colors.solid.black
        trigged := true

      if trigged 
        if @spec[400] > (Conf.live.theshold.drop * 0.75) 
          Conf.live.grid-size += 1
        if @spec[400] > (Conf.live.theshold.drop * 0.80) 
          Conf.live.grid-size += 1
        if @spec[400] > (Conf.live.theshold.drop * 0.85) 
          Conf.live.grid-size += 1

        if @spec[400] > (Conf.live.theshold.drop * 0.9) 
          Conf.live.grid-size += 2
          {bg, grid} = Conf.live.colors
          Conf.live.colors.grid = Conf.colors.invert bg
          Conf.live.colors.bg = Conf.colors.invert grid

        if @spec[400] < 20
          switch Demo.Math.rand-int 0, 3
            case 0
              Conf.live.colors.bg = Conf.colors.solid.white
              Conf.live.colors.grid = Conf.colors.solid.black
            case 1
              Conf.live.colors.bg = Conf.colors.gradients.coolish
              Conf.live.colors.grid = Conf.colors.solid.white
            case 2
              Conf.live.colors.bg = Conf.colors.gradients.warmish
              Conf.live.colors.grid = Conf.colors.solid.black
            case 3
              @untrigger!

      if @spec[400] < 10
        Conf.live.flux-rate = Conf.init.flux-rate 
        @untrigger!

    untrigger: -> 
      trigged := false
      switch Demo.Math.randInt 0, 1 
        case 0
          Conf.live.colors.bg = Conf.colors.gradients.coolish
          Conf.live.colors.grid = Conf.colors.gradients.warmish
        case 1
          Conf.live.colors.bg = Conf.colors.gradients.warmish
          Conf.live.colors.grid = Conf.colors.gradients.coolish

    update: ->
      if trigged and not buelling
        Conf.live.grid-size = 2
      @spec = Demo.fft.analyze!
      @low5s!
      @high800s!
      @grid-sizing!
      @mid400s!
      if Conf.live.grid-size == 1 
        Conf.live.grid-size = 0


      
