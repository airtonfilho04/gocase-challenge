# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

id_reference = 0
purchase_channel = ["SiteBR", "SiteEUA", "SiteUK"]
client_name = ["Airton", "Bruno", "Paulo", "Matheus"]
delivery_service = ["SEDEX", "EPACK", "FEDEX"]

20.times do 
  id_reference += 1
  Order.create!(
    reference: "BR#{"%06d" % id_reference}",
    purchase_channel: purchase_channel[rand(0..2)],
    client_name: client_name[rand(0..3)],
    address: Faker::Address.full_address,
    delivery_service: delivery_service[rand(0..2)],
    total_value: Faker::Commerce.price(range: 20.0..200.0, as_string: true),
    line_items: "[{#{Faker::Lorem.sentence}}, {#{Faker::Lorem.sentence}}, {#{Faker::Lorem.sentence}}]"
  )
end
