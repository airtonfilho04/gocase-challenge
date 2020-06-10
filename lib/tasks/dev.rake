namespace :dev do
  desc "Configure the environment"
  task setup: :environment do
    show_spinner("Deleting DB...") { %x(rails db:drop) }
    show_spinner("Creating DB...") { %x(rails db:create) }
    show_spinner("Migrating DB...") { %x(rails db:migrate) }
    show_spinner("Seeding Devlopment DB...") { %x(rails db:seed) }
    show_spinner("Seeding Test DB...") { %x(rake db:migrate db:seed RAILS_ENV=test) }
  end
  
  private

  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")    
  end
end
