$: << './lib'

require 'awesome_print'

Dir.glob('./lib/*.rb').each do |file|
  require file
end
