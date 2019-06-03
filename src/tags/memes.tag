<memes>
  <h2>Memes</h2>
  <div id="memes_content" onscroll={scroll}>
    <div each={posts} class="meme-item">
      <div class="meme-item-title">
        <raw html={title}></raw>
      </div>
      <img class="fluid" src="{images.image460.url}" alt="{title}" show={type == 'Photo'}>
      <video class="fluid" show={type == 'Animated'} controls>
        <source src={images.image460sv && images.image460sv.url}>
      </video>
    </div>
    <div id="memes_loading" show={loading}>Loading...</div>
  </div>
  <style>
    #memes_loading {
      margin: 16px 0px;
    }

    .fluid {
      width: 100%;
      height: auto;
    }
    
    .meme-item {
      margin-bottom: 24px;
    }

    .meme-item-title {
      margin-bottom: 8px;
    }


    #memes_content {
      height: 100%;
      overflow: auto;
    }
  </style>
  <script>
    import './raw.tag';
    import loadMemes from '../services/memes';

    this.memesEnabled = localStorage.getItem('memesEnabled') || false;
    
    this.on('mount', async () => {
      this.loading = true;
      this.update();
      this.memesData = await loadMemes();
      this.posts = this.memesData.posts;
      this.loading = false;
      this.update();
    });

    this.on('update', () => {
      riot.mount('raw');
    });

    this.scroll = (async (e) => {
      if (e.target.scrollHeight - e.target.scrollTop < 1000 && !this.loading) {
        this.loading = true;
        this.update();
        this.memesData = await loadMemes(this.memesData.nextCursor);
        this.posts = [...this.posts, ...this.memesData.posts];
        this.loading = false;
        this.update();
      }
    }).bind(this);

  </script>
</memes>