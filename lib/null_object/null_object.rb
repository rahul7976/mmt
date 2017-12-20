# base class for implementation of the Null Object pattern
class NullObject

  # def initialize
  # end
  # def self.new
  #   o = allocate
  #   o.initialize
  #   o
  # end

  # method missing returning nil
  # will respond to any message with a no-op
  # def method_missing(*args, &block)
  #   nil
  # end

  # method missing returning self
  # makes it possibly to nullify arbitrary chains of method calls
  def method_missing(*args, &block)
    # puts outputs during tests, logger outputs to the logs. want to use debugger to
    # log more about the context (controller, controller action, etc)
    puts "Null Object method missing in #{self.class} with args #{args} and block #{block}"
    Rails.logger.debug "Null Object method missing in #{self.class} with args #{args} and block #{block}"
    # debugger
    self
  end

  def fetch(key, default_value = nil)
    puts "Null Object fetch in #{self.class} with key #{key} and default value #{default_value.inspect}"
    Rails.logger.debug "Null Object fetch in #{self.class} with key #{key} and default value #{default_value.inspect}"
    # debugger
    default_value
  end

  # Failure/Error: metadata['Name'] || '<Blank Name>'
  # undefined method `[]' for nil:NilClass
  def [](key)
    nil
  end
end
