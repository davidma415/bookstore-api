desc "This is a rake file to create new authors in the github repo."

task :create_authors do
  # Replace the access token with your OAuth string.
  client = Octokit::Client.new(:access_token => 'replace with oauth')

  3.times do
    name = Faker::Name.first_name + ' ' + Faker::Name.last_name
    biography = Faker::Lorem.paragraph(sentence_count: 7)
    puts name

    client.create_issue("davidma415/bookstore-api", name, biography)
  end
end
