$(document).on('turbolinks:load', function() {
    addSubmitEvent()
    $('button').click(function(event) {
        $(this).focus()
    })
})

function addSubmitEvent() {
    $(".form").submit(function (event) {
        var functionType = $(this).find("button[type=submit]:focus").data("value");
        const paramObj = new URLSearchParams($(this).serialize());
        const paramEntries = paramObj.entries(); //returns an iterator of decoded [key,value] tuples
        const parameters = paramsToObject(paramEntries);
        callApi(functionType, parameters);
        event.preventDefault();
    });

    $(".button_submit").click(function () {
        callApi($(this).data("action"), $(this).data("value"));
    });
    $(".input_switch").change(function () {
        console.log($(this).val());
        callApi($(this).data("action"), { value: ($(this).prop('checked'))?'on':'off' });
    });
};

function callApi(type, parameters) {
    $.post(APP_CONFIG.apiEndpoint, { api_function: type, parameters }, function (success, error) {
        console.log(success);
        $('.box').html(success.api_call)
        $('.api-response').val(success.result)
    })
}

function paramsToObject(entries) {
    let result = {}
    for (let entry of entries) { // each 'entry' is a [key, value] tupple
        const [key, value] = entry;
        result[key] = value;
    }
    return result;
}