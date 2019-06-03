import axios from 'axios';

async function waitForRandomSecs() {
  return new Promise((resolve, reject) => {
    setTimeout(() => resolve(), Math.random() * 1000);
  })
}

async function loadContent(url) {
  const urlWithCors = `https://cors-mx.herokuapp.com/${url}`;
  await waitForRandomSecs();
  const response = await axios.get(urlWithCors);
  return response.data;
}

export { loadContent };