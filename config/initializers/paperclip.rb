if ENV['PARALLEL_TEST_GROUPS']
  Paperclip::Attachment.default_options[:path] = ":rails_root/public/system/:rails_env/#{ENV['TEST_ENV_NUMBER'].to_i}/:class/:attachment/:id_partition/:style/:filename"
  Paperclip::Attachment.default_options[:url] = "/system/:rails_env/#{ENV['TEST_ENV_NUMBER'].to_i}/:class/:attachment/:id_partition/:style/:basename.:extension"
else
  Paperclip::Attachment.default_options[:path] = ":rails_root/public/system/:rails_env/:class/:attachment/:id_partition/:style/:filename"
  Paperclip::Attachment.default_options[:url] = "/system/:rails_env/:class/:attachment/:id_partition/:style/:basename.:extension"
end
