MAX_LENGTH_PERSON_NAME = 255
WATD_ENV = YAML.load_file(Rails.root.join('config', 'config.yml'))
$gcm = GCM.new(WATD_ENV['gcm_api_key'])