#encoding: UTF-8

puts ''.green
puts 'Creating arguments...'.green
puts '====================='.green

proposal = ProposalData.find_by_title('Actualizar la información publicada sobre las ayudas a familias numerosas').proposal

65.times do
  create_argument :author => [@andres, @aritz, @maria].sample,
                  :proposal => proposal.title

end

57.times do
  create_argument :author => [@andres, @aritz, @maria].sample,
                  :proposal => proposal.title,
                  :in_favor => false
end

Proposal.where('id <> ?', proposal.id).each do |proposal|
  rand(5).times do
    create_argument :author => User.citizens.sample,
                    :proposal => proposal.id

  end

  rand(5).times do
    create_argument :author => User.citizens.sample,
                    :in_favor => false,
                    :proposal => proposal.id

  end
end
