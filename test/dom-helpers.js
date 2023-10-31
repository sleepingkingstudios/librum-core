const fakeDOMContentLoaded = () => {
  window.document.dispatchEvent(
    new Event('DOMContentLoaded', {
      bubbles: true,
      cancelable: true,
    })
  );
};

export const cleanupDOM = () => {
  document.body.innerHTML = '';
};

export const mountDOM = (htmlString = '') => {
  const div = document.createElement('div');
  div.id = 'mountedHtmlWrapper';
  div.innerHTML = htmlString;
  document.body.appendChild(div);

  fakeDOMContentLoaded();

  return div;
};
