module M3
  class Validator

    def self.validate(data:, schema:, logger:)
      ensure_work_types_exist(data: data, logger: logger)

      result = schema.validate(data)
      valid  = schema.valid?(data)

      logger.info("Data valid? #{valid}")

      if valid
        return true
      else
        result&.to_a&.each do |error|
          logger.error("\nError:")
          logger.error("\s\sType: #{error['type']}")
          logger.error("\s\sDetails: #{error['details']}")
          logger.error("\nMore error information:")
          logger.error("\s\sData pointer: #{error['data_pointer']}")
          logger.error("\s\sData: #{error['data']}\n")
          logger.error("\s\sSchema pointer: #{error['schema_pointer']}")
          logger.error("\s\sSchema: #{error['schema']}\n")
        end
        raise InvalidDataError, 'Data failed to validate against schema'
      end

      valid
    end

    private

    def self.ensure_work_types_exist(data:, logger:)
      data.dig('classes').keys.each do |c|
        if c.constantize.ancestors.include?(ActiveFedora::Base) == false
          logger.error("\nThe class #{c} must inherit from ActiveFedora::Base")
          raise InvalidDataError, "The class #{c} must inherit from ActiveFedora::Base"
        end

      rescue NameError => e
        if e.message.include?('uninitialized constant')
          logger.error(%(\nThe class #{c} does not exist as a Work in this repository))
          logger.error(%(Please ensure the Work exists, e.g. by running: rails generate hyrax:work #{c}))
        elsif e.message.include?('wrong constant name')
          logger.error(%(\nThe class "#{c}" must be CamelCase))
        end
        raise e
      end
    end

    class InvalidDataError < StandardError; end
  end
end
