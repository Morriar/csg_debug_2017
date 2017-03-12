# BlankSlate
#
# Remove all methods from the class (keep all the "__*" methods).
class BlankSlate
	#$VERBOSE = nil
	#instance_methods.each{ |m| undef_method m unless m =~ /^__/ }
end

class XMLDocument
	@root

	def initialize(root)
		@root = XMLNode.new(root)
	end

	def xml
		return @root
	end

	# Save la chaine XML dans le fichier
	def to_s
		return format @root.render!
	end

	def format str
		formatted = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"

		str = str.gsub( /(>)(<)(\/*)/ ) { "#$1\n#$3#$2" }

		pad = 0
		str.split( "\n" ).each do |node|
			indent = 0

			case node
			when /.+<\/\w[^>]*>$/     then indent = 0                # open and closing on the same line
			when /^<\/\w/             then pad -= 1 unless pad == 0  # closing tag
			when /^<\w[^>]*[^\/]>.*$/ then indent = 1                # opening tag
			else
				indent = 0
			end

			formatted << "\t" * pad + node + "\n"
			pad += indent
		end

		return formatted
	end
end

class XMLNode < BlankSlate
	@children
	@attributes
	@name
	@value
	@parent

	def initialize(name, parent)
		@children = Array.new
		@attributes = Hash.new
		@name = name
		@parent = parent
	end

	def method_missing(sym, *args)
		if sym.to_s == @name.to_s + "!"
			return @parent
		end

		child = self.child! sym

		args.each do |arg|
			if arg.is_a? String
				child.value! arg
				return self
			end
		end

		args.each do |arg|
			if arg.is_a? Hash
				child.attributes! arg
			end
		end

		return child
	end

	def attributes! hash
		hash.each do |name, value|
			@attributes[name] = XMLAttribute.new(name, value)
		end
	end

	def value! value
		@value = value
	end

	def child! name
		child = XMLNode.new(name, self)
		@children.push(child)
		return child
	end

	def comment! comment
		@children.push( XMLComment.new(comment) )
		return self
	end

	def render!
		str = "<#{@name}"

		@attributes.each{ |key, obj| str += obj.render! }

		if( @value  != nil )
			str += ">#{@value}</#{@name}>"
		elsif( @children.length > 0 )
			str += ">"
			@children.each{ |child| str += child.render! }
			str += "</#{@name}>"
		else
			str += "/>"
		end

		return str
	end
end

class XMLAttribute
	@name
	@value

	def initialize(name, value)
		@name = name
		@value = value
	end

	def render!
		return " {@name}=\"{@value}\""
	end
end

class XMLComment
	@comment

	def initialize(comment)
		@comment = comment
	end

	def render!
		return "<!-- {@comment} -->"
	end
end
