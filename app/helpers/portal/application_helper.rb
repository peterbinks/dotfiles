require 'vite_rails/version'
require 'vite_rails/tag_helpers'

module Portal
  module ApplicationHelper
    include ::ViteRails::TagHelpers

    def vite_manifest
      Portal::Engine.vite_ruby.manifest
    end
  end
end
