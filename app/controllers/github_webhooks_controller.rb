class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor
  protect_from_forgery prepend: true

  def github_issues(payload)
    # Get a random publishing house so we can use it to create a book.
    randomPublisher = PublishingHouse.order('RANDOM()').first
    case payload['action']
    when "opened"
      @author = Author.new(name: payload['issue']['title'], biography: payload['issue']['body'])

      @book = Book.new(title: Faker::Lorem.sentence(word_count: 3), author: @author, publisher: randomPublisher, price: 24.20)

      @author.save
      @book.save

    when "deleted"
      @author = Author.find_by name: payload['issue']['title']
      # Destroy object and associated items
      # The reload is needed to update the author's children, and then we can records associated with the author.
      @author.reload
      @author.destroy
    when "edited"
      if payload['changes']['title']
        @author = Author.find_by name: payload['changes']['title']['from']

        @author.update(name: payload['issue']['title'])
      else if payload['changes']['body']
        # Query by the title because the title didn't change
        @author = Author.find_by name: payload['issue']['title']

        @author.update(biography: payload['issue']['body'])
      end
    end
  end
end

  private

  def webhook_secret(payload)
    ENV['GITHUB_WEBHOOK_SECRET']
  end

end
