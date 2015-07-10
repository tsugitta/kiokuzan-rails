json.ThreeBackRecord do |json|
  json.array!(@three_back_records) do |record|
    json.extract! record, :name, :score, :created_date
  end
end
json.FiveBackRecord do |json|
  json.array!(@five_back_records) do |record|
    json.extract! record, :name, :score, :created_date
  end
end
json.TenBackRecord do |json|
  json.array!(@ten_back_records) do |record|
    json.extract! record, :name, :score, :created_date
  end
end
