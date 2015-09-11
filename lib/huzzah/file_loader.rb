module FileLoader
  private

  def load_yaml(file)
    YAML.load_file(file)[Huzzah.environment]
  end

  def load_files!
    load_items!('partials')
    load_items!('sites')
    load_items!('pages')
  end

  def load_items!(item)
    raise "No #{item} Found" unless exists? item
    require_all(get_path_for(item))
  end

  def get_path_for(*args)
    File.join(Huzzah.config_path, *args)
  end

  def exists?(item)
    item_path = get_path_for(item)
    raise "No #{item} found" unless File.directory?(item_path) and !get_loadable_files(item_path).empty?
    true
  end

  def get_loadable_files(path)
    Dir["#{path}/**/*.rb"]
  end

  def require_all(path)
    get_loadable_files(path).each { |file| require file }
  end
end