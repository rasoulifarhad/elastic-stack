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

def flatten(object,name, event)
    if object
        if object.kind_of?(Hash) and object != {}
            object.each { |k, v| flatten(v, "#{name}[#{k}]", event) }
        else
            # [dibalite][requestPayLoad][status] 
            # convert to
            # dibalite.requestPayLoad.status
            # dotedName = name.gsub("][",".").gsub("[","").gsub("]","")
            tempName= name.gsub(/]$/, '')
	    if object.kind_of?(Integer)
                event.set("#{tempName}_i]", object)
                event.remove(name)
	    elsif object.kind_of?(Float)
                event.set("#{tempName}_f]", object)
                event.remove(name)
	    elsif object.kind_of?(String)
                event.set("#{tempName}_s]", object)
                event.remove(name)
	    elsif object.kind_of?(Array)
                event.set("#{tempName}_a]", object)
                event.remove(name)
	    elsif !!object == object     
                event.set("#{tempName}_b]", object)
                event.remove(name)
	    end
        
        end
    end
end
 
def filter(event)
    o = event.get(@field)
    if o
        flatten(o, @field, event)
    end
    #event.remove(@field)
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

