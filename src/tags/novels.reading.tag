<novels_reading>
  <div id="page_controls" if={novel} ref="pageControls" class="{pageControlsVisible? 'visible': null}">
    <span class="btn" onclick={back} show={chapterIndex > 0} >
      <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24"><path stroke-width="2" stroke="#000000" d="M11.67 3.87L9.9 2.1 0 12l9.9 9.9 1.77-1.77L3.54 12z"/><path fill="none" d="M0 0h24v24H0z"/></svg>
    </span>
    <span id="goto_controls">
      <input value={chapterIndex + 1} type="number" onchange={goto} onkeyup={goto}>
      /
      <span>{novel.contents.length}</span>
    </span>
    <span class="btn" onclick={next} ref="btnNext" show={chapterIndex < novel.contents.length - 1} >
      <svg style="transform: rotateZ(180deg)" xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24"><path stroke-width="2" stroke="#000000" d="M11.67 3.87L9.9 2.1 0 12l9.9 9.9 1.77-1.77L3.54 12z"/><path fill="none" d="M0 0h24v24H0z"/></svg>
    </span>
  </div>
  <div if={noLastNovel}>Nothing being read yet :(</div>
  <div if={novel}>
    <div>{novel.title}</div>
    <h3 id="chaper_title">{novel.contents[chapterIndex].title}</h3>
    <raw id="content" html={novel.contents[chapterIndex].content}></raw>
  </div>
  <style>
    #page_controls.visible {
      opacity: 1;
    }

    #page_controls {
      display: flex;
      position: sticky;
      right: 0px;
      top: 0px;
      background-color: white;
      justify-content: flex-end;
      align-items: center;
      opacity: 0;
      padding: 4px 18px;
    }
    
    #page_controls .btn {
      cursor: pointer;
    }

    #goto_controls input {
      text-align: right;
      width: 36px;
      height: 20px;
    }

    #goto_controls input::-webkit-outer-spin-button,
    #goto_controls input::-webkit-inner-spin-button {
      -webkit-appearance: none;
      margin: 0;
    }

    .stroke {
      stroke-width: 5px;
    }

    #page_controls span:nth-child(n + 2) {
      margin-left: 8px;
    }

    #page_controls:hover {
      opacity: 1;
    }

    #chaper_title {
      white-space: normal;
    }

    #divcontent {
      height: 100%;
      white-space: normal;
    }
  </style>
  <script>
    import db from '../services/noveldb';
    import './raw.tag';
    import _ from 'lodash';

    riot.mount('raw');

    this.pageControlsVisible = true;

    const saveChapterIndex = (async () => {
      this.novel.lastChaperIndex = this.chapterIndex;
      const result = await db.put(this.novel);
      this.novel._rev = result.rev;
    }).bind(this);
    
    const openNovel = (async (id) => {
      try {
        const novel = await db.get(id);
        const chapterIndex = novel.lastChaperIndex || 0;
        this.novel = novel;
        this.chapterIndex = chapterIndex;
        this.update();
      } catch (err) {
        this.noLastNovel = true;
        this.update();
      }
    }).bind(this);
    
    const lastNovelId = localStorage.getItem('lastNovelId');
    const novelId = this.opts.novelId || lastNovelId;
    
    if (novelId) {
      console.log('Open novel as per user request');
      localStorage.setItem('lastNovelId', novelId);
      openNovel(novelId);
    } else {
      this.noLastNovel = true;
      this.update();
    }

    this.back = (async () => {
      if (this.chapterIndex > 0) {
        this.chapterIndex --;
        await saveChapterIndex();
        this.update();
      }
    }).bind(this);

    this.next = (async () => {
      if (this.chapterIndex < this.novel.contents.length - 1) {
        this.chapterIndex ++;
        await saveChapterIndex();
        this.update();
      }
    }).bind(this);

    const changeChapter = _.debounce(async (chapterIndex) => {
      this.chapterIndex = chapterIndex;
      await saveChapterIndex();
      this.update();
    }, 500).bind(this);

    this.goto = (async (e) => {
      const chapterIndex = Number.parseInt(e.target.value) - 1;
      if (chapterIndex <= this.novel.contents.length - 1 && chapterIndex >= 0 && chapterIndex != this.chapterIndex) {
        await changeChapter(chapterIndex);
      }
    }).bind(this);

    const hidePageControls = (_.debounce((scrollTop) => {
      this.pageControlsVisible = scrollTop < 28;
      this.update();
    }, 300)).bind(this);

    const showPageControls = ((scrollTop) => {
      this.pageControlsVisible = true;
      this.update();
      hidePageControls(scrollTop);
    }).bind(this);

    this.on('mount', () => {
      const tabContent = document.getElementById("tab_content");
      tabContent.addEventListener('scroll', (e) => {
        showPageControls(e.target.scrollTop);
      });
    });
    
  </script>
</novels_reading>