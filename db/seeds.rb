region = Region.find_or_create_by!(name: 'Dehradun Region')
%w[Dehradun Haridwar Uttarkashi Tehri].each do |d|
  dist = District.find_or_create_by!(name: d, region: region)
  2.times do |i|
    School.find_or_create_by!(name: "#{d} Public School #{i+1}", udise_code: nil, district: dist)
  end
end
