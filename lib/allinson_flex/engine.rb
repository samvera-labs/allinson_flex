# frozen_string_literal: true
ROOT_PATH = Pathname.new(File.join(__dir__, "..", ".."))

module AllinsonFlex
  class Engine < ::Rails::Engine
    isolate_namespace AllinsonFlex

    initializer :append_migrations do |app|
      config.paths["db/migrate"].expanded.each do |expanded_path|
        app.config.paths["db/migrate"] << expanded_path
      end
    end

    initializer "webpacker.proxy" do |app|
      insert_middleware = begin
                            AllinsonFlex.webpacker.config.dev_server.present?
                          rescue
                            nil
                          end
      next unless insert_middleware

      app.middleware.insert_before(
        0, Webpacker::DevServerProxy, # "Webpacker::DevServerProxy" if Rails version < 5
        ssl_verify_none: true,
        webpacker: AllinsonFlex.webpacker
      )
    end

    config.app_middleware.use(
      Rack::Static,
      urls: ["/flexible-packs"], root: File.join(ROOT_PATH, 'public')
    )

    config.before_initialize do
      config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
    end

    config.after_initialize do
      # We want to ensure that Bulkrax is earlier in the lookup for view_paths than Hyrax.  That is
      # we favor view in Bulkrax over those in Hyrax.
      my_engine_root = AllinsonFlex::Engine.root.to_s
      hyrax_engine_root = Hyrax::Engine.root.to_s
      paths = ActionController::Base.view_paths.collect(&:to_s)
      hyrax_view_path = paths.detect { |path| path.match(%r{^#{hyrax_engine_root}}) }
      paths.insert(paths.index(hyrax_view_path), File.join(my_engine_root, 'app', 'views')) if hyrax_view_path
      ActionController::Base.view_paths = paths.uniq
    end
  end
end
