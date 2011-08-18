QUnit.done = function(failed, passed, total, runtime){
  assert(true, "pass");

  if (failed.length() > 0) {
    assert(false, "qunit failed");
  } else {
    assert(true, "qunit passed");
  }
};

test("should pass", function() {
  ok(true, "it passed!");
});
