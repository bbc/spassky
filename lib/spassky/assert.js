function assert(message) {
  var img = document.createElement('img');
  img.setAttribute('src', 'assert?message=' + message);
  document.body.appendChild(img);
}