$(document).ready(function() {
    $(".docs-toc-toggle").click(function() {
        if($(".docs-sidebar").css("display","none")) {
            $(".docs-sidebar").slideToggle();
        }
    });
});