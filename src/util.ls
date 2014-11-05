window.Demo.Math =

  plot: (a, b) ->
    xa = a[0]
    ya = a[1]
    xb = b[0]
    yb = b[1]
    m = (yb - ya) / (xb - xa)
    return (x) ->
      (m * (x - xa)) + ya

  multiLinearPlot: (lines) ->
    lastIndex = lines.length-2

    min = lines[0][0]
    max = lines[lastIndex][0]

    equations = do =>
      for i in [0 to lines.length-2]
        do =>
          lf: lines[i][0]
          rt: lines[i+1][0]
          eq: @plot lines[i], lines[i+1]

    return (x) ->
      if x >= min and max >= x
        for e in equations
          if x >= e.lf and e.rt >= x
            return e.eq x
      else if x < min
        return equations[0].eq x
      else if x > max
        return equations[lastIndex].eq x

  colorCurve: (colors) ->
    rBuff = []
    gBuff = []
    bBuff = []

    for color in colors
      rBuff.push [color[0], color[1][0]]
      gBuff.push [color[0], color[1][1]]
      bBuff.push [color[0], color[1][2]]

    r = @multiLinearPlot rBuff
    g = @multiLinearPlot gBuff
    b = @multiLinearPlot bBuff

    return (i) ->
      new net.brehaut.Color [r(i), g(i), b(i)]

  fade: (start, end) ->
    color = @colorCurve [[0, start], [1, end]]
    return (i) ->
      color(i).toCSS()

  randRange: (min, max) ->
    all = Math.random() * 1000000

    if min >= 0 && max >= 0
      return (all % (max - min)) + min
    else if min <= 0 && max <= 0
      return (-(all % (max - min))) + max
    else if min <= 0
      return (all % (min - max)) + min

  randInt: (min, max) ->
    Math.floor(Math.random() * (max - min)) + min

window.Demo.Url =
  
  name: (name) ->
    sane = name
      .replace /[\[]/, "\\[" 
      .replace /[\]]/, "\\]" 
    regex = new RegExp "[\\?&]" + name + "=([^&#]*)" 
    extract = regex.exec location.hash
    if extract?
      decodeURIComponent extract[1].replace /\+/g, " "
    else
      ""

