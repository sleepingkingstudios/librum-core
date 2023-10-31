import { Application } from '@hotwired/stimulus';

import {
  cleanupDOM,
  mountDOM,
} from 'dom-helpers';

export const setup = ({ controllers, htmlFixture }) => {
  let application = null;

  const start = (doneFn) => {
    application = Application.start();

    Object.entries(controllers).forEach(
      ([name, controller]) => application.register(name, controller)
    );

    if (htmlFixture) { mountDOM(htmlFixture); }

    Promise.resolve().then(() => doneFn());
  };

  const stop = () => {
    cleanupDOM();

    application.stop();
  };

  return {
    start,
    stop,
  };
};
