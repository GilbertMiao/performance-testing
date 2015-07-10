require 'rubygems'
require 'ruby-jmeter'

test do
  defaults protocol: 'http',
           domain: 'apis.aclgrc-s1.com/'

  with_json
  cache
  cookies clear_each_iteration: true
  header [
    { name: 'Accept', value: 'application/vnd.acl.v1+json' },
    { name: 'Authorization', value: 'Bearer 0e3db755b10e404702ea6743cc2f2d7ab391e7ec32315e58686dc7acaaf1efce' }
  ]

  threads count: 10 do
    post_body = File.read("test.json")
    transaction 'get csv api' do
      get name: 'get csv',
          url: 'http://apis.aclgrc-s1.com/results/control_tests/237/exceptions.csv'
    end


    post_body = File.read("test.json")
    transaction 'post interpretation api' do
      post name: 'post chart bar',
           url: 'https://xdqaprodorg.results.aclgrc-s1.com/projects/1795/controls/1676/control_tests/3075/interpretations/summarize?chart_index=0',
           raw_body: post_body do
           with_xhr
      end
     end
    end
end.run(
    path: '/usr/share/jmeter/bin/',
    file: 'jmeter.jmx',
    log: 'jmeter.log',
    jtl: 'results.csv')