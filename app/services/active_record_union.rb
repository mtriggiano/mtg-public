class ActiveRecordUnion
	attr_accessor :collection

	def initialize(collection)
		@collection = collection
	end

	def where(*args)
		@collection.where(*args)
	end

	def count(*args)
		@collection.size
	end

	def includes(*args)
		@collection.includes(*args)
	end

	def distinct(*args)
		@collection.distinct(*args)
	end

	def order(*args)
		@collection.order(*args)
	end
end