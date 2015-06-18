
# Homepage (Root path)

get '/' do
  erb :index#, :locals => {:client_id => "ec929278fb87047f1280"}
end

get '/login' do
  client_id = 'ec929278fb87047f1280'
  redirect "https://github.com/login/oauth/authorize?scope=user:philemonlloyds&client_id=#{client_id}"
end

get '/callback' do
  # get temporary GitHub code...
  session_code = request.env['rack.request.query_hash']['code']

  # ... and POST it back to GitHub
  result = RestClient.post('https://github.com/login/oauth/access_token',
                          {
                            client_id: ENV['CLIENT_ID'] || 'ec929278fb87047f1280',
                            client_secret: ENV['CLIENT_SECRET'] || '2f6d93489179df343c2fc243d0a1aafd471d556e',
                            code: session_code,
                          },
                          accept: :json
                          )

  # extract the token and granted scopes
  session[:access_token] = JSON.parse(result)['access_token']
  client = Octokit::Client.new(:access_token => session[:access_token])

@user = User.create(
    username: client.user,
    token: session[:access_token],
    avatar_url: client.user.avatar_url,
    location: client.user.location,
    followers: client.user.followers,
    following: client.user.following,
    public_repos: client.user.public_repos,
    public_gists: client.user.public_gists,
    start_date: client.user.created_at)

  redirect '/'
end

get '/userlogin' do


end




# 3e8a7d7a66e54f67430b94826737de95c650b1d5