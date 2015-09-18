module FileLoader
  private
  def load_files!
    require_partials
    require_pages
  end

  def require_partials
    get_loadable_files_for('partials').each { |file| require file }
  end

  def require_pages
    get_loadable_files_for('pages').each { |file| require file }
  end

  def get_loadable_files_for(item)
    Dir["#{Huzzah.path}/#{item}/**/*.rb"]
  end

  def load_config(file)
    return YAML.load_file(file)[Huzzah.environment].with_indifferent_access if File.exists?(file)
    ActiveSupport::HashWithIndifferentAccess.new
  end
end