`bundle install`

`bundle exec rspec`

`ruby slcsp.rb zips.csv plans.csv slcsp.csv`

Notes: the current implementation is not efficient. Next steps would involve caching the applicable sets created in `SlcspRecord#set_rate!`
