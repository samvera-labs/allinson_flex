# frozen_string_literal: true

class AllinsonFlex::WorksGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :model_name, type: :array, default: []
  class_option :include_module, type: :string, default: nil

  desc 'This generator configures works to use AllinsonFlex.'

  def banner
    say_status("info", "Configuring Works to use AllinsonFlex", :blue)
  end

  def gather_work_types
    # check if this is a hyku application
    switch!(Account.first) if defined? Account

    @work_types = model_name.presence.map(&:titleize) || AllinsonFlex::DynamicSchema.all.map(&:allinson_flex_class).uniq
    @curation_concerns = Hyrax.config.curation_concerns.map(&:to_s)
    if @work_types.blank?
      say_status("error", "No AllinsonFlex Classes have been defined. Please load or create a Profile.", :red)
      exit 0
    end
  end

  def generate_works
    @work_types.each do |work_type|
      next if @curation_concerns.include?(work_type)
      say_status("info", "GENERATING #{work_type}", :blue)
      generate "hyrax:work #{work_type}", '-f'
    end

  end

  def add_additional_modules
    # add additional modules to generated classes
    # example: rails generate allinson_flex:works --include_module ModuleName

    @work_types.each do |work_type|
      argument = options['include_module']
      say_status("info", "adding #{options['include_module']} to #{work_type.underscore}", :blue)
      file = "app/models/#{work_type.underscore}.rb"
      file_text = File.read(file)
      module_name = "  include #{options['include_module']}"

      return if file_text.include?(module_name)
      insert_into_file file, after: /WorkBehavior/ do
        "\n#{module_name}"
      end
    end
  end

  def configure_controllers
    @work_types.each do |work_type|
      file = "app/controllers/hyrax/#{work_type.pluralize.underscore}_controller.rb"
      file_text = File.read(file)
      insert = '    include AllinsonFlex::DynamicControllerBehavior'
      next if file_text.include?(insert)
      insert_into_file file, before: /    self.curation_concern_type/ do
        "#{insert}\n"
      end
    end
  end

  # @todo - all the fields go after the 'Additional Fields' button
  # @todo - contextual form labels
  def configure_forms
    @work_types.each do |work_type|
      file = "app/forms/hyrax/#{work_type.underscore}_form.rb"
      file_text = File.read(file)
      insert = '    include AllinsonFlex::DynamicFormBehavior'
      next if file_text.include?(insert)
      insert_into_file file, before: /\n  end/ do
        "\n#{insert}"
      end
    end
  end

  def configure_indexers
    @work_types.each do |work_type|
      file = "app/indexers/#{work_type.underscore}_indexer.rb"
      file_text = File.read(file)
      insert = "  include AllinsonFlex::DynamicIndexerBehavior\n  self.model_class = ::#{work_type}"
      next if file_text.include?(insert)
      insert_into_file file, before: /\nend/ do
        "\n#{insert}\n"
      end
    end

    file = "app/indexers/app_indexer.rb"
    file_text = File.read(file)
    if file_text.include?('  include Hyrax::IndexesBasicMetadata')
      comment_lines file, /  include Hyrax::IndexesBasicMetadata/
    end
  end

  def configure_models
    @work_types.each do |work_type|
      file = "app/models/#{work_type.underscore}.rb"
      file_text = File.read(file)
      insert = '  include AllinsonFlex::DynamicMetadataBehavior'
      next if file_text.include?(insert)
      if file_text.include?('  include ::Hyrax::BasicMetadata')
        insert_into_file file, before: /  include ::Hyrax::BasicMetadata/ do
          "\n#{insert}\n"
        end
        comment_lines file, /  include ::Hyrax::BasicMetadata/
      else
        insert_into_file file, before: /\nend/ do
          "\n#{insert}"
        end
      end
      insert = '  include AllinsonFlex::FoundationalMetadata'
      insert_into_file file, before: /\nend/ do
        "\n#{insert}"
      end unless file_text.include?(insert)
    end
  end

  def configure_solr_document
    file = "app/models/solr_document.rb"
    file_text = File.read(file)
    insert = '  include AllinsonFlex::DynamicSolrDocument'
    return if file_text.include?(insert)
    insert_into_file file, after: /Hyrax::SolrDocumentBehavior/ do
      "\n#{insert}"
    end
  end

  def configure_presenters
    @work_types.each do |work_type|
      file = "app/presenters/hyrax/#{work_type.underscore}_presenter.rb"
      file_text = File.read(file)
      insert = "    include AllinsonFlex::DynamicPresenterBehavior\n    self.model_class = ::#{work_type}\n    delegate(*delegated_properties, to: :solr_document)"
      next if file_text.include?(insert)
      insert_into_file file, before: /\n  end\nend/ do
        "\n#{insert}"
      end
    end
  end

  def add_views
    copy_file 'app/views/hyrax/base/_attribute_rows.html.erb', 'app/views/hyrax/base/_attribute_rows.html.erb'
  end

  def display_readme
    readme 'WORKS_README'
  end
end
