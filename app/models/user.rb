# Attributes:
# * id [integer, primary, not null] - primary key
# * about [text, default=""] - TODO: document me
# * authentication_token [string] - Devise Token authenticable module
# * avatar_uid [string] - TODO: document me
# * conference [boolean] - TODO: document me
# * confirmation_sent_at [datetime] - Devise Confirmable module
# * confirmation_token [string] - Devise Confirmable module
# * confirmed_at [datetime] - Devise Confirmable module
# * created_at [datetime, not null] - creation time
# * current_sign_in_at [datetime] - Devise Trackable module
# * current_sign_in_ip [string] - Devise Trackable module
# * default_venue_id [integer] - belongs to :default_venue
# * email [string, default="", not null]
# * encrypted_password [string, default="", not null] - Devise encrypted password
# * firstname [string] - TODO: document me
# * guest [boolean] - TODO: document me
# * header_uid [string] - TODO: document me
# * last_request_at [datetime] - TODO: document me
# * last_sign_in_at [datetime] - Devise Trackable module
# * last_sign_in_ip [string] - Devise Trackable module
# * lastname [string] - TODO: document me
# * penalty [float, default=1.0] - TODO: document me
# * provider [string] - used by oauth2
# * remember_created_at [datetime] - Devise Rememberable module
# * reset_password_sent_at [datetime] - Devise Recoverable module
# * reset_password_token [string] - Devise Recoverable module
# * sign_in_count [integer, default=0] - Devise Trackable module
# * slug [text] - TODO: document me
# * summary [string] - TODO: document me
# * timezone [string] - TODO: document me
# * uid [string] - used by oauth2
# * unconfirmed_email [string] - Devise Confirmable module
# * updated_at [datetime, not null] - last update time
# * website [string] - TODO: document me
class User < ActiveRecord::Base

  # this makes `url_for` available for use in `details_for`
  include Rails.application.routes.url_helpers

  PRIOTZ = Regexp.new(Settings.priority_timezones)

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  # TODO discuss if destroing these makes sense
  # we might end up with half of a dialog.
  has_many :comments, dependent: :destroy
  has_many :messages, dependent: :destroy

  has_many :venues, dependent: :destroy # as owner
  has_many :talks, through: :venues
  has_many :participations, dependent: :destroy
  has_many :participating_venues, through: :participations, source: :venue
  has_many :reminders, dependent: :destroy
  # TODO clarify how to deal with deletions
  has_many :purchases, foreign_key: :owner_id, dependent: :nullify
  has_one :welcome_transaction, as: :source

  belongs_to :default_venue, class_name: 'Venue', dependent: :destroy

  dragonfly_accessor :header do
    default Rails.root.join('app/assets/images/defaults/user-header.jpg')
  end
  dragonfly_accessor :avatar do
    default Rails.root.join('app/assets/images/defaults/user-avatar.jpg')
  end

  acts_as_token_authenticatable

  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :email, uniqueness: true
  validates :firstname, presence: true, length: { minimum: 1, maximum: 100 }
  validates :lastname, presence: true, length: { minimum: 1, maximum: 100 }
  validates :summary, length: { maximum: 255 }
  validates :slug, presence: true
  validates_acceptance_of :accept_terms_of_use
  # TODO check if this works, especcialy the allow_nil, and does allow_nil make sense?
  validates :timezone, inclusion: { in: ActiveSupport::TimeZone.zones_map.keys },
            allow_nil: true

  # WARNING: Do not use after_save hooks in the 'user' model that will
  # save the model. The reason is that the Devise confirmable_token
  # might be reset mid-transaction.
  before_create :build_and_set_default_venue, unless: :guest?
  after_save :generate_flyers!, if: :generate_flyers?

  # for the same reason this has to happen in 2 steps
  before_create :build_welcome_transaction, unless: :guest?
  after_create :process_welcome_transaction, unless: :guest?

  include PgSearch
  multisearchable against: [:firstname, :lastname]
  pg_search_scope :search, against: [:firstname, :lastname],
    using: { tsearch: { prefix: true } },
    ignoring: :accents

  def build_and_set_default_venue
    attrs = Settings.default_venue_defaults[I18n.locale].to_hash
    build_default_venue(attrs.merge(user: self))
  end

  def name
    "#{firstname} #{lastname}"
  end

  def email_with_name
    "#{name} <#{email}>"
  end

  def about_as_plaintext
    Nokogiri::HTML(about).text
  end

  class << self
    def find_for_facebook_oauth(auth, signed_in_resource=nil)
      user = User.where(:provider => auth[:provider], :uid => auth[:uid]).first
      unless user
        user = User.new( lastname: auth[:extra][:raw_info][:last_name],
                         firstname: auth[:extra][:raw_info][:first_name],
                         provider: auth[:provider],
                         website: auth[:info][:urls][:Facebook],
                         uid: auth[:uid],
                         email: auth[:info][:email],
                         password: Devise.friendly_token[0,20] )
        user.confirm!
      end

      user.reload
    end
  end

  def details_for(talk)
    {
      id: id,
      name: name,
      role: role_for(talk),
      image: avatar.thumb('100x100#nw').url,
      stream: "t#{talk.id}-u#{id}",
      downmsg: "/t#{talk.id}/u#{id}",
      upmsg: "/live/up/t#{talk.id}/u#{id}",
      link: url_for(controller: 'users',
                    action: 'show',
                    id: to_param,
                    only_path: true)
    }
  end

  def role_for(talk)
    return :host if self == talk.user
    return :guest if talk.guests.include?(self)
    # TODO: check resulting db queries, maybe use eager loading
    # TODO: Returning :participant is a temporary implementation. It is not yet
    # dediced how to proceed since we removed the explicit participantion.
    return :participant unless guest?
    :listener
  end

  # helper for console
  def set_password!(passwd)
    self.password = self.password_confirmation = passwd
    save!
  end

  # we'll use `text` here, which plays nice with select2
  def for_select
    { id: id, text: name, img: avatar.thumb('50x50#nw').url }
  end

  def insider?
    !!(email =~ /@(voicerepublic|example)\.com$/)
  end

  def developer?
    Settings.developers.include?(email)
  end

  def remembers?(model)
    reminders.exists?( rememberable_id: model.id,
                       rememberable_type: model.class.name )
  end

  def generate_flyers?
    !guest? and (firstname_changed? or lastname_changed?)
  end

  # TODO check if `talks.reload` can be replaced with `talks(true)`
  def generate_flyers!
    venues.reload
    talks.reload.each do |talk|
      Delayed::Job.enqueue GenerateFlyer.new(id: talk.id), queue: 'audio'
    end
  end

  # TODO rewrite this as `has_many :venues_without_default, conditions: ...`
  def venues_without_default
    venues.where.not(id: default_venue_id)
  end

  def set_penalty!(penalty, deep=true)
    self.penalty = penalty
    save!
    return unless deep
    venues.each { |venue| venue.set_penalty!(penalty) }
  end

  private

  def process_welcome_transaction
    welcome_transaction.process!
  end

  protected

  def reconfirmation_required?
    provider != 'facebook' && super
  end

end
