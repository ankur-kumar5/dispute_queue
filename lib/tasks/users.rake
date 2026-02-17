# lib/tasks/users.rake
namespace :users do
  desc "Create demo users for each role: admin, reviewer, readonly"
  task create_demo: :environment do
    DEMO_PASSWORD = "12345678"
    roles = {
      'admin@example.com' => :admin,
      'reviewer@example.com' => :reviewer,
      'readonly@example.com' => :read_only
    }

    roles.each do |email, role|
      user = User.find_or_initialize_by(email_address: email)
      user.password = DEMO_PASSWORD || 'password'
      user.role = role
      if user.save
        puts "Created/Updated #{email} as #{role}"
      else
        puts "Failed to save #{email}: #{user.errors.full_messages}"
      end
    end
  end
end
