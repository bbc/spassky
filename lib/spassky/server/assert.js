function Spassky() {
  this.assert = function(status, message) {
    var img = document.createElement('img');
    img.setAttribute('src', '{ASSERT_POST_BACK_URL}?status=' + (status ? 'pass' : 'fail') + '&message=' + escape(message));
    document.body.appendChild(img);
  }
}
