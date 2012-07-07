$('#logout-link').click(function() {
  $('#logout-form').submit();
});

$('.publish-link').click(function() {
  if(confirm('Are you sure you want to publish your most recent posts?'))
    $('#publish-form').submit();
});