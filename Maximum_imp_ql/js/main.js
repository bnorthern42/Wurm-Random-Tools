$(function() {
  $('.amount').on('input', function() {
    var $amount = $(this);
    var $table = $amount.closest('table');
    var $total = $table.find(".total");
    var extra = 23;
    $total.val(parseFloat(($amount.val()) *0.77) + extra);
  });
});
