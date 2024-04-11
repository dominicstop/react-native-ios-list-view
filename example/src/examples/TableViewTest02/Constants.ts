
import * as Helpers from '../../functions/Helpers';

export const DUMMY_LIST_DATA = (() => {
  const items = [];

  for(let index = 0; index < 1000; index++){

    const title: string = (() => {
      const wordCount = Math.max(
        2,
        Helpers.getRandomInt(4),
      );

      return Helpers.getRandomDummyText(wordCount);
    })();

    const desc: string = (() => {
      const wordCount = Math.max(
        3,
        Helpers.getRandomInt(30),
      );

      return Helpers.getRandomDummyText(wordCount);
    })();

    items.push({
      indexID: index,
      title: title,
      desc: desc,
    });
  };

  return items;
})();

export const DELAY_PRESETS_MS = [
  200,
  400,
  600,
  800,
  1000,
  1200,
  1400,
];

export type ListDataItem = typeof DUMMY_LIST_DATA[number];
