<raw>
    <script>
      String.prototype.replaceAll = function (find, replace) {
        var str = this;
        return str.replace(new RegExp(find, 'g'), replace);
      };
      const setInnerHTML = (() => {
        // console.log();
        this.root.innerHTML =  this.opts.html.replaceAll('<br></br>', '<br>');
      }).bind(this);

      this.on('mount', () => {
        setInnerHTML()
      });
      
      this.on('update', () => {
        setInnerHTML()
      });

    </script>
</raw>