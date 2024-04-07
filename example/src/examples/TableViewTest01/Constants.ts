
import * as Helpers from '../../functions/Helpers';

export const DUMMY_LIST_DATA = (() => {
  const items = [];

  for(let index = 0; index < 100; index++){
    const wordCount = Math.max(
      2,
      Helpers.getRandomInt(7),
    );

    const dummyText = Helpers.getRandomDummyText(wordCount);

    items.push({
      indexID: index,
      message: dummyText,
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

export const MIN_CELL_HEIGHT = 100;

export type ListDataItem = typeof DUMMY_LIST_DATA[number];
