jQuery ->

  ($ '#taste-list').sortable
    containment: '#taste'
    update: (event, ui) ->
      ($ child).children('input').val(i) for child, i in ($ '#taste-list').children('li')
  
  ($ '#presentation-list').sortable
    containment: '#presentation'
    update: (event, ui) ->
      ($ child).children('input').val(i) for child, i in ($ '#presentation-list').children('li')

  ($ '#creativity-list').sortable
    containment: '#creativity'
    update: (event, ui) ->
      ($ child).children('input').val(i) for child, i in ($ '#creativity-list').children('li')
      
  ($ 'ul').disableSelection()

  ($ '#ballot_name').focus -> ($ this).val('') if ($ this).val() is 'Enter your name'
  ($ '#ballot_name').blur -> ($ this).val('Enter your name') unless ($ this).val().trim()

  ($ '#vote').submit ->
    unless valid_name()
      alert 'Please enter your name.'
      return false
    confirm("Submit this ballot? There's no going back!")

  valid_name = ->
    name = ($ '#ballot_name').val()
    name isnt 'Enter your name' and name.trim() isnt ''