<novels_list>
  <div id="novel_list_container">
    <div show={loading}>Loading...</div>
    <div class="novel-item" each={allNovels} _id={_id} _rev={_rev}>
      {title}
    </div>
  </div>
  <style>
  #novel_list_container > .novel-item {
    border-left: 2px solid #cccccc;
    padding-left: 8px;
    margin-bottom: 16px;
    cursor: pointer;
    color: rgba(0, 0, 170, 0.8);
    font-weight: bold;
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
      const novelItems = await riotTag.root.getElementsByClassName('novel-item');
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

  </script>
</novels_list>