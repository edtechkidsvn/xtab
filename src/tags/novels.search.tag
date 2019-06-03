<novels_search>
  <div id="search_panel">
    <input
      class="fullwidth"
      id="input_search"
      ref="searchInput"
      autocomplete="off"
      placeholder="Enter novel name"
    />
    <div id="search_result_container">
      <h3 if={loading}>Loading ...</h3>
      <div if={!loading}>
        <h3 if={searchResults}>
          {searchResults.length != 0 ? 'Search results' : 'No results'}
        </h3>
        <div class="search-result-iem" each={searchResults}>
          <span>{title}</span>
          <span if={novelStates[link] == 'adding'} class="add-novel-loading">...</span>
          <span if={!novelStates[link]} class="add-novel-btn active" link={link} title={title}>
            <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24"><path d="M0 0h24v24H0z" fill="none"/><path d="M13 7h-2v4H7v2h4v4h2v-4h4v-2h-4V7zm-1-5C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"/></svg>
          </span>
          <span if={novelStates[link] == 'added'} class="add-novel-btn">
            <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24"><path d="M0 0h24v24H0z" fill="none"/><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>
          </span>
        </div>
      </div>
    </div>
  </div>

  <style>
    #input_search {
      border-color: #7e7e7e;
    }

    .search-result-iem {
      margin: 0;
      margin-bottom: 16px;
      display: flex;
    }

    .add-novel-btn {
      margin-left: 8px;
      display: flex;
      align-items: center;
    }

    .add-novel-btn.active {
      cursor: pointer;
    }

    .add-novel-loading {
      margin-left: 8px;
    }

  </style>
  <script>
    import _ from 'lodash';
    import axios from 'axios';
    import JSSoup from 'jssoup';
    import PouchDB from 'pouchdb';
    import PouchDBFind from 'pouchdb-find';
    
    import { loadContent } from '../js/utils';
    import { loadNovel } from '../services/novel';

    PouchDB.plugin(PouchDBFind);
    let db = new PouchDB('novels-db');

    const riotTag = this;
    if (!riotTag.novelStates) {
      riotTag.novelStates = {};
    }

    async function doSearch(searchString) {
      riotTag.loading = true;
      riotTag.update();

      const searchUrl = `https://webtruyen.com/home/search?key=${searchString}`;
      const searchResponse = await loadContent(searchUrl);
      const soup = new JSSoup(searchResponse);
      const searchRows = soup.findAll('div', 'search-row');
      const searchResults = searchRows.map(row => {
        const a = row.find('a');
        return {
          title: a.attrs.title,
          link: a.attrs.href,
        };
      })
      .filter(result => result.link &&
        !result.link.includes('https://webtruyen.com/searching/') &&
        !result.link.includes('https://webtruyen.com/tac-gia/')
        );
      riotTag.loading = false;
      riotTag.searchResults = searchResults;
      const scanNovelInDb = 
      searchResults.forEach(async result => {
        const dbResult = await db.find({
          selector: { link: result.link }
        });
        if (dbResult.docs.length > 0) {
          riotTag.novelStates[result.link] = 'added';
          riotTag.update();
        }
      });
      riotTag.update();
    }

    async function doAdd(link, title) {
      riotTag.novelStates[link] = 'adding';
      riotTag.update();
      const contents = await loadNovel(link);
      db.post({
        title,
        link,
        contents
      });
      riotTag.novelStates[link] = 'added';
      riotTag.update();
    }

    this.on('mount', () => {
      const searchInput = this.refs.searchInput;
      searchInput.addEventListener('click', (e) => {
        e.preventDefault();
        e.target.select();
      });
      const handleSearchEvent = _.debounce(async (e) => {
        const searchString = e.target.value;
        const asciiCode = e.which;
        if (((asciiCode === 8) || (asciiCode >= 65 && asciiCode <= 98) || ( asciiCode >=48 && asciiCode <= 57))) {
          await doSearch(searchString);
        }
      }, 500);
      searchInput.addEventListener('keyup', handleSearchEvent);
    });

    this.on('update', async () => {
      const buttons = await this.root.getElementsByClassName('add-novel-btn active');
      Array.from(buttons).forEach(btn => {
        const link = btn.getAttribute('link');
        const title = btn.getAttribute('title');
        btn.addEventListener('click', async (e) => {
          await doAdd(link, title);
        });
      });
    });
  </script>
</novels_search>