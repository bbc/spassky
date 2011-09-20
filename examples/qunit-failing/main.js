QUnit.done = function(result) {
  var spassky = new Spassky();
  if (result.failed > 0) {
    spassky.assert(false, "qunit failed");
  } else {
    spassky.assert(true, "qunit passed");
  }
};

test("it fails", function() {
  ok(false, "it failed");
});
