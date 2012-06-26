jQuery ->
  moment = null
  moments_count = 0
  index = 0
  timer = $.timer(
    ->
      moment.fadeOut("slow")
      moment = moment.next()
      index++
      if index <= moments_count
        moment.fadeIn("slow")
      else
        timer.stop()
        moment.fadeOut("slow")
        init()
    , 5000, false
  )
  init = ->
    $('#wall').load(Routes.moments_get_random_path(),
      ->
        moments_count = $('#wall').children().length
        if moments_count > 0
          moment = $('#wall').children().first()
          moment.fadeIn("slow")
          if moments_count > 1
            index = 1
            timer.play()
    )
  init()
