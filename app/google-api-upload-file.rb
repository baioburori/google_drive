require 'oauth2'
require 'google_drive'

CLIENT_ID = ENV['CLIENT_ID']
CLIENT_SECRET = ENV['CLIENT_SECRET']
REFRESH_TOKEN = ENV['REFRESH_TOKEN']

client = OAuth2::Client.new(
    CLIENT_ID, CLIENT_SECRET,
    :site => "https://accounts.google.com",
    :token_url => "/o/oauth2/token",
    :authorize_url => "/o/oauth2/auth"
)

auth_token = OAuth2::AccessToken.from_hash(client, { :refresh_token => REFRESH_TOKEN, :expires_at => 3600 })
auth_token = auth_token.refresh!

file_name = "test.txt"
file = File.open(file_name, 'w')
file.puts("Test Upload!!")
file.close

session = GoogleDrive.login_with_oauth(auth_token.token)
session.upload_from_file(file_name, file_name, :convert => false)
