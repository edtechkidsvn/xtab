import { loadContent } from '../js/utils';

const defaultUrl = 'https://9gag.com/v1/group-posts/group/default/type/hot';

async function loadMemes(nextCursor) {
  const memesObject = await loadContent(`${defaultUrl}?${nextCursor || ''}`);
  return memesObject.data;
}

export default loadMemes;