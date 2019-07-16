<music class="box">
  <div id="music_container">
    <audio controls id="audio_player" ref="audioPlayer">
      <source src={audioSource} type="audio/mp3" ref="audioSource">
      Your browser does not support the audio element.
    </audio>
    <div
      class="music-icon-container"
      id="view_minified"
      if={minified}
    >
      <svg onclick={showHideView} xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="none" d="M0 0h24v24H0z"/><path d="M12 3v10.55c-.59-.34-1.27-.55-2-.55-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4V7h4V3h-6z"/></svg>
      <span onclick={showHideView}>Music</span>
      <audio_controls
        state={playState}
        play={play}
        stop={stop}
        >
      </audio_controls>
    </div>
    <div
      id="view_expanded"
      if={!minified}
      >
      <div id="topview">
        <div id="title">
          <span>Music</span>
          <audio_controls
            state={playState}
            play={play}
            stop={stop}
            >
          </audio_controls>
        </div>
        <svg
          class="btn"
          xmlns="http://www.w3.org/2000/svg"
          width="18"
          height="18"
          viewBox="0 0 24 24"
          onclick={showHideView}>
          <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/><path d="M0 0h24v24H0z" fill="none"/>
        </svg>
      </div>
      <div id="content">
        <div id="plyr_containter"></div>
        <search_bar
          class="fullwidth"
          placeholder="Search for songs"
          search={onSearch}
        >
        </search_bar>
        <div id="searching" if={searching}>Searching...</div>
        <ul id="search_results" if={searchResults}>
          <li each={searchResults} musiclink={music_link} class="selectable" onclick={play} >
            <span>
              <b>{music_title}{' '}</b> by <span>{' '}{music_artist}</span>
            </span>
          </li>
        </ul>
        <div if={searchResults && searchResults.length == 0}>No search results</div>
      </div>
    </div>
  </div>
  
  <script>
    import './components/searchbar.tag';
    import './components/audiocontrols.tag';

    import { loadContent, addCors } from '../js/utils';
    import JSSoup from 'jssoup';
    import {Howl, Howler} from 'howler';

    let sound = null;

    this.playState = 'Idle';
    this.searchResults = null;
    this.searching = false;

    async function search(query) {
      this.searching = true;
      this.update();
      const searchUrl = `https://vn.chiasenhac.vn/search/real?q=${query}&type=json&rows=5&view_all=true`;
      const searchResults = await loadContent(searchUrl);
      this.searching = false;
      this.update();
      if (searchResults.length > 0 && searchResults[0].music) {
        const { data: songList } = searchResults[0].music;
        this.searchResults = songList;
        this.update();
        return songList;
      }
    }

    function stop() {
      this.playState = 'Stopped';
      this.update();
      const {audioPlayer} = this.refs;
      audioPlayer.pause();
    }

    async function play(musicLink) {
      const {audioSource, audioPlayer} = this.refs;
      if (musicLink) {
        this.playState = 'Loading stream';
        this.update();
        const songHtmlContent = await loadContent(musicLink);
        const songSoup = new JSSoup(songHtmlContent);
        const streamUrl = songSoup.find('a', 'download_item').attrs.href;
        this.playState = 'Playing';
        this.update();
        console.log(streamUrl);
        
        audioSource.setAttribute('src', streamUrl);
        audioPlayer.load();
      } else {
        this.playState = 'Playing';
        this.update();
      }
      
      audioPlayer.play();
    }

    this.onSearch = search.bind(this);

    this.play = (async (e) => {
      if (!e.item) {
        await play.bind(this)(null);
      } else {
        await play.bind(this)(e.item.music_link);
      }
    }).bind(this);

    this.stop = stop.bind(this);

    this.minified = true;
    
    this.showHideView = (() => {
      this.minified = !this.minified;
      this.update();
    }).bind(this);
  </script>

  <style>
    #view_expanded {
      width: 300px;
    }

    #topview {
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    #topview > #title {
      display: flex;
      align-items: center;
    }

    #topview > #title > span {
      font-size: 1.5em;
    }
    
    #view_minified {
      display: flex;
      align-items: center;
      cursor: pointer;
      opacity: 0.7;
    }

    #view_minified:hover {
      opacity: 1;
    }

    #topview {
      margin-bottom: 8px;
    }

    #search_results {
      list-style: none;
      padding: 0;
    }

    #searching {
      margin: 8px 0px 4px 0px;
    }

    #play_state {
      margin: 4px 0px 4px 0px;
    }

    #loading_stream {
      margin-left: 8px;
    }

    #audio_player {
      display: none;
    }

  </style>
</music>