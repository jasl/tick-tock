jQuery ->
  init = ->
    $('#wall').hide().load(Routes.moments_get_random_path()).fadeIn('slow')
  init()
  timer = $.timer(init, 5000, true)

