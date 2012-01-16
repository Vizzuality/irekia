#encoding: UTF-8

#############
# Wadus
#############

  user = User.find_or_initialize_by_name_and_lastname_and_email('usuario dado', 'de baja', 'irekia@euskadi.net')
  user.password              = "wadus1234"
  user.password_confirmation = "wadus1234"
  user.is_woman              = false
  user.role                  = Role.find_by_name('Removed')
  user.skip_welcome          = true
  user.save!

#############
# Admin
#############

  user = User.find_or_initialize_by_name_and_lastname_and_email('Administrator', 'Administrator', 'admin@example.com')
  user.password              = "example"
  user.password_confirmation = "example"
  user.is_woman              = false
  user.role                  = Role.find_by_name('Administrator')
  user.skip_welcome          = true
  user.save!

puts '=> areas loaded'
