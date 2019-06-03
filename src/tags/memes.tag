<memes>
  <h2>Memes</h2>
  <div id="memes_content">
    <div each={posts} class="meme-item">
      <div class="meme-item-title">
        <raw html={title}></raw>
      </div>
      <img class="fluid" src="{images.image460.url}" alt="{title}" show={type == 'Photo'}>
      <video class="fluid" show={type == 'Animated'} controls>
        <source src={images.image460sv && images.image460sv.url}>
      </video>
      <br>
    </div>
  </div>
  <style>
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

    this.on('mount', async () => {
      const memesData = await loadMemes();
      this.posts = memesData.posts;
      this.update();
    });

    this.on('update', () => {
      riot.mount('raw');
    })

  </script>
</memes>