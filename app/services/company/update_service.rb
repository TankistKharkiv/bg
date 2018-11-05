class Company::UpdateService < BaseUpdateService

  attr_accessor :params, :company, :errors

  def initialize(company, params)
    if company.is_a? ::Company
      self.company = company
    else
      self.company = ::Company
    end

    self.params = params_permitter(params)
  end

  def call
    if validator.success?
      company.update validator.output[:company]
    else
      self.errors = validator.errors
    end
    return validator.success?
  end
  private

  def validator
    @validator ||= schema.call(params)
  end

  def schema
    @schema||=Dry::Validation.JSON do
      configure do
        config.input_processor = :sanitizer
      end
      required(:company).schema do
        optional(:name).filled( :str?, min_size?: 3, max_size?: 60)
      end

    end
  end
end