namespace :oas do
  desc "Print the OpenAPI spec"
  task generate: :environment do
    print JSON.pretty_generate(OasRails.build)
  end
end
