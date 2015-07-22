FOG = Fog::Compute.new(
    provider: 'AWS',
    region: 'eu-west-1',
    aws_access_key_id: ENV['CODEWATCH_AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['CODEWATCH_AWS_SECRET_ACCESS_KEY']
)
