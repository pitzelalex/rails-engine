class SimpleErrorSerializer
  attr_reader :errors

  def initialize(message, status: 404)
    @errors = [
      {
        detail: message,
        status: status
      }
    ]
  end
end
