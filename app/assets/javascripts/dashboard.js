$(function(){
  $(".form-unban-user").on("ajax:complete", function(data, response){
    if (response.status == 200) {
      var form = $(this);
      form.attr('class', 'form-ban-user');
      form.attr('action', $(this).attr('action').replace('/unban/', '/ban/'));
      var button = form.children('.unban-user');
      button.attr('class', 'btn btn-danger btn-xs ban-user');
      button.html('<i class="fa fa-user"></i> Ban');
      add_alert('success', 'Unbanned successfully');
    } else {
      add_alert('danger', response.responseJSON['response']);
    }
  });
  $(".form-ban-user").on("ajax:complete", function(response){
    if (response.status == 200) {
      var form = $(this);
      form.attr('class', 'form-unban-user');
      form.attr('action', $(this).attr('action').replace('/ban/', '/unban/'));
      var button = form.children('.ban-user');
      button.attr('class', 'btn btn-danger btn-xs unban-user');
      button.html('<i class="fa fa-user"></i> Unban');
      add_alert('success', 'Banned successfully');
    } else {
      add_alert('danger', response.responseJSON['response']);
    }
  });
  $(".form-toggle-moderator-user").on("ajax:complete", function(response){
    if (response.status == 200) {
      var form = $(this);
      var button = form.children('.toggle-moderator-user');
      button.html('<i class="fa fa-user"></i> Restore moderator');
      add_alert('success', 'Moderator status toggled successfully');
    } else {
      add_alert('danger', response.responseJSON['response']);
    }
  });
});
