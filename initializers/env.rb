APP_ROOT = "/Users/jasongittler/Desktop/igg_post_validator"

YAML.load(File.open("#{APP_ROOT}/.env.yml")).each do |key, value|
  if value.is_a?(Hash)
    ENV[key.to_s + "_" + value.keys.first] = value.values.first
  else
    ENV[key.to_s] = value
  end
end

def production?
  false
end

def environment
end

def file_to_parse
end
