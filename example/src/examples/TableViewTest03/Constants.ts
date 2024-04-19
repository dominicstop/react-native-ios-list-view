
import * as Helpers from '../../functions/Helpers';
import * as Colors from '../../constants/Colors';
import { TableViewProps } from 'react-native-ios-list-view';

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

export const ListReorderPresets: Array<{
  title: string;
  desc: string;
  props: Partial<TableViewProps>;
}> = [
  // Preset - 00
  {
    title: "Drag and Drop",
    desc: "Uses the native drag and drop interaction API to re-order the table view items.",
    props: {
      dragInteractionEnabled: true,
      isEditingConfig: {
        isEditing: false,
        defaultEditControlMode: 'none',
        defaultReorderControlMode: 'hidden',
      },
    }
  }, 

  // Preset - 01
  {
    title: "isEditing + Standard Reorder Control",
    desc: "Uses the the table view's `isEditing` mode + built-in re-order control to reorder the list items.",
    props: {
      dragInteractionEnabled: false,
      isEditingConfig: {
        isEditing: true,
        defaultEditControlMode: 'none',
        defaultReorderControlMode: 'visible',
      },
    },
  },

  // Preset - 02
  {
    title: "isEditing + Custom Reorder Control",
    desc: "Uses the the table view's `isEditing` mode + custom react component for the re-order control.",
    props: {
      dragInteractionEnabled: false,
      isEditingConfig: {
        isEditing: true,
        defaultEditControlMode: 'none',
        defaultReorderControlMode: 'customView',
      },
    },
  },
];

export type ListReorderPresetItem = 
  typeof ListReorderPresets[number];

export const CELL_HEIGHT = 110;
