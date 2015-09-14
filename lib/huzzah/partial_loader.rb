module PartialLoader
  def include_partial(partial)
    partial_instance = partial.new
    partial_instance.class.instance_methods(false).each do |method|
      define_method(method) { |*args| partial_instance.send(method, *args) }
    end
  end
end