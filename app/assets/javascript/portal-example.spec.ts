import { expect, fixture, html } from '@open-wc/testing';
import './portal-example.js';
import type { PortalExample } from './portal-example.js';

describe('portal-example', () => {
  it('should render', async () => {
    const el = await fixture<PortalExample>(
      html`<portal-example name="Steve Jobs"></portal-example>`
    );
    expect(el).to.exist;
  });
});
