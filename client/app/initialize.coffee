# initialize jquery spin plugin
require './spinner'

# Password visibility management

# creates a placeholder for the password
getPlaceholder = (password) ->
    placeholder = []
    placeholder.push '*' for i in [1..password.length] by 1
    return placeholder.join ''

password = $ '#password-span'
password.html getPlaceholder window.password

showPasswordButton = $ '#show-password'
hidePasswordButton = $ '#hide-password'

showPasswordButton.click ->
    password.text window.password
    showPasswordButton.hide()
    hidePasswordButton.show()

hidePasswordButton.click ->
    password.text getPlaceholder window.password
    hidePasswordButton.hide()
    showPasswordButton.show()


# Reset token management
button = $ '#generate-btn'
buttonLabel = button.html()
isUpdating = false
button.startLoading = ->
    button.text '&nbsp;'
    button.spin 'tiny'
button.endLoading = ->
    button.spin()
    button.html buttonLabel

client = require './client'
button.click ->
    unless isUpdating
        isUpdating = true
        button.startLoading()
        client.post 'token', {},
            success: (data) ->
                $('#password-span').html data.account.token
                button.endLoading()
                isUpdating = false
            error: (err) ->
                button.endLoading()
                isUpdating = false


# Menu management
$('.tab.caldav').click ->
    $('.tab.caldav.selected').removeClass 'selected'
    $('.caldavconf:visible').hide()
    $(this).addClass 'selected'
    device = $(this).data 'device'
    $(".caldavconf[data-device='#{device}']").show()

$('.tab.carddav').click ->
    $('.tab.carddav.selected').removeClass 'selected'
    $('.carddavconf:visible').hide()
    $(this).addClass 'selected'
    device = $(this).data 'device'
    $(".carddavconf[data-device='#{device}']").show()

$('select#calendar').change (ev)->
    $('option#placeholder').remove()
    #https://#{domain}/public/sync/calendars/me/THE_CALENDAR
    #iosuri :  #{domain}/public/sync/principals/me
    domain = $('#iosuri').text().split('/')[0]

    $('#thunderbirduri').text(
        'https://' + domain + '/public/sync/calendars/me/' + this.value)