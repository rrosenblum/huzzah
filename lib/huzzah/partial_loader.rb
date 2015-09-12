module PartialLoader
  def include_partial(partial)
    partial_instance = partial.new
    partial_instance.class.instance_methods.each do |method|
      define_method(method) do |*args|
        partial_instance.send(method, *args)
      end
    end
  end
end