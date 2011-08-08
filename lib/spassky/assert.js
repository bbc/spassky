function assert(status, message) {
  var img = document.createElement('img');
  img.setAttribute('src', 'assert?status=' + (status ? 'pass' : 'fail') + '&message=' + escape(message));
  document.body.appendChild(img);
}