import { html, css, LitElement } from 'lit';
import { customElement, property } from 'lit/decorators.js';

@customElement('portal-example')
export class PortalExample extends LitElement {
  static styles = css`
    p {
      color: blue;
    }
  `;

  @property({ type: String })
  name = 'Somebody';

  render() {
    return html`<p>Hello, ${this.name}!</p>`;
  }
}

declare global {
  interface HTMLElementTagNameMap {
    'portal-example': PortalExample;
  }
}
