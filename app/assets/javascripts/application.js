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
//= require bootstrap
//= require_tree .

$(document).ready(function(){
  delete_posts();
});

function delete_posts(){
  $('a.remote-delete').click(function(){
    var link = $(this).parent();
    $.ajax({
      type: "POST",
      url: this.href,
      data: { _method: 'delete'},
      success: function() {
        link.effect('highlight', {mode: 'hide'} , 3000);
        content = $('div.span8').find('h3').html();
        if (content.match(/\d+/))
          {
            content = content.replace(content.match(/\d+/), content.match(/\d+/)-1);
            $('div.span8').find('h3').html(content);
          }
      },
      dataType: 'script'
    });
    return false;
  });
}
