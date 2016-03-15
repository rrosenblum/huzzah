# :nodoc:
module FileLoader
  private

  def load_files!
    require_partials
    require_pages
    require_flows
  end

  def require_partials
    get_loadable_files_for('partials').each { |file| require file }
  end

  def require_pages
    get_loadable_files_for('pages').each { |file| require file }
  end

  def require_flows
    get_loadable_files_for('flows').each { |file| require file }
  end

  def get_loadable_files_for(item)
    Dir["#{Huzzah.path}/#{item}/**/*.rb"]
  end

  def load_config(file)
    if File.exist?(file)
      config = YAML.load_file(file)[Huzzah.environment]
      config = config.with_indifferent_access unless config.nil?
      return config
    end
    ActiveSupport::HashWithIndifferentAccess.new
  end
end
