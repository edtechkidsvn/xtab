<novels_list>
  <div id="novel_list_container">
    <div show={loading}>Loading...</div>
    <div class="novel-item" each={allNovels}>
      <span class="novel-title" _id={_id} _rev={_rev}>{title}</span>
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="12"
        height="12"
        viewBox="0 0 24 24"
        onclick={deleteNovel}
        _id={_id}
        _rev={_rev}
      >
        <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
        <path d="M0 0h24v24H0z" fill="none"/>
      </svg>
    </div>
  </div>
  <style>
  #novel_list_container > .novel-item {
    border-left: 2px solid #cccccc;
    padding-left: 8px;
    margin-bottom: 16px;
    color: rgba(0, 0, 170, 0.8);
    font-weight: bold;
    display: flex;
    align-items: center;
  }

  #novel_list_container > .novel-item > span {
    margin-right: 8px;
    cursor: pointer;
  }

  #novel_list_container > .novel-item > svg {
    cursor: pointer;
  }
  </style>
  <script>
    import PouchDB from 'pouchdb';
    let db = new PouchDB('novels-db');
    const riotTag = this;
    this.loading = false;
    
    async function init() {
      this.loading = true;
      this.update();
      const allNovelsResult = await db.allDocs();
      this.allNovels = await Promise.all(allNovelsResult.rows.map(async (novelRef) => {
        const novel = await db.get(novelRef.id);
        const { contents, ...rest } = novel;
        return rest;
      }));
      this.loading = false;
      this.update();
    }

    init.bind(this)();

    this.on('update', async () => {
      const novelItems = await riotTag.root.getElementsByClassName('novel-title');
      Array.from(novelItems).forEach(item => {
        const _id = item.getAttribute('_id');
        const _rev = item.getAttribute('_rev');
        item.addEventListener('click', (e) => {
          if(riotTag.opts.openNovel) {
            riotTag.opts.openNovel({ novelId: _id, novelRev: _rev });
          }
        });
      })
    });

    this.deleteNovel = (async (e) => {
      const item = e.target;
      const _id = item.getAttribute('_id');
      const _rev = item.getAttribute('_rev');
      await db.remove(_id, _rev);
      this.allNovels = this.allNovels.filter(novel => novel._id != _id);
      this.update();
    }).bind(this);

  </script>
</novels_list>