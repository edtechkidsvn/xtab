import { loadContent } from '../js/utils';

const url = 'https://9gag.com/v1/group-posts/group/default/type/hot';

async function loadMemes() {
  const memesObject = await loadContent(url);
  return memesObject.data;
}

export default loadMemes;