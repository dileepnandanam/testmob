var partialHTMLLoadCount = 0;

function loadTab(url, domObj) {
    $.get(url, function (data) {
        content = data;
        $('#nav-content').append(content);
        if (url.indexOf('connections') > -1) {
            $(domObj).click();
            $("#connections").css("display", "flex");
        }
        partialHTMLLoadCount++;
        if (partialHTMLLoadCount == 7) {
            addSubmitEvent();
        }
    });
}

(function () {
    $(document).ready(function () {
        $(".nav-link").each(function () {
            loadTab($(this).data('url'), this);
        });
    });

    $(".nav-link").click(function () {
        $(".nav-link").removeClass('active');
        $(this).addClass('active');
        $('.nav-content').hide();
        $(`#${$(this).data('target-id')}`).css("display", "flex");
    });
})();