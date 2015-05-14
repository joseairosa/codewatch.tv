$(function(){
  $(".form-unban-user").on("ajax:complete", function(){
    var form = $(this);
    form.attr('class', 'form-ban-user');
    form.attr('action', $(this).attr('action').replace('/unban/', '/ban/'));
    var button = form.children('.unban-user');
    button.attr('class', 'btn btn-danger btn-xs ban-user');
    button.html('<i class="fa fa-user"></i> Ban');
  });
  $(".form-ban-user").on("ajax:complete", function(){
    var form = $(this);
    form.attr('class', 'form-unban-user');
    form.attr('action', $(this).attr('action').replace('/ban/', '/unban/'));
    var button = form.children('.ban-user');
    button.attr('class', 'btn btn-danger btn-xs unban-user');
    button.html('<i class="fa fa-user"></i> Unban');
  });
  $(".form-toggle-moderator-user").on("ajax:complete", function(){
    var form = $(this);
    var button = form.children('.toggle-moderator-user');
    button.html('<i class="fa fa-user"></i> Restore moderator');
  });
});
