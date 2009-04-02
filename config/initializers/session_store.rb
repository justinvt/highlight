# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_highlight_session',
  :secret      => '6b08b13c3cd83767471b5596d2c7b01e169555d0a60e94caa7bd6394a168673ec373144f51105b4e4beb4242049d6aa954e5336577b0caea330b47c0d503e2fa'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
