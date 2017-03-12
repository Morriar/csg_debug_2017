import dom

redef class XMLEntity
	fun to_dsl(t: nullable Int): String is abstract
end

redef class XMLDocument
	redef fun to_dsl(t) do
		var b = new Buffer

		b.append """require "PegMobile.rb"\n\n"""
		for child in children do
			if not child isa XMLStartTag then continue
			b.append """doc = XMLDocument.new "{{{child.tag_name}}}"\n"""
			b.append """doc.xml\n"""
			for schild in child.children do
				b.append schild.to_dsl(1)
			end
			break
		end
		return b.write_to_string
	end
end

redef class PCDATA
	redef fun to_dsl(t) do return content
end

redef class CDATA
	redef fun to_dsl(t) do return content
end

redef class XMLAttrTag
	redef fun to_dsl(t) do
		var b = new Buffer
		for i in [0..attributes.length[ do
			var attribute = attributes[i]
			b.append attribute.to_dsl
			if i != attributes.length - 1 then
				b.append ", "
			end
		end
		return b.write_to_string
	end
end

redef class XMLOnelinerTag
	redef fun to_dsl(t) do
		var b = new Buffer
		b.append ("\t" * (t or else 0))
		b.append "."
		b.append tag_name
		if attributes.not_empty then
			b.append "("
			b.append super
			b.append ")"
		end
		for child in children do
			b.append child.to_dsl
		end
		b.append "\n"
		return b.write_to_string
	end
end

redef class XMLStartTag
	redef fun to_dsl(t) do
		var b = new Buffer
		b.append ("\t" * (t or else 0))
		b.append "."
		b.append tag_name
		if attributes.not_empty or (children.length == 1 and children.first isa PCDATA) then
			b.append "("
			if children.length == 1 and children.first isa PCDATA then
				b.append "\"{children.first.to_dsl}\""
				if attributes.not_empty then
					b.append ", "
				end
			end
			b.append super
			b.append ")"
		end
		b.append "\n"
		if children.length != 1 or not children.first isa PCDATA then
			for child in children do
				b.append child.to_dsl((t or else 0) + 1)
			end
			var matching = self.matching
			if matching != null then b.append matching.to_dsl((t or else 0))
		end
		return b.write_to_string
	end
end

redef class XMLPrologTag
	redef fun to_dsl(t) do return ""
end

redef class XMLProcessingInstructionTag
	redef fun to_dsl(t) do return to_s
end

redef class XMLEndTag
	redef fun to_dsl(t) do
		var b = new Buffer
		b.append ("\t" * (t or else 0))
		b.append ".{tag_name}!\n"
		return b.write_to_string
	end
end

redef class XMLCommentTag
	redef fun to_dsl(t) do
		var b = new Buffer
		b.append ("\t" * (t or else 0))
		b.append ".comment!(\"{tag_name.substring(0, tag_name.length - 2).trim}\")\n"
		return b.write_to_string
	end
end

redef class XMLStringAttr
	redef fun to_dsl(t) do return "{name}:\"{value}\""
end

for i in [1..15] do
	var file = "tests/test{i}.res"
	print file
	var content = file.to_path.read_all
	var xml = content.to_xml

	var dsl = xml.to_dsl.split("\n")
	# dsl.pop
	# dsl.pop
	var b = new Buffer
	b.append dsl.join("\n")
	b.append "\nputs doc.to_s"
	# print b.write_to_string
	b.write_to_file "tests/test{i}.in"
end
