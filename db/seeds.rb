User.create!(
  first_name: "Kiter",
  last_name: "D.",
  email: "kiter2509@gmail.com",
  birthday: "11-02-1999",
  phone_number: "0389845000",
  address: "Danang, Vietnam",
  password: "passw0rd",
  password_confirmation: "passw0rd",
  activated: true,
  admin: true
)

10.times do
  name = Faker::Ancient.unique.god
  tag = Tag.create!(name: name)
  tag.illustration.attach(
    io: File.open(File.join(Rails.root,'app/assets/images/夏夜の晨曦.jpg')),
    filename: 'file1.jpg'
  )
end

Vehicle.create!(name: "boat")
Vehicle.create!(name: "bus")
Vehicle.create!(name: "airplane")

tour = Tour.create!(
  name: Faker::JapaneseMedia::OnePiece.akuma_no_mi,
  description: Faker::Lorem.paragraph_by_chars(number: 1000, supplemental: false),
  kind: "fixed",
  limit: 69,
  begin_date: Faker::Time.between_dates(from: Date.today + 10, to: Date.today + 12, period: :morning),
  return_date: Faker::Time.between_dates(from: Date.today + 13, to: Date.today + 21, period: :afternoon),
  price: Faker::Number.decimal(l_digits: 3, r_digits: 2),
  departure: Faker::JapaneseMedia::OnePiece.island
)
tour.images.attach(
  io: File.open(File.join(Rails.root, 'app/assets/images/夏夜の晨曦.jpg')),
  filename: 'file1.jpg'
)

tagsArray = (1..10).to_a
vehiclesArray = (1..3).to_a

25.times do
  rd = rand(3..7)
  tour = Tour.create!(
    name: Faker::JapaneseMedia::OnePiece.akuma_no_mi,
    description: Faker::Lorem.paragraph_by_chars(number: 256, supplemental: false),
    kind: "single",
    time: "#{rd}-#{rd + rand(1..9)}",
    price: Faker::Number.decimal(l_digits: 3, r_digits: 2),
    departure: Faker::JapaneseMedia::OnePiece.island
  )
  tour.images.attach(
    io: File.open(File.join(Rails.root, 'app/assets/images/19-1-800x450.jpg')),
    filename: 'file1.jpg'
  )
  tour.images.attach(
    io: File.open(File.join(Rails.root, 'app/assets/images/22-800x450.jpg')),
    filename: 'file2.jpg'
  )
  tour.images.attach(
    io: File.open(File.join(Rails.root, 'app/assets/images/30-800x450.jpg')),
    filename: 'file3.jpg'
  )
  rand(2..3).times do
    tour.tour_tags.create(
      tag_id: tagsArray.shuffle.pop
    )
  end
  rand(1..3).times do
    tour.tour_vehicles.create(
      vehicle_id: vehiclesArray.shuffle.pop
    )
  end
end

25.times do
  tour = Tour.create!(
    name: Faker::Games::Pokemon.name,
    description: Faker::Lorem.paragraph_by_chars(number: 256, supplemental: false),
    kind: "fixed",
    limit: Faker::Number.within(range: 10..50),
    begin_date: Faker::Time.between_dates(from: Date.today + 1, to: Date.today + 2, period: :morning),
    return_date: Faker::Time.between_dates(from: Date.today + 3, to: Date.today + 11, period: :afternoon),
    price: Faker::Number.decimal(l_digits: 3, r_digits: 2),
    departure: Faker::Games::Pokemon.location
  )
  tour.images.attach(
    io: File.open(File.join(Rails.root, 'app/assets/images/30-800x450.jpg')),
    filename: 'file3.jpg'
  )
  tour.images.attach(
    io: File.open(File.join(Rails.root, 'app/assets/images/19-1-800x450.jpg')),
    filename: 'file1.jpg'
  )
  tour.images.attach(
    io: File.open(File.join(Rails.root, 'app/assets/images/22-800x450.jpg')),
    filename: 'file2.jpg'
  )
  rand(2..3).times do
    tour.tour_tags.create(
      tag_id: tagsArray.shuffle.pop
    )
  end
  rand(1..3).times do
    tour.tour_vehicles.create(
      vehicle_id: vehiclesArray.shuffle.pop
    )
  end
end
