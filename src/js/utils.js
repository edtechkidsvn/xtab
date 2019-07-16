import axios from 'axios';

async function waitForRandomSecs() {
  return new Promise((resolve, reject) => {
    setTimeout(() => resolve(), Math.random() * 1000);
  })
}

function addCors(url) {
  const urlWithCors = `https://cors-mx.herokuapp.com/${url}`;
  return urlWithCors;
}

async function loadContent(url, withDelay) {
  const urlWithCors = addCors(url);
  if (withDelay) {
    await waitForRandomSecs();
  }
  const response = await axios.get(urlWithCors);
  return response.data;
}

export { loadContent, addCors };