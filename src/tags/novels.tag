<novels>
  <h2>Novels</h2>
  <div class="tabbar">
    <div class="tabs">
      <span>{activeTab}</span>
      <ul>
        <li each={tab, index in tabs} class={tab.active ? 'active': null} index={index}> {tab.title}</li>
      </ul>
    </div>
  </div>
  <div id="tab_content"></div>
  <style>
  novels {
    display: flex;
    flex-direction: column;
  }
  .tabs > ul {
    list-style: none;
    display: flex;
    padding: 0;
  }
  .tabs > ul > li {
    padding-bottom: 2px;
    cursor: pointer;
  }

  .tabs > ul > li:nth-child(n+2) {
    margin-left: 8px;
  }
  
  .tabs > ul > li:hover,
  .tabs > ul > li.active {
    border-bottom: 2px solid #000000;
  }

  #tab_content {
    overflow: auto;
    height: 100%;
    position: relative;
  }
  </style>
  <script>
    import './novels.search.tag';
    import './novels.list.tag';
    import './novels.reading.tag';
    
    this.tabs = [
      {
        title: 'Reading',
        active: true,
      },
      {
        title: 'List',
        active: false,
      },
      {
        title: 'Search',
        active: false,
      },
    ]
    this.currentTabIndex = 0;

    const riotTag = this;

    function changeTab(index, opts) {
      riotTag.tabs[riotTag.currentTabIndex].active = false;
      riotTag.currentTabIndex = index;
      riotTag.tabs[riotTag.currentTabIndex].active = true;
      if (riotTag.currentTabIndex == 0) {
        riot.mount('#tab_content', 'novels_reading', opts);
      }
      else if (riotTag.currentTabIndex == 1) {
        riot.mount('#tab_content', 'novels_list', {
          openNovel: (novel) => changeTab(0, novel)
        });
      } else if (riotTag.currentTabIndex == 2) {
        riot.mount('#tab_content', 'novels_search');
      }
      riotTag.update();
    }

    async function init() {
      const liList = await this.root.getElementsByTagName('li');
      Array.from(liList).forEach(li => {
        li.addEventListener('click', (e) => {
          changeTab(Number.parseInt(e.target.getAttribute('index')));
        });
      });
    }
    init.bind(this)();
    this.on('mount', () => changeTab(0));
  </script>
</novels>