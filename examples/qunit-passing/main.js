QUnit.done = function(result) {
  var spassky = new Spassky();
  if (result.failed > 0) {
    spassky.assert(false, "qunit failed");
  } else {
    spassky.assert(true, "qunit passed");
  }
};

test("it passes", function() {
  ok(true, "it passed");
});
