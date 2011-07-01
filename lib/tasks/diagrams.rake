namespace :diagrams do
  desc "Generates a complete diagram of all model classes in .dot format in the doc folder"
  task :all_models => :environment do
    `railroady -o doc/models.dot -M`
  end
end