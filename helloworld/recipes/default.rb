app = search(:aws_opsworks_app).first

file "/var/tmp/test.txt" do
  content "This file is so cool. #{app['shortname']}"
end
