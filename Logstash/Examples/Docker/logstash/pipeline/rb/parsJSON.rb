# the value of `params` is the value of the hash passed to `script_params`
# in the logstash configuration
def register(params)
    @field = params['field']
end

# the filter method receives an event and must return a list of events.
# Dropping an event means not including it in the return array,
# while creating new ones only requires you to add a new instance of
# LogStash::Event to the returned array
# def filter(event)
#	if rand >= @drop_percentage
#		return [event]
#	else
#		return [] # return empty array to cancel event
#	end
# end

def filter(event)
    o = event.get(@field)
    if o.is_a? String	
        begin
            vJson = o.gsub(/\n/,'').match(/(\[.*\]|{.*})/)[0]
            event.set(@field, JSON.parse(vJson))
	rescue => e
    	  case e.message
            when "undefined method `gsub' for nil:NilClass" then logger.debug("(DT) Your json_field [#{@field}] is nil")
            when "undefined method `[]' for nil:NilClass"
                  logger.debug("(DT) Unable to match json within field [#{@field}]"); 
                  event.tag("_jsonparsefailure") 
           else
              logger.info("(DT) Issue extracting json: ",:exception => e.class.name, :message => e.message)
              event.tag("_jsonexception")
          end	
        end
    end
    [event]
end

# The tests you define will run when the pipeline is created and will prevent it 
# from starting if a test fails.
# also verify if the tests pass using the logstash -t flag.
# test "drop percentage 100%" do
#   parameters do
#     { "percentage" => 1 }
#   end
# 
#   in_event { { "message" => "hello" } }
# 
#   expect("drops the event") do |events|
#     events.size == 0
#   end
# end

