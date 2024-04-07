
export const LorumIpsumText = "Nullam quis risus eget urna mollis ornare vel eu leo. Donec sed odio dui. Cras justo odio, dapibus ac facilisis in, egestas quam. Aenean lacinia bibendum nulla consectetur. ullamcorper non metus auctor fringilla. Lorem ipsum dolor sit amet, consectetur adipiscing elit. mattis purus amet fermentum. Integer posuere erat a ante venenatis velit aliquet. Fusce dapibus, tellus cursus commodo, tortor mauris condimentum nibh, ut fermentum massa risus. leo Pellentesque sem quam vestibulum. Sed est at lobortis. Curabitur blandit tempus porttitor. Praesent commodo magna, scelerisque nisl et. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. id elit mi porta gravida metus. Etiam malesuada magna euismod. Nulla vitae libero, pharetra augue. Duis mollis, luctus, nisi porttitor ligula, nec Morbi risus, ac, vestibulum eros. Vestibulum ligula felis euismod semper. nibh ultricies vehicula Vivamus sagittis lacus augue laoreet rutrum faucibus auctor. Maecenas diam varius magna.";

export const LorumIpsumTextNoPunctuation = (() => {
  let text = LorumIpsumText;
  
  text = text.replaceAll(".", "");
  text = text.replaceAll(",", "");
  text = text.replaceAll(";", "");

  return text;
})();

export const LorumIpsumWordsList = (() => {
  const text = LorumIpsumTextNoPunctuation.toLowerCase();
  return text.split(" ");
})();