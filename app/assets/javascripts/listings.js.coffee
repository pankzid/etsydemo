jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  listing.setupForm()

listing =
  setupForm: ->
    $('#new_listing').submit ->
      $('input[type="submit"]').attr('disabled', true)
      Stripe.bankAccount.createToken($('#new_listing'), listing.handleStripeResponse)
      false

  handleStripeResponse: (status, response) ->
    if status == 200
      $('#new_listing').append($('<input type="hidden" name="bankAccountToken">').val(response.id))
      $('#new_listing')[0].submit()
      # alert(response.id)
      # listing.enableSubmitButton()
    else
      $('#stripe_error').text(response.error.message).show()
      listing.enableSubmitButton()
      # alert(response.error.message)
    # false

  enableSubmitButton: ->
    $('input[type="submit"]').attr('disabled', false)
