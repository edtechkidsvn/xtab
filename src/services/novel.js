import { loadContent } from '../js/utils';
import JSSoup from 'jssoup';
import _ from 'lodash';

async function loadPageCount(novelLink) {
  const content = await loadContent(novelLink);
  const soup = new JSSoup(content);
  const pageNumber = soup.find('span', 'numbpage');
  return Number.parseInt(pageNumber.string.toString().replace('Trang 1 /', ''));
}

async function loadChapterLinks(pageLink) {
  const soup = new JSSoup(await loadContent(pageLink));
  const chapterList = soup.find('div', { id: 'divtab' });
  return chapterList.find('ul').findAll('li').map(li => li.find('h4').find('a').attrs.href);
}

async function loadChapterContent(chapterLink, done) {
  const soup = new JSSoup(await loadContent(chapterLink, true));
  console.log(chapterLink);
  const title = soup.find('div', 'chapter-header').find('h1').find('a').string.toString();
  const content = soup.find('div', { id: 'divcontent' }).toString();
  if (done) {
    done();
  }
  return {
    title,
    content,
    chapterLink,
  };
}

async function loadNovel(novelLink, gotChapterCount, oneChapterDone) {
  const pageCount = await loadPageCount(novelLink);
  const pageNumbers = _.range(1, pageCount + 1);
  const chapterLinks = _.flatten(await Promise.all(pageNumbers.map(async (pageNumber) => {
    const pageLink = `${novelLink}${pageNumber}/`;
    return await loadChapterLinks(pageLink, true);
  })));
  if (gotChapterCount) {
    gotChapterCount(chapterLinks.length);
  }
  return await Promise.all(chapterLinks.map(link => loadChapterContent(link, oneChapterDone)));
}

export { loadNovel };