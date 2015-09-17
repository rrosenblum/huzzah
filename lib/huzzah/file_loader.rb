module FileLoader

  attr_accessor :site_constants

  private

  # def load_yaml(file)
  #   YAML.load_file(file)[Huzzah.environment]
  # end

  def load_files!
    require_partials
    require_pages
  end

  def require_partials
    Dir["#{Huzzah.path}/partials/**/*.rb"].each do |file|
      require file
    end
    @starting_constants = Object.constants
  end

  def require_pages
    Dir["#{Huzzah.path}/pages/**/*.rb"].each do |file|
      require file
    end
    @site_constants = Object.constants - @starting_constants
  end

  # def load_items!(item)
  #   raise "No #{item} Found" unless exists? item
  #   require_all(get_path_for(item))
  # end
  #
  # def get_path_for(*args)
  #   File.join(Huzzah.path, *args)
  # end
  #
  # def exists?(item)
  #   item_path = get_path_for(item)
  #   raise "No #{item} found" unless File.directory?(item_path) and !get_loadable_files(item_path).empty?
  #   true
  # end
  #
  # def get_loadable_files(path)
  #   Dir["#{path}/**/*.rb"]
  # end
  #
  # def require_all(path)
  #   get_loadable_files(path).each { |file| require file }
  # end
end