# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Merchants
merchant_a = FactoryBot.create(:merchant)
merchant_b = FactoryBot.create(:merchant)

# Bulk Discounts
discount_a1 = FactoryBot.create(:bulk_discount, discount: 15, quantity: 6, merchant_id: merchant_a.id)
discount_a2 = FactoryBot.create(:bulk_discount, discount: 20, quantity: 10, merchant_id: merchant_a.id)
discount_a3 = FactoryBot.create(:bulk_discount, discount: 30, quantity: 15, merchant_id: merchant_a.id)
discount_a4 = FactoryBot.create(:bulk_discount, discount: 10, quantity: 20, merchant_id: merchant_a.id)

discount_b1 = FactoryBot.create(:bulk_discount, discount: 35, quantity: 1, merchant_id: merchant_b.id)
discount_b2 = FactoryBot.create(:bulk_discount, discount: 40, quantity: 5, merchant_id: merchant_b.id)
discount_b3 = FactoryBot.create(:bulk_discount, discount: 50, quantity: 10, merchant_id: merchant_b.id)
discount_b4 = FactoryBot.create(:bulk_discount, discount: 60, quantity: 20, merchant_id: merchant_b.id)

# Items
item_a1 = FactoryBot.create(:item, merchant_id: merchant_a.id, unit_price: 10000)
item_a2 = FactoryBot.create(:item, merchant_id: merchant_a.id, unit_price: 10000)
item_a3 = FactoryBot.create(:item, merchant_id: merchant_a.id, unit_price: 10000)

item_b1 = FactoryBot.create(:item, merchant_id: merchant_b.id, unit_price: 10000)
item_b2 = FactoryBot.create(:item, merchant_id: merchant_b.id, unit_price: 10000)
item_b3 = FactoryBot.create(:item, merchant_id: merchant_b.id, unit_price: 10000)


# Invoice 1
invoice_1 = FactoryBot.create(:invoice)

# invoice_1 Items: only from merchant_a
invoice_1_item_a1 = FactoryBot.create(:invoice_item, quantity: 5, unit_price: item_a1.unit_price, item_id: item_a1.id, invoice_id: invoice_1.id)
invoice_1_item_a2 = FactoryBot.create(:invoice_item, quantity: 10, unit_price: item_a2.unit_price, item_id: item_a2.id, invoice_id: invoice_1.id)
invoice_1_item_a3 = FactoryBot.create(:invoice_item, quantity: 15, unit_price: item_a3.unit_price, item_id: item_a3.id, invoice_id: invoice_1.id)

# Invoice_2
invoice_2 = FactoryBot.create(:invoice)

# invoice_2 Items: from merchant_a and merchant_b
invoice_2_item_a1 = FactoryBot.create(:invoice_item, quantity: 5, unit_price: item_a1.unit_price, item_id: item_a1.id, invoice_id: invoice_2.id)
invoice_2_item_a2 = FactoryBot.create(:invoice_item, quantity: 20, unit_price: item_a2.unit_price, item_id: item_a2.id, invoice_id: invoice_2.id)

invoice_2_item_b1 = FactoryBot.create(:invoice_item, quantity: 1, unit_price: item_b1.unit_price, item_id: item_b1.id, invoice_id: invoice_2.id)
invoice_2_item_b2 = FactoryBot.create(:invoice_item, quantity: 10, unit_price: item_b2.unit_price, item_id: item_b2.id, invoice_id: invoice_2.id)

# invoice_3
invoice_3 = FactoryBot.create(:invoice)

# invoice_3 items: only from merchant_b
invoice_3_item_b1 = FactoryBot.create(:invoice_item, quantity: 5, unit_price: item_b1.unit_price, item_id: item_b1.id, invoice_id: invoice_3.id)
invoice_3_item_b2 = FactoryBot.create(:invoice_item, quantity: 10, unit_price: item_b2.unit_price, item_id: item_b2.id, invoice_id: invoice_3.id)
invoice_3_item_b3 = FactoryBot.create(:invoice_item, quantity: 20, unit_price: item_b3.unit_price, item_id: item_b3.id, invoice_id: invoice_3.id)
