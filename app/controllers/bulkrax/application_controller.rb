# frozen_string_literal: true

module FlexibleMetadata
  class ApplicationController < ::ApplicationController
    helper Rails.application.class.helpers
    protect_from_forgery with: :exception
  end
end
