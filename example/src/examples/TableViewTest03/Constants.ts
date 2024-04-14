
import * as Helpers from '../../functions/Helpers';
import * as Colors from '../../constants/Colors';

export const COLOR_CHOICES = {
  'pink': Colors.PINK,
  'red': Colors.RED,
  'orange': Colors.ORANGE,
  'green': Colors.GREEN,
  'blue': Colors.BLUE,
  'purple': Colors.PURPLE,
};

const ColorKeys = Object.keys(COLOR_CHOICES);

export const DUMMY_LIST_DATA = (() => {
  const items = [];

  for(let index = 0; index < 1000; index++){

    const colorPaletteKey = 
      Helpers.getItemFromCyclicArray(ColorKeys, index) as keyof typeof COLOR_CHOICES;
      
    const colorPalette = COLOR_CHOICES[colorPaletteKey];

    const colorChoices = [
      colorPalette.A700,
      colorPalette.A400,
      colorPalette[500],
      colorPalette[600],
      colorPalette[700],
      colorPalette[800],
      colorPalette[900],
    ];

    const randomColorChoicesIndex = 
      Helpers.getRandomInt(colorChoices.length - 1);

    const randomColorChoice = colorChoices[randomColorChoicesIndex];

    items.push({
      indexID: index,
      colorHex: randomColorChoice,
      colorName: colorPaletteKey,
    });
  };

  return items;
})();

export type ListDataItem = typeof DUMMY_LIST_DATA[number];

export const CELL_HEIGHT = 110;
