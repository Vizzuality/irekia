#encoding: UTF-8

puts ''.green
puts 'Creating votes...'.green
puts '====================='.green

Proposal.all.each do |proposal|

  rand(10).times do
    create_vote :author => User.all.sample,
                :proposal => proposal.id,
                :in_favor => [true, false].sample

  end

end
