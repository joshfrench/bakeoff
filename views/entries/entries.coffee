jQuery ->
  ($ '#entry').submit ->
    confirm "Are you sure you don't want to add an image?" unless ($ '#entry_image').val()