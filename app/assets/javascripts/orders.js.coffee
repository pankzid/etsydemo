jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  payment.setupForm()

payment =
  setupForm: ->
    $('#new_order').submit ->
      $('input[type="submit"]').attr('disabled', true)
      Stripe.card.createToken($('#new_order'), payment.handleStripeResponse)
      false

  handleStripeResponse: (status, response)->
    if status == 200
      $('#new_order').append($('<input type="hidden" name="cardToken">').val(response.id))
      $('#new_order')[0].submit()
      # alert(response.id)
      # payment.enableSubmitButton()
    else
      $('#stripe_error').text(response.error.message).show()
      payment.enableSubmitButton()
      # alert(response.error.message)
    # false

  enableSubmitButton: ->
    $('input[type="submit"]').attr('disabled', false)
