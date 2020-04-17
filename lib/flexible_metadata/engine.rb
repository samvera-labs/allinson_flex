# frozen_string_literal: true

module FlexibleMetadata
  class Engine < ::Rails::Engine
    isolate_namespace FlexibleMetadata

    initializer :append_migrations do |app|
      config.paths["db/migrate"].expanded.each do |expanded_path|
        app.config.paths["db/migrate"] << expanded_path
      end
    end

    config.after_initialize do
      my_engine_root = FlexibleMetadata::Engine.root.to_s
      paths = ActionController::Base.view_paths.collect(&:to_s)
      hyrax_path = paths.detect { |path| path.match('/hyrax-') }
      paths = if hyrax_path
                paths.insert(paths.index(hyrax_path), my_engine_root + '/app/views')
              else
                paths.insert(0, my_engine_root + '/app/views')
              end
      ActionController::Base.view_paths = paths
    end
  end
end
