class User::UpdateService< BaseUpdateService

  attr_accessor :params, :user, :errors

  def initialize(user, params)
    if user.is_a? ::User
      self.user = user
    else
      self.user = ::User
    end

    self.params = params_permitter(params)
  end

  def call
    if validator.success?
      user.update validator.output[:user]
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
      required(:user).schema do
        optional(:first_name).filled( :str?, min_size?: 3, max_size?: 60)
        optional(:last_name).filled( :str?, min_size?: 3, max_size?: 60)
      end

    end
  end
end