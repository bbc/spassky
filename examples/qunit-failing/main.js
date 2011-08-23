QUnit.done = function(result) {
  if (result.failed > 0) {
    assert(false, "qunit failed");
  } else {
    assert(true, "qunit passed");
  }
};

test("it fails", function() {
  ok(false, "it failed");
});
