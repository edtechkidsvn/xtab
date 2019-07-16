<search_bar>
  <input class="fullwidth" onkeyup={keyup} placeholder={opts.placeholder || 'Search here' } />
  <script>
    import _ from 'lodash';
    const handleSearchEvent = _.debounce(async (e) => {
      const searchString = e.target.value;
      const asciiCode = e.which;
      if (((asciiCode === 8) || (asciiCode >= 65 && asciiCode <= 98) || ( asciiCode >=48 && asciiCode <= 57))) {
        if (this.opts.search) {
          await this.opts.search(searchString);
        } else {
          console.log("Search bar need 'search' function in opts");
        }
      }
    }, 500);
    
    this.keyup = handleSearchEvent.bind(this);
  </script>
</search_bar>