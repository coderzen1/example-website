namespace :icons do
  task :compile do
    puts "Compiling icons..."
    puts %x(fontcustom compile app/assets/icons/ --config=config/fontcustom.yml)
  end
end
