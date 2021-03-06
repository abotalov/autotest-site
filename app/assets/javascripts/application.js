// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree
// .
$(document).ready(function () {
    $("img.update").on('click',function () {
        $('#recent').fadeTo('fast', 0.4);
        $.get('/update_manual',function (data) {
            $('#recent').html(data);
        }).done(function () {
                $('#recent').fadeTo('fast', 1);
            });
    });
    $("#dateform").submit(function(){
        $("#nightly").fadeTo('fast', 0.4);
    });


});


$(document).on("click", "img.delete", function(){
    $.post('/delete_manual', {filename:$(this).attr('filename')});
    $(this).parent().fadeOut()
} );