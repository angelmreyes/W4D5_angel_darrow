FactoryBot.define do
  factory(:user) do
    username { Faker::Twitter.screen_name }
    password { "starwars" }
  end
end