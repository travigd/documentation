$(document).ready(function() {
    $(".site-navigation-toggle").click(function() {
        $(".site-navigation").slideToggle();
    });
    $(".docs-toc-toggle").click(function() {
        $(".docs-sidebar").slideToggle();
    });
});