

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
        console.log "hello"

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
        Conf.live.colors.bg = grid
        Conf.live.colors.grid = bg
        Conf.live.grid-size += spec[400] / 40

      if spec[400] == 0 and trigged
        Conf.live.theshold.drop = Conf.init.theshold.drop
        Conf.live.colors.bg = Conf.colors.gradient.coolish
        Conf.live.colors.grid = Conf.colors.graidents.warmish
        trigged := false

    update: ->
      spec = Demo.fft.analyze!

      @low5s spec
      @high800s spec
      @grid-sizing spec
      @mid400s spec


      
