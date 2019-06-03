<options>
  <h3>Options</h3>
  <label for="memes_enabled">Memes</label>
  <input id="memes_enabled" type="checkbox" checked={memesEnabled} onchange={memesEnabledChange} />
  <script>
    this.on('mount', () => {
      this.memesEnabled = localStorage.getItem('memesEnabled') || false;
      this.update();
    });

    this.memesEnabledChange = ((e) => {
      this.memesEnabled = e.target.checked;
      localStorage.setItem('memesEnabled', this.memesEnabled);
    }).bind(this);
  </script>
</options>