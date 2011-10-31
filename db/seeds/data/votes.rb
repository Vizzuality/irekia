#encoding: UTF-8

puts ''.green
puts 'Creating votes...'.green
puts '====================='.green

Proposal.all.each do |proposal|

  rand(10).times do
    create_vote :author => User.citizens.sample,
                :proposal => proposal.id

  end

end
