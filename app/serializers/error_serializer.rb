class ErrorSerializer
  attr_reader :errors

  def initialize(object)
    @errors = object.errors.messages.map do |error|
      {
        title: error[0].to_s,
        detail: error[1].join(', ')
      }
    end
  end
end
