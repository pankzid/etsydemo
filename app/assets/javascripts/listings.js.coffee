jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  payment.setupForm()

payment =
  setupForm: ->
    $('#new_order').submit ->
      $('input[type="submit"]').attr('disabled', true)
      Stripe.createToken($('#new_order'), payment.handleStripeResponse)
      false

  handleStripeResponse: (status, response)->
    if status == 200
      alert(response.id)
      payment.enableSubmitButton()
    else
      alert(response.error.message)
      payment.enableSubmitButton()
    false

  enableSubmitButton: ->
    $('input[type="submit"]').attr('disabled', false)
