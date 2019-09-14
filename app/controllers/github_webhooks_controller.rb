class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor
  protect_from_forgery prepend: true

  def github_issues(payload)
    # Get a random publishing house so we can use it to create a book.
    randomPublisher = PublishingHouse.order('RANDOM()').first
    case payload['action']
    when "opened"

      Author.transaction do
        @author = Author.create(name: payload['issue']['title'], biography: payload['issue']['body'])

        Book.transaction do
          @book = Book.create(title: Faker::Lorem.sentence(word_count: 3), author: @author, publisher: randomPublisher, price: 24.20)
        end
      end
    when "deleted"
      @author = find_author(payload['issue']['title'])
      # Destroy object and associated items
      # The reload is needed to update the author's children, and then we can records associated with the author.
      Author.transaction do
        @author.reload
        @author.destroy
      end
    when "edited"
      if payload['changes']['title']
        @author = find_author(payload['changes']['title']['from'])

        Author.transaction do
          @author.update(name: payload['issue']['title'])
        end

      else if payload['changes']['body']
        # Query by the title because the title didn't change
        @author = find_author(payload['issue']['title'])

        Author.transaction do
          @author.update(biography: payload['issue']['body'])
        end
      end
    end
  end
end

  private
  def find_author(name)
    @author = Author.find_by name: name
    # Raise an error if we're unable to find an author
    raise ActiveRecord::RecordNotFound if !@author

    return @author
  end
  def webhook_secret(payload)
    ENV['GITHUB_WEBHOOK_SECRET']
  end

end
