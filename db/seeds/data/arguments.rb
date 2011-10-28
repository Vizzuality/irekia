#encoding: UTF-8

puts ''.green
puts 'Creating arguments...'.green
puts '====================='.green

Proposal.all.each do |proposal|
  rand(10).times do
    create_argument :author => User.citizens.sample,
                    :proposal => proposal.id

  end

end
