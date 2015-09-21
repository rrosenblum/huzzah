module PartialLoader
  def include_partial(partial)
    partial_instance = partial.new
    partial_instance.class.instance_methods(false).each do |method|
      define_method(method) do |*args|
        partial_instance.instance_variable_set("@browser", @browser)
        partial_instance.instance_variable_set("@role_data", @role_data)
        partial_instance.send(method, *args)
      end
    end
  end
end