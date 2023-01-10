BUCKET = "matt-goggin-backup"
PATH = "databases/dumbledore"
REGION = "us-east-1"

desc "PG Backup"
namespace :pg do
  desc "Backup postgres database to AWS"
  task :backup => [:environment] do
    datestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")
    backup_file = "#{Rails.root}/tmp/dumbledore_#{Rails.env}_#{datestamp}_dump.sql.gz"
    sh "pg_dump -h #{db_host} -U #{db_user} -p #{db_port} #{db_name} | gzip -c > #{backup_file}"
    send_to_amazon backup_file
    File.delete backup_file
  end

  desc "import postgres database from AWS"
  task :import, :file_name do |t, args|
    puts "THIS WILL OVERWRITE YOUR DATABASE with '#{args[:file_name]}'"
    puts "ARE YOU SURE? y/n"
    response = STDIN.gets.chomp
    raise "Aborted by user" unless response == "y"

    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke

    pull_from_amazon(args[:file_name])
  end
end

def initialize_aws_client
  Aws::S3::Client.new(
		region: REGION,
		:access_key_id => Rails.application.credentials.dig(:aws, :access_key_id),
		:secret_access_key => Rails.application.credentials.dig(:aws, :secret_access_key)
  )
end

def db_config
  Rails.configuration.database_configuration[Rails.env]
end

def db_user
  db_config["username"]
end

def db_name
  db_config["database"]
end

def db_host
  db_config["host"]
end

def db_port
  db_config["port"]
end

def send_to_amazon(file_path)
  file_name = File.basename(file_path)
  s3_client = initialize_aws_client
  response = s3_client.put_object(
    bucket: BUCKET,
    key: "#{PATH}/#{file_name}",
    body: IO.read(file_path)
  )

  puts response
  if response.etag
    puts "Upload Success"
  else
    puts "Upload Failured"
  end

  response
end

def pull_from_amazon(file_name)
  s3_client = initialize_aws_client
  tmp_file_path = "/tmp/#{file_name}"
  object = s3_client.get_object(
    response_target: tmp_file_path,
    bucket: BUCKET,
    key: "#{PATH}/#{file_name}"
  )

  sh "gzip -d #{tmp_file_path}"
  unzipped_temp_file_path = tmp_file_path[0..-4]

  sh "psql -h #{db_host} -p #{db_port} -U #{db_user} -d #{db_name} -f #{unzipped_temp_file_path}"

  sh "rm #{unzipped_temp_file_path}"
end
