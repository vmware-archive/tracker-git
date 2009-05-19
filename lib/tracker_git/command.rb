module TrackerGit
  class Command
    class << self
      def attributes(*new_attributes)
        @attributes ||= []
        @attributes.push(*new_attributes)
        new_attributes.each do |attribute|
          attr_reader attribute
        end
        @attributes
      end
    end
    
    def ==(other)
      self.class.attributes.all? do |attribute|
        send(attribute) == other.send(attribute)
      end
    end
  end
end