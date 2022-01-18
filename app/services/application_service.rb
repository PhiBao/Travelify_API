class ApplicationService

  def self.call(*args, &block)
    new(*args, &block).call
  end

  def map data
    data.map do |key, value|
      {
        name: key,
        value: value.to_f,
      }
    end
  end
end
