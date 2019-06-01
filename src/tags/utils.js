import axios from 'axios';

async function loadContent(url) {
  const response = await axios.get(url);
  return response.data;
}

export { loadContent };