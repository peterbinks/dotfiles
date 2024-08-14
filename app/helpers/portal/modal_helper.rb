module Portal
  # You can use open modal with blocks:
  #
  # <%= open_modal_block 'exit-to-kintranet', classes: 'btn btn__warning btn__stretch' do %>
  #   Exit to Kintranet <%= icon 'info', class: 'icon__large' %>
  # <% end %>
  #
  # Or without:
  #
  # <%= open_modal 'Exit to Kintranet', 'exit-to-kintranet', classes: 'btn btn__warning btn__stretch' %>

  module ModalHelper
    include IconHelper

    # DEPRECATED. Use app/components/shared/ui/modal_component.rb instead.
    # TODO: Once all modals have been migrated from kin_modal to Shared::UI::ModalComponent, delete this.
    def kin_modal(options, &block)
      options[:active] ||= "false"
      content_tag "kin-modal", id: "modal__#{options[:id]}", active: options[:active], &block
    end

    def open_modal_block(id, **kwargs, &block)
      open_modal(capture(&block), id, kwargs)
    end

    def open_modal(text, id, classes: "text text--link", disabled: false, data: {}, **kwargs)
      content_tag(:button, text, **{
        class: classes,
        type: "button",
        data: {rspec: "open_modal__#{id}"}.merge(data),
        onclick: %{window.kin.utils.openModal("#{id}", this)},
        disabled: disabled
      }.merge(kwargs))
    end

    def close_modal(text, id, reload: false, classes: "text text--link", data: {}, **kwargs)
      onclick = %{window.kin.utils.closeModal("#{id}");}
      onclick += "window.location.reload(true)" if reload

      content_tag(:button, text, {
        class: classes,
        type: "button",
        data: {rspec: "close_modal__#{id}"}.merge(data),
        onclick: onclick
      }.merge(kwargs))
    end

    def show_dialog(text, id, classes: "text text--link", disabled: false, data: {}, **kwargs)
      content_tag(:button, text, **{
        class: classes,
        type: "button",
        data: {rspec: "open_dialog__#{id}"}.merge(data),
        onclick: %{window.kin.utils.showDialog("#{id}")},
        disabled: disabled
      }.merge(kwargs))
    end

    def hide_dialog(text, id, reload: false, classes: "text text--link", data: {}, **kwargs)
      onclick = %{window.kin.utils.hideDialog("#{id}");}
      onclick += "window.location.reload(true)" if reload

      content_tag(:button, text, {
        class: classes,
        type: "button",
        data: {rspec: "open_dialog__#{id}"}.merge(data),
        onclick: onclick
      }.merge(kwargs))
    end
  end

end
