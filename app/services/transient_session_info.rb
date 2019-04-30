class TransientSessionInfo

    def initialize
        @dict = {}
    end

    def []=(key1,key2,value)
        @dict[key1] ||= {}
        @dict[key1][key2] = value
    end

    def [](key1,key2)
        return nil unless @dict[key1]
        @dict[key1][key2]
    end

    def [](key1)
        @dict[key1]
    end

end


$tsi = TransientSessionInfo.new
