import DismissableController from 'librum-core/controllers/dismissable_controller';

import {
  queryByTestId,
  screen,
} from '@testing-library/dom';
import { setup } from 'stimulus-helpers';

const htmlFixture = `
<div data-controller="dismissable" data-testid="alert">
  <button data-action="click->dismissable#close"data-testid="button"></button>
</div>
`;
const { start, stop } = setup({
  controllers: { dismissable: DismissableController },
  htmlFixture,
});

describe('DismissableController', () => {
  beforeEach((done) => start(done));

  afterEach(() => stop());

  it('should remove the component from the DOM', () => {
    const alert = screen.queryByTestId('alert');
    const button = screen.queryByTestId('button');

    expect(alert).toBeVisible();

    button.click();

    expect(alert).not.toBeVisible();
  });
});
