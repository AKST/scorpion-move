window.Demo = Demo = {}

window.preload = ->
  Demo.tune = load-sound Demo.Conf.song
  Demo.fft = new p5.FFT!


window.setup = ->
  Conf = Demo.Conf
  Demo.tune.play!
  $(\#defaultCanvas).remove!
  Demo.cxt = $(\#target)
    .width Conf.width
    .height Conf.height
    .attr 'width', Conf.width
    .attr 'height', Conf.height
    .get 0
    .get-context '2d'


window.draw = ->
  Demo.Update!
  Demo.Graphics.background-fill Demo.cxt
  Demo.Graphics.square-grid-fill Demo.cxt

