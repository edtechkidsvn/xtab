<movies>
  <div id="movie-container">
    <h2>Show times</h2>
    <div class="movie-list">
      <div each="{movie in movies}" class="movie-item">
        <div class="movie-title">{movie.title}</div>
      </div>
    </div>
  </div>
  <style>
    #movie-container {
      display: flex;
      flex-flow: column;
      height: 100%;
    }

    .movie-list {
      overflow: auto;
      padding-right: 8px;
      padding-top: 8px;
    }

    .movie-item > img {
      height: 60px;
      width: auto;
    }

    .movie-item > .movie-title {
      font-weight: 700;
    }

    .movie-item {
      margin-bottom: 16px;
      padding-left: 8px;
      border-left: solid #cccccc 2px;
    }
  </style>
  <script>
    import JSSoup from 'jssoup';
    import PouchDB from 'pouchdb';

    let moviesDb = new PouchDB('movies-db');
    
    async function fetchMoviesIfNeeded() {
      console.log("Check if database fetch is needed");
      if (!checkIfFetchMoviesNeeded()) {
        console.log('No need for update');
        return;
      }
      console.log("Updating...");
      try {
        const html = await loadMoviePage();
        console.log("HTML loaded");
        if (html.trim()) {
          const movies = extractMovieList(html);
          console.log("Movies list extracted, saving");
          await saveMoviesToDb(movies);
          saveLastTimeFetch();
        } else {
          console.log('Cannnot load webpage');
          console.log('Skip update');  
        }
      }
      catch (err) {
        console.log('Error: ' + err.message);
        console.log('Skip update');
      }
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
      console.log("Destroying movies");
      const result = await moviesDb.allDocs();
      await Promise.all(result.rows.map(row => moviesDb.remove(row.id, row.value.rev)));
      console.log("Done");
      
      await Promise.all(movies.map(movie => {
        moviesDb.post(movie);
      }));
      console.log("Done saving");
    }

    async function getMoviesFromDb() {
      console.log("Loading movies from db");
      const result = await moviesDb.allDocs({ include_docs: true });
      const movies = result.rows.map(row => row.doc);
      return movies;
    }

    function checkIfFetchMoviesNeeded() {
      const lastTimeFetchString = localStorage.getItem('lastTimeFetch');
      if (!lastTimeFetchString) return true;
      const lastTimeFetch = new Date(JSON.parse(lastTimeFetchString));
      const hoursSinceThen = (new Date() - lastTimeFetch) / 3600000;
      console.log('hours since last time update: ' + hoursSinceThen);
      return hoursSinceThen > 23;
    }

    function saveLastTimeFetch() {
      localStorage.setItem('lastTimeFetch', JSON.stringify(new Date()));
    }

    const riotTag = this;

    async function main () {
      await fetchMoviesIfNeeded();
      const movies = await getMoviesFromDb();
      riotTag.movies = movies;
      riotTag.update();
    }

    main();
  </script>
</movies>