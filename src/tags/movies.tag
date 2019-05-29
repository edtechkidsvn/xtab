<movies>
  <div each="{movie in opts.movies}">
    <img src="{movie.imageUrl}" alt="{movie.title}">
    <span>{movie.title}</span>
  </div>
</movies>