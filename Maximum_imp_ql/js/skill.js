$(function() {
  $('.qln').on('input', function() {
    var $qln = $(this);
    var $rtable = $qln.closest('table');
    var $skill = $rtable.find(".total1");
    var extra = 23;
    if(parseFloat($qln.val()) >= 23.77){
    $skill.val(parseFloat(($qln.val()) - extra) / 0.77);
  }else{
    $skill.val("less than 1")
  }
  });
});
