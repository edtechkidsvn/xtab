import JSSoup from 'jssoup'; 
import '../tags/movies.tag';
import riot from 'riot';
import PouchDB from 'pouchdb';

let moviesDb = new PouchDB('movies');

async function fetchMoviesIfNeeded() {
  console.log("Check if database fetch is needed");
  if (!checkIfFetchMoviesNeeded()) return;
  console.log("Updating...");
  const html = await loadMoviePage();
  const movies = extractMovieList(html);
  await saveMoviesToDb(movies);
  saveLastTimeFetch();
}

async function loadMoviePage() {
  const html = await (new Promise((resolve, reject) => {
    const Http = new XMLHttpRequest();
    const url ='https://cors-anywhere.herokuapp.com/https://moveek.com/dang-chieu/';
    Http.open("GET", url);
    Http.send();
  
    Http.onreadystatechange = (e) => {
      if (Http.readyState == 4) {
        resolve(Http.responseText);
      }
    }
  }));
  return html;
}

function extractMovieList(text) {
  var soup = new JSSoup(text);
  const movieItems = soup.findAll('div', 'item');
  return movieItems.map(item => {
    const title = item.find('h3').find('a').string.toString().trim();
    const imageUrl = item.find('img').attrs['data-src'];
    return {
      title,
      imageUrl,
    };
  });
}

async function saveMoviesToDb(movies) {
  await moviesDb.destroy();
  moviesDb = new PouchDB('movies');
  await Promise.all(movies.map(movie => moviesDb.post(movie)));
}

async function getMoviesFromDb() {
  const result = await moviesDb.allDocs({ include_docs: true });
  const movies = result.rows.map(row => row.doc);
  return movies;
}

function checkIfFetchMoviesNeeded() {
  const lastTimeFetchString = localStorage.getItem('lastTimeFetch');
  if (!lastTimeFetchString) return true;
  const lastTimeFetch = new Date(JSON.parse(lastTimeFetchString));
  const daysSinceThen = (new Date() - lastTimeFetch) / 3600000;
  return daysSinceThen > 23;
}

function saveLastTimeFetch() {
  localStorage.setItem('lastTimeFetch', JSON.stringify(new Date()));
}

async function main () {
  await fetchMoviesIfNeeded();
  const movies = await getMoviesFromDb();
  riot.mount('movies', { movies });
}

main();

