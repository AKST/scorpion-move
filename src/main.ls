window.Demo = Demo = {}

window.preload = ->
  if 1 ~= Demo.Url.name "pause"
    return
  Demo.tune = load-sound Demo.Conf.song
  Demo.fft = new p5.FFT!


window.setup = ->
  if 1 ~= Demo.Url.name "pause"
    return

  Conf = Demo.Conf
  Demo.tune.play!
  Demo.Update.initTimed!
  $(\#defaultCanvas).remove!
  Demo.cxt = $(\#target)
    .width Conf.width
    .height Conf.height
    .attr 'width', Conf.width
    .attr 'height', Conf.height
    .get 0
    .get-context '2d'

  $(window).on 'resize', ->
    Conf.height = window.inner-height
    Conf.width = window.inner-width
    $(\#target)
      .width Conf.width
      .height Conf.height
      .attr 'width', Conf.width
      .attr 'height', Conf.height


window.draw = ->
  if 1 ~= Demo.Url.name "pause"
    return

  Demo.Update.update!
  Demo.Graphics.background-fill Demo.cxt
  Demo.Graphics.square-grid-fill Demo.cxt

