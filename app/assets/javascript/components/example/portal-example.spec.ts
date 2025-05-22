import { expect, fixture, html } from '@open-wc/testing';
import '.../../components/example/portal-example.js';
import type { PortalExample } from '../../components/example/portal-example.js';

describe('portal-example', () => {
  it('should render', async () => {
    const el = await fixture<PortalExample>(
      html`<portal-example name="Steve Jobs"></portal-example>`
    );
    expect(el).to.exist;
  });
});
