<audio_controls>
  <div class="controls">
    <svg
      class={opts.state != 'Stopped' ? 'btn disabled': 'btn'}
      onclick={opts.state != 'Stopped' ? '' : opts.play}
      xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/><path d="M0 0h24v24H0z" fill="none"/></svg>
    <svg
      class={opts.state != 'Playing' ? 'btn disabled': 'btn'}
      onclick={opts.state != 'Playing' ? '' : opts.stop}
      xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"/><path d="M0 0h24v24H0z" fill="none"/></svg>
    <span id="loading_stream" if={opts.state == 'Loading stream'}>Loading stream ...</span>
  </div>

  <style>
    .controls {
      display: flex;
      align-items: center;
      margin: 8px 0px 8px 8px;
    }
  </style>
</audio_controls>