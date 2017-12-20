# class for Variable Null Objects
class MissingVariable < NullObject

  # Failure/Error: short_name + version
  # TypeError: can't convert MissingVariable to String (MissingVariable#to_str gives MissingVariable)
  def to_str
  end

  def to_s
  end

  # def fetch(key, default_value)
  #   default_value || nil
  # end
end
