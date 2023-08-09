FactoryBot.define do
  factory :merchant do
    name { "#{Faker::TvShows::TwinPeaks.character} #{Faker::Company.suffix} #{Faker::Company.industry}" }
  end

  factory :item do
    name {"#{Faker::Food.spice} #{Faker::Dessert.topping}"}
    description {Faker::Hipster.paragraph}
    unit_price {Faker::Number.within(range: 1..100) * 100}
    merchant
  end

  factory :customer do
    first_name {Faker::Books::Dune.title}
    last_name {Faker::Creature::Dog.name}
  end

  factory :invoice do
    customer
  end

  factory :invoice_item do
    quantity {Faker::Number.within(range: 1..30)}
    item
    invoice
  end

  factory :bulk_discount do
    discount { Faker::Number.within(range: 1..100)}
    quantity { Faker::Number.within(range: 5..30)}
    merchant
  end

end