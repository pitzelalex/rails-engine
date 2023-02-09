class SimpleErrorSerializer
  attr_reader :errors

  def initialize(message)
    @errors = [
      {
        message: message
      }
    ]
  end
end
